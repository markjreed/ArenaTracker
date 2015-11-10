require 'json'

class ReportsController < ApplicationController

  def index
    logger.debug "INTO REPORTS INDEX. HI."
  end

  def run
    @params = params
    send params[:report_type].intern
  end

  # Break up the string of talents and tally them, ignoring those we don't
  # care about.
  def tally_talents(record, b_won, talent_string, glyph_string)
    talents = talent_string.split(",")
    glyphs = glyph_string.split(",")
    tally = record[:talent_tally]
    
    logger.debug("Adding talents to records for b_won: " + b_won.to_s)
    talents.each do |talent|    
      logger.debug("Adding or updating talent: " + talent)
             
      tal_tally = tally[talent] ||= { talent: talent, wins: 0, losses: 0}
      
      # Update the count and list of matches
      if b_won                 
        logger.debug ("Adding one to talent win, which is now: " + (tal_tally[:wins] + 1).to_s)
        tal_tally[:wins] += 1
      else
        logger.debug ("Adding one to talent loss, which is now: " + (tal_tally[:losses] + 1).to_s)
        tal_tally[:losses] += 1        
      end    
    end
       
  end
  
  def qualifying_matches
      logger = Logger.new('test.log')
      
      # get other player info:
      if params[:player_id2].to_i > 0
        @player2 = Player.find params[:player_id2]
        logger.debug "Looking for matches with '#{@player2.name}'"
        matches = @player.matches & @player2.matches
        if matches.empty? 
          logger.debug "None found"
          return
        end
      else
        @player2 = nil
        matches = @player.matches
      end
      
      # get rating info:
      min_rating = params[:min_rating].to_i
      max_rating = params[:max_rating].to_i
      logger.debug "Looking for matches min '#{min_rating}'"
      logger.debug "Looking for matches max '#{max_rating}'"
      
      if min_rating > 1 and max_rating < 4000
        matches.each do |match|
        
          qualifying_matches = {}
          
          if match.mmr_list.length > 1
            logger.debug "match has some scores: '#{match.mmr_list.length}'"
            mmr_list = match.mmr_list
            mmr_list[0] = '' 
            avg_mmr = mmr_list.split(",").map(&:to_i).instance_eval { reduce(:+) / size.to_f.round }
            logger.debug "average mmr: '#{avg_mmr}'"
            if avg_mmr > min_rating and avg_mmr < max_rating
              qualifying_matches << match
            end # qualifies based on mmr          
          end # if there are mmrs        
        end
      else
        qualifying_matches = matches
      end # for each match, check match-related things
      
      return qualifying_matches
  end
  
  def vsspec
    logger = Logger.new('test.log')
    # Get our hash ready
    @records_by_spec = { }
    @records_by_team = { }
    @total_matches = 0 # total matches for the given player.
    @total_single_spec_stats = 0 # should be double the number of matches minus one for each match with double specs
    @total_teams_seen = 0 # should be the number of matches seen.
    @total_wins = 0
    @total_losses = 0

    @players = Player.all.order(:name)

    b_won = 0

    #start_time = DateTime.new(2013, 10, 16, 18, 0)
    #end_time = DateTime.new(2019, 10, 16, 23, 59)
    logger.debug "From date: " + @params[:from_date]
    logger.debug "To date: " + @params[:to_date] 
    start_time = DateTime.parse(@params[:from_date])
    end_time = DateTime.parse(@params[:to_date])

    @player = Player.find @params[:player_id]
    
    matches = qualifying_matches()
=begin    
    # get other player info:
    if params[:player_id2].to_i > 0
      @player2 = Player.find params[:player_id2]
      logger.debug "Looking for matches with '#{@player2.name}'"
      matches = @player.matches & @player2.matches
      if matches.empty? 
        logger.debug "None found"
        return
      end
    else
      @player2 = nil
      matches = @player.matches
    end
=end
        
    # Get all the scores for that player
    @player.scores.select { |s| matches.include?(s.match) }.each do |my_score|
      logger.debug "MY SCORE: " + my_score.as_json.to_s
      # Grab out the match that matches =)
      match = my_score.match
      logger.debug "THE MATCH: " + match.as_json.to_s
      # Get the date/time associated with the score to see if we care.
      # match_time = match.date_time.strptime("%Y-%m-%dT%H:%M:%S")      
      match_time = match.date_time.to_datetime
      
      logger.debug "Start time: " + start_time.strftime('%c')
      logger.debug start_time.strftime("%Z")
      
      logger.debug "End time: " + end_time.strftime('%c')
      logger.debug end_time.strftime("%Z")
      
      logger.debug "Match time: " + match_time.strftime('%c')
      logger.debug match_time.strftime("%Z")
      
      logger.debug ("m > s?: " + (match_time > start_time).to_s)
      logger.debug (((match_time - start_time) / 3600).round).to_s
      
      logger.debug ("m < e?: " + (match_time < end_time).to_s)
      logger.debug (((end_time - match_time) / 3600).round).to_s
      
      if (match_time > start_time) and (match_time < end_time)        
        logger.debug "Match in right time period"
        
          # For that match, see if we won or lost.
          b_won = (match.winning_faction == my_score.player_faction) ? true : false

          @counted = 0
          specs_seen = Array.new

          # Find all the OTHER scores associated with that match ID
          match.scores.each do |single_match_score|
            logger.debug "MATCH SCORE: " + single_match_score.as_json.to_s

            # If the score isn't OUR score, look at the specs
            logger.debug "player id from score: " + single_match_score.player_id.to_s
            logger.debug "my player id: " + @player.id.to_s
            logger.debug "my player id from score: " + my_score.player_id.to_s
            logger.debug "my faction: " + my_score.player_faction.to_s
            logger.debug "faction from score: " + single_match_score.player_faction.to_s
            # Make sure the score seen isn't yours or a teammate's
            if (single_match_score.player_id != @player.id) and (my_score.player_faction != single_match_score.player_faction)
              logger.debug "RECORD"
              # Make the spec name
              opposing_spec = Player.find_by(id: single_match_score.player_id).class_name + "-" + Player.find_by(id: single_match_score.player_id).spec_name
              logger.debug "Spec name generated: " + opposing_spec

              # If the score isn't OUR score, look at the specs
              logger.debug "player id from score: " + single_match_score.player_id.to_s
              logger.debug "my player id: " + @player.id.to_s
              logger.debug "my player id from score: " + my_score.player_id.to_s
              logger.debug "my faction: " + my_score.player_faction.to_s
              logger.debug "faction from score: " + single_match_score.player_faction.to_s
              # Make sure the score seen isn't yours or a teammate's
              if (single_match_score.player_id != @player.id) and (my_score.player_faction != single_match_score.player_faction)
                logger.debug "RECORD"
                # Make the spec name
                opposing_spec = Player.find_by(id: single_match_score.player_id).class_name + "-" + Player.find_by(id: single_match_score.player_id).spec_name
                logger.debug "Spec name generated: " + opposing_spec

                #### Single spec building:
                if !specs_seen.include?(opposing_spec)
                  logger.debug "Specs seen: " + specs_seen.to_s
                  logger.debug "Did not see opposting spec, adding it."
                  # look up or create the record for this spec
                  rec = @records_by_spec[opposing_spec] ||= { spec: opposing_spec, wins: 0, losses: 0, won_matches: [], lost_matches: [], won_talents: [], won_glyphs: [], lost_talents: [], lost_glyphs: [], talent_tally: {}}
                  pmi = PersonalMatchInfo.find_by(match_id: my_score.match_id, player_id: @player.id)                   
                  # Update the count and list of matches
                  if b_won                    
                    rec[:wins] += 1
                    rec[:won_matches] << [my_score.match_id]  
                    if pmi
                      logger.debug("Logging won talents and glyphs")
                      logger.debug(pmi.talents)
                      logger.debug(pmi.glyphs)
                      rec[:won_talents] << pmi.talents 
                      rec[:won_glyphs] << pmi.glyphs  
                      tally_talents(rec, b_won, pmi.talents, pmi.glyphs)
                    end # end if there is personal match info for a player.		
                  else
                    rec[:losses] += 1
                    rec[:lost_matches] << [my_score.match_id]                  
                    if pmi
                      logger.debug("Logging lost talents and glyphs")
                      logger.debug(pmi.talents)
                      logger.debug(pmi.glyphs)
                      rec[:lost_talents] << pmi.talents 
                      rec[:lost_glyphs] << pmi.glyphs 
                      tally_talents(rec, b_won, pmi.talents, pmi.glyphs)
                    end # end if there is personal match info for a player.		
                  end
                  
                  @total_single_spec_stats += 1
                end # We don't want to add two losses or wins against a team of the same specs.

                #### Team spec building:
                specs_seen.push(opposing_spec)
                logger.debug "built specs: " + specs_seen.to_s
              end # if the score is not one of our team

            end # end - for all scores belonging to a single match id
            
          end # end - for each score in our match.
          
          
          b_won ? @total_wins += 1 : @total_losses += 1
          
          # Build the double spec array here
          opposing_team = specs_seen.sort.to_s
          rec = @records_by_team[opposing_team] ||= { team: opposing_team, wins: 0, losses: 0, won_matches: [], lost_matches: [], won_talents: [], won_glyphs: [], lost_talents: [], lost_glyphs: [], talent_tally: {} }
          # update the appropriate field
          #rec[  b_won ? :wins : :losses ] += 1
         # Update the count and list of matches
           pmi = PersonalMatchInfo.find_by(match_id: my_score.match_id, player_id: @player.id)                   
          # Update the count and list of matches
          if b_won                    
            rec[:wins] += 1
            rec[:won_matches] << [my_score.match_id]  
            if pmi
              logger.debug("Logging won talents and glyphs")
              logger.debug(pmi.talents)
              logger.debug(pmi.glyphs)
              rec[:won_talents] << pmi.talents 
              rec[:won_glyphs] << pmi.glyphs  
              tally_talents(rec, b_won, pmi.talents, pmi.glyphs)
            end # end if there is personal match info for a player.		
          else
            rec[:losses] += 1
            rec[:lost_matches] << [my_score.match_id]                  
            if pmi
              logger.debug("Logging lost talents and glyphs")
              logger.debug(pmi.talents)
              logger.debug(pmi.glyphs)
              rec[:lost_talents] << pmi.talents 
              rec[:lost_glyphs] << pmi.glyphs 
              tally_talents(rec, b_won, pmi.talents, pmi.glyphs)
            end # end if there is personal match info for a player.		
          end
          @total_teams_seen += 1
          @total_matches += 1 
      end # end if the match is in the range we care about
    end # end - for all scores matching the player-of-interest id

    # Now sort the hash and add percentages . . . .   
    logger.debug("Sorting hashes and adding percentages.")
    logger.debug("IFound: " + @records_by_spec.count.to_s + " specs")
    logger.debug(JSON.pretty_generate(@records_by_spec))
    logger.debug("IFound: " + @records_by_team.count.to_s + " teams")
    # logger.debug(JSON.pretty_generate(@records_by_team))
    @records_by_spec.each { |k, v| @records_by_spec[k][:winpct] = (100 * @records_by_spec[k][:wins].to_f / (@records_by_spec[k][:wins].to_f + @records_by_spec[k][:losses].to_f)).round(0)}
    @records_by_spec.each { |k, v| @records_by_spec[k][:losspct] = (100 * @records_by_spec[k][:losses].to_f / (@records_by_spec[k][:wins].to_f + @records_by_spec[k][:losses].to_f)).round(0)}
    @records_by_spec.each { |k, v| @records_by_spec[k][:total] = (@records_by_spec[k][:wins] + @records_by_spec[k][:losses]) }
    @records_by_spec = @records_by_spec.sort_by {|key, value| value[:winpct]}

    @records_by_team.each { |k, v| @records_by_team[k][:winpct] = (100 * @records_by_team[k][:wins].to_f / (@records_by_team[k][:wins].to_f + @records_by_team[k][:losses].to_f)).round(0)}
    @records_by_team.each { |k, v| @records_by_team[k][:losspct] = (100 * @records_by_team[k][:losses].to_f / (@records_by_team[k][:wins].to_f + @records_by_team[k][:losses].to_f)).round(0)}
    @records_by_team.each { |k, v| @records_by_team[k][:total] = (@records_by_team[k][:wins] + @records_by_team[k][:losses]) }
    @records_by_team = @records_by_team.sort_by {|key, value| value[:winpct]}
   
    respond_to do |format|
      format.html { render template: "reports/vsspec" }
    end

  end #vsspec
end #class
