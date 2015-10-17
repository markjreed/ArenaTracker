class ReportsController < ApplicationController
  
  def create
    @rc = ReportsController.new(params[:player])
  end
=begin    
  def index
    @passed_name = params[:player] ? @passed_name = params[:player] : ""
  end
=end
    
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

    
    # Get the player we care about (one only for now)
    # @p_name = @passed_name[:player] == "" ? "Furiousbess" : @passed_name[:player] 
    # @p_name = params[:player] ?  params[:player] : "Furiousbess"
    
    # @p_name = "Furiousbess"
    @p_name = "Asaemon"
    
    player = Player.find_by(name: @p_name)
    b_won = 0
    
    start_time = DateTime.new(2013, 10, 16, 18, 0)
    end_time = DateTime.new(2019, 10, 16, 23, 59)
    
    # Get all the scores for that player
    Score.where(Player_id: player.id).find_each do |my_score|      
      logger.debug "MY SCORE: " + my_score.as_json.to_s
      # Grab out the match that matches =)
      match = Match.find_by(id: my_score.Match_id)
      logger.debug "THE MATCH: " + match.as_json.to_s
      # Get the date/time associated with the score to see if we care.
      # match_time = match.date_time.strptime("%Y-%m-%dT%H:%M:%S")
      match_time = match.date_time.to_datetime
      if (match_time > start_time) and (match_time < end_time)      
      
        @total_matches += 1
        
        # For that match, see if we won or lost.
        b_won = (match.winning_faction == my_score.player_faction) ? true : false
        b_won ? @total_wins += 1 : @total_losses += 1
        
        @counted = 0
        specs_seen = Array.new
        
        # Find all the OTHER scores associated with that match ID
        Score.where(Match_id: my_score.Match_id).find_each do |single_match_score|
          logger.debug "MATCH SCORE: " + single_match_score.as_json.to_s
          
          # If the score isn't OUR score, look at the specs
          logger.debug "player id from score: " + single_match_score.Player_id.to_s
          logger.debug "my player id: " + player.id.to_s
          logger.debug "my player id from score: " + my_score.Player_id.to_s
          logger.debug "my faction: " + my_score.player_faction.to_s
          logger.debug "faction from score: " + single_match_score.player_faction.to_s
          # Make sure the score seen isn't yours or a teammate's 
          if (single_match_score.Player_id != player.id) and (my_score.player_faction != single_match_score.player_faction)
            logger.debug "RECORD"
            # Make the spec name       
            opposing_spec = Player.find_by(id: single_match_score.Player_id).class_name + "-" + Player.find_by(id: single_match_score.Player_id).spec_name          
            logger.debug "Spec name generated: " + opposing_spec
            
            #### Single spec building:          
            if !specs_seen.include?(opposing_spec)              
              logger.debug "Specs seen: " + specs_seen.to_s
              logger.debug "Did not see opposting spec, adding it."
              # look up or create the record for this spec
              rec = @records_by_spec[opposing_spec] ||= { spec: opposing_spec, wins: 0, losses: 0, matches: [] }            
              # update the appropriate field
              rec[  b_won ? :wins : :losses ] += 1
              rec[:matches] |= [my_score.Match_id]
              @total_single_spec_stats += 1
            end # We don't want to add two losses or wins against a team of the same specs.
            
            #### Team spec building:            
            specs_seen.push(opposing_spec)
            logger.debug "built specs: " + specs_seen.to_s
          end # if the score is not one of our team
                  
        end # end - for all scores belonging to a single match id
        # Build the double spec array here
        opposing_team = specs_seen.sort.to_s
        rec = @records_by_team[opposing_team] ||= { team: opposing_team, wins: 0, losses: 0, matches: [my_score.Match_id] }            
        # update the appropriate field
        rec[  b_won ? :wins : :losses ] += 1   
        @total_teams_seen += 1
      end # end if the match is in the range we care about
    end # end - for all scores matching the player-of-interest id
    
    # Now sort the hash and add percentages . . . . 
    @records_by_spec.each { |k, v| @records_by_spec[k][:winpct] = (100 * @records_by_spec[k][:wins].to_f / (@records_by_spec[k][:wins].to_f + @records_by_spec[k][:losses].to_f)).round(0)}
    @records_by_spec.each { |k, v| @records_by_spec[k][:losspct] = (100 * @records_by_spec[k][:losses].to_f / (@records_by_spec[k][:wins].to_f + @records_by_spec[k][:losses].to_f)).round(0)}
    @records_by_spec.each { |k, v| @records_by_spec[k][:total] = (@records_by_spec[k][:wins] + @records_by_spec[k][:losses]) }
    @records_by_spec = @records_by_spec.sort_by {|key, value| value[:winpct]}
    
    @records_by_team.each { |k, v| @records_by_team[k][:winpct] = (100 * @records_by_team[k][:wins].to_f / (@records_by_team[k][:wins].to_f + @records_by_team[k][:losses].to_f)).round(0)}
    @records_by_team.each { |k, v| @records_by_team[k][:losspct] = (100 * @records_by_team[k][:losses].to_f / (@records_by_team[k][:wins].to_f + @records_by_team[k][:losses].to_f)).round(0)}
    @records_by_team.each { |k, v| @records_by_team[k][:total] = (@records_by_team[k][:wins] + @records_by_team[k][:losses]) }
    @records_by_team = @records_by_team.sort_by {|key, value| value[:winpct]}    
    
  end #vsspec
end #class
