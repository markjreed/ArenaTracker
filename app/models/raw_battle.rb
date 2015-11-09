# QUESTIONS: TODO
# How to make the logger.debug generally avalible in a module?

# 2015-10-10T19:10:36,Fight:10,PARTNERS:Asaemon-Silvermoon,256 EPART,ZONE:Dalaran Arena,MYFACTION:1,PLAYER:Furiousbess-Silvermoon,OPPCLASS:DRUID,OPPSPEC:Restoration,OPPCLASS:ROGUE,OPPSPEC:Assassination,WINNING TEAM: 1,{{SCORE:Furiousbess,2,0,0,0,1,Human,Death Knight,DEATHKNIGHT,4785580,84534,0,11,0,0,Frost}},{{SCORE:Asaemon,0,0,0,0,1,Draenei,Priest,PRIEST,2877698,4868563,0,11,0,0,Discipline}},{{SCORE:Bêkbêk-Archimonde,0,0,0,0,0,Night Elf,Druid,DRUID,285064,6537408,0,-12,0,0,Restoration}}TALENTS:,Plague Leech,Lichborne,Chilblains,Runic Corruption,Death Siphon,Gorefiend's Grasp,Necrotic Plague ETAL,GLYPHS:,Glyph of Army of the Dead,Glyph of Icy Touch,Glyph of Path of Frost,Glyph of Empowerment,Glyph of Tranquil Grip,Glyph of Runic Power EGLY
class RawBattle < ActiveRecord::Base
  after_save do      
    logger = Logger.new('test.log')
    # "self" is an object, so pull out by the column name self.raw_battle_data
    logger.debug "Parsing Raw Battle"
    logger.debug self.raw_battle_data
    # raw_battle_string = self.raw_battle_data
    
    #####################################################
    # Generate the match reference from the string.
    #####################################################
    reference = generate_match_reference
    logger.debug "Reference: " + reference
    
    #####################################################
    # Grab out the server name
    #####################################################
    server_name = get_server_from_match 
    logger.debug("got server: " + server_name)       
    
    #####################################################
    # Find out if the match is already recorded.
    #####################################################  
    begin
      match = Match.find_by reference: reference
    rescue ActiveRecord::RecordNotFound => e
      match = nil
    end
    
    # If the match already exists, just log the player/glyph information 
    # (if that also doesn't already exist =)
    if !match.nil? 
      logger.debug("MATCH FOUND ALREADY")
      match_id = match.id
    else
      logger.debug("MATCH NOT FOUND")
      
      #####################################################
      # Create a match
      #####################################################
      match = Match.create do |m|
        m.date_time = self.raw_battle_data[0..18]
        
        m.arena_name = get_arena_name_from_match
        
        if result = /.*WINNING TEAM: ([^,]*)/.match(self.raw_battle_data)
          m.winning_faction = (result.captures[0]).to_i
        else
          m.winning_faction = -1
        end      
        
        m.reference = reference  
        m.mmr_list = ""
        
        #####################################################
        # If we see joined/left times and death times, just
        # save them off.  Anyone in the match should have
        # data that more or less matches.  Time zone irrelevant
        #####################################################
        time_hash = get_times_from_match
        logger.debug("got times")
        m.match_start = time_hash[:joined_time]
        m.match_end = time_hash[:left_time]
        m.match_duration = time_hash[:length]
        m.death_times = time_hash[:death_times]
        logger.debug("times: " + m.match_start.to_s + " " + m.match_end.to_s + " " + m.death_times)
      end
      
      mat = Match.find_by reference: reference    
      logger.debug ("a = " + match.id.to_s)
      match_id = match.id
      logger.debug ("b = " + match_id.to_s)
      
          
      #####################################################
      # Parse out the scores.  Without these, we don't care about stuff.
      #####################################################
      # A score looks like this on the split: 
      # SCORE:Furiousbess,2,0,0,0,1,Human,Death Knight,DEATHKNIGHT,4785580,84534,0,11,0,0,Frost}},
      score_list = parse_scores_from_raw_battle 

      logger.debug "Score listing:"
      logger.debug score_list
      
      #####################################################
      # Create players if necessary, otherwise get ID.
      #####################################################
      # 2015-10-10T19:10:36,Fight:10,PARTNERS:Asaemon-Silvermoon,256 EPART,ZONE:Dalaran Arena,MYFACTION:1,PLAYER:Furiousbess-Silvermoon,OPPCLASS:DRUID,OPPSPEC:Restoration,OPPCLASS:ROGUE,OPPSPEC:Assassination,WINNING TEAM: 1,{{SCORE:Furiousbess,2,0,0,0,1,Human,Death Knight,DEATHKNIGHT,4785580,84534,0,11,0,0,Frost}},{{SCORE:Asaemon,0,0,0,0,1,Draenei,Priest,PRIEST,2877698,4868563,0,11,0,0,Discipline}},{{SCORE:Bêkbêk-Archimonde,0,0,0,0,0,Night Elf,Druid,DRUID,285064,6537408,0,-12,0,0,Restoration}}TALENTS:,Plague Leech,Lichborne,Chilblains,Runic Corruption,Death Siphon,Gorefiend's Grasp,Necrotic Plague ETAL,GLYPHS:,Glyph of Army of the Dead,Glyph of Icy Touch,Glyph of Path of Frost,Glyph of Empowerment,Glyph of Tranquil Grip,Glyph of Runic Power EGLY
      # For each score in our score list, pull out the player name and other fun.
      # Furiousbess,2,0,0,0,1,Human,Death Knight,DEATHKNIGHT,4785580,84534,0,11,0,0,Frost
      score_list.each do |sl|
        #############################
        # Grab or make the player:
        #############################
        # Append server name if it's not there. 
        if !sl[0].include? "-"
          p_server =  server_name
          p_name = sl[0]
        else
          p_name = (sl[0].split("-"))[0]
          p_server = (sl[0].split("-"))[1]
        end
        
        player = Player.find_or_create_by(name: p_name, server_name: p_server, class_name: sl[7], spec_name: sl[15])
        
        # Now that we have the player and the match ID, make the score.
        Score.create do |s|
          s.player_id = player.id
          s.match_id = match.id
          s.player_faction = sl[5].to_i         
          s.killing_blows = sl[1].to_i
          s.damage_done = sl[9].to_i
          s.healing_done = sl[10].to_i
          s.ratings_adjustment = sl[12].to_i          
        end # create the score
      end  # for each score in the score list  
    end # If the match is not already recorded
    
    # Find out if there's an association between the player glyphs and the match already.   
    #####################################################
    # Create glyph/talent list if necessary, otherwise get ID
    #####################################################
    # The player name will tell us who the glyphs belong to . . . 
    re = /PLAYER:([^,]*)/
    matches = self.raw_battle_data.match re
    if matches.nil?
      logger.debug("Player not found")
    else
      logger.debug("got player: " + matches[1]) 
      if !matches[1].include? "-"
        player_server =  server_name
        player_name = matches[1]
      else
        player_name = (matches[1].split("-"))[0]
        player_server = (matches[1].split("-"))[1]
      end
      logger.debug("Player: " + player_name)
      logger.debug("Server: " + player_server)
    end 
    
    # There should be only one
    logging_player = Player.find_by(name: player_name, server_name: player_server)    
    logger.debug("found player, spec: " + logging_player.spec_name)
    
    # MatchTalentGlyphSelection.find_or_create_by(player: logging_player, match_id: match_id, talent_glyph_selection_id: tals_and_glyphs.id)
    if !MatchTalentGlyphSelection.exists?( :player => logging_player, :match_id => match_id)
      logger.debug("TALENT SET NOT FOUND IN DB")
      # Now pull out the talents and glyphs, and store the alphabetically (to reduce storage)
      # TALENTS:,Plague Leech,Lichborne,Chilblains,Runic Corruption,Death Siphon,Gorefiend's Grasp,Necrotic Plague ETAL,GLYPHS:,Glyph of Army of the Dead,Glyph of Icy Touch,Glyph of Path of Frost,Glyph of Empowerment,Glyph of Tranquil Grip,Glyph of Runic Power EGLY
      re = /TALENTS:,(.*) ETAL/
      matches = self.raw_battle_data.match re
      if matches.nil?
        logger.debug("Talents not found in raw_battle_data")
      else
        logger.debug("got talents: " + matches[1]) 
        talents_split = matches[1].split(",")
        talents_split = talents_split.sort_by{|talent| talent.downcase}
        talents_join = talents_split.join(',')
        logger.debug(talents_join)
        t1 = talents_join            
      end 
        
      re = /GLYPHS:,(.*) EGLY/
      matches = self.raw_battle_data.match re
      if matches.nil?
        logger.debug("Glyphs not found")
      else
        logger.debug("got glyphs: " + matches[1]) 
        glyphs_split = matches[1].split(",")
        glyphs_split = glyphs_split.sort_by{|glyph| glyph.downcase}
        glyphs_join = glyphs_split.join(',')
        logger.debug(glyphs_join)
        g1 = glyphs_join            
      end 
       
      tals_and_glyphs = TalentGlyphSelection.find_or_create_by(tal01: t1, gly01: g1)
      
      #####################################################
      # Create association between match and glyph/talent
      # (if it's not already there)
      #####################################################    
      MatchTalentGlyphSelection.find_or_create_by(player: logging_player, match_id: match_id, talent_glyph_selection_id: tals_and_glyphs.id)
      

      
      
      
      #####################################################    
      # If there are new talents, there's a chance that
      # there will be new match making scores to factor in, so append
      # those to anything existing in there.
      #####################################################          
      new_mmrs = get_mmrs_from_match
      logger.debug "mmrs parsed out: " + new_mmrs
      if !new_mmrs.empty?
      
        # now pull out mmrs and append the new ones.
        # They might be just the same, but since the report
        # takes an average, this is fine.
        if match.nil?
          logger.debug("WTF???")
        end
        
        if match.mmr_list.nil?
          logger.debug("cell is blank")
        # !match.mmr_list.nil? and !match.mmr_list.empty?
          Match.update(match.id, :mmr_list => new_mmrs)                        
        else
          logger.debug("cell had something in it")
          Match.update(match.id, :mmr_list => match.mmr_list + "," + new_mmrs)        
        end
      end # if we actually got some mmrs to update
    else
      logger.debug("Found talents already")
    end # If Talents/Glyphs exist already.
    
    ######################################################################
    # Fill in any personal match info
    ######################################################################
    #if !PersonalMatchInfo.exists?( :player => logging_player, :match_id => match_id)
    #  logger.debug("PERSONAL INFO NOT FOUND IN DB")
      # Now pull out the talents and glyphs, and store the alphabetically (to reduce storage)
      # TALENTS:,Plague Leech,Lichborne,Chilblains,Runic Corruption,Death Siphon,Gorefiend's Grasp,Necrotic Plague ETAL,GLYPHS:,Glyph of Army of the Dead,Glyph of Icy Touch,Glyph of Path of Frost,Glyph of Empowerment,Glyph of Tranquil Grip,Glyph of Runic Power EGLY
      
      pmi = PersonalMatchInfo.find_or_create_by(player: logging_player, match_id: match_id)
      
      
      pmi.winner = player_winner(player_name)
      
      re = /TALENTS:,(.*) ETAL/
      matches = self.raw_battle_data.match re
      if matches.nil?
        logger.debug("Talents not found in raw_battle_data")
      else
        logger.debug("got talents: " + matches[1]) 
        talents_split = matches[1].split(",")
        talents_split = talents_split.sort_by{|talent| talent.downcase}
        talents_join = talents_split.join(',')
        logger.debug(talents_join)
        pmi.talents = talents_join            
      end 
      
      
      
     
      re = /GLYPHS:,(.*) EGLY/
      matches = self.raw_battle_data.match re
      if matches.nil?
        logger.debug("Glyphs not found")
      else
        logger.debug("got glyphs: " + matches[1]) 
        glyphs_split = matches[1].split(",")
        glyphs_split = glyphs_split.sort_by{|glyph| glyph.downcase}
        glyphs_join = glyphs_split.join(',')
        logger.debug(glyphs_join)
        pmi.glyphs = glyphs_join            
      end 
       
      # Pull out the note if there is one . . . 
      re = /NOTES:(.*) ENOTES/
      matches = self.raw_battle_data.match re
      if matches.nil?
        logger.debug("Notes not found")
      else
        logger.debug("got note: " + matches[1]) 
        pmi.note = matches[1]
      end 
      
      # Pull out the death notes if there are any
      re = /BDEATH:(.*) EDEATH/
      matches = self.raw_battle_data.match re
      if matches.nil?
        logger.debug("Death notes not found")
      else
        logger.debug("got note: " + matches[1]) 
        pmi.note = pmi.note + "^^^^" + matches[1]
      end 
      
      # Pull out the fight number (the fight since logged in. 
      # Probably not so useful but who knows, can look at warm ups.)
      fight = get_fight_from_match()
      
      pmi.fight_number = fight
      
      pmi.save
      
      
      
      
      
      #####################################################
      # Create association between match and glyph/talent
      # (if it's not already there)
      #####################################################    
      # MatchTalentGlyphSelection.find_or_create_by(player: logging_player, match_id: match_id, talent_glyph_selection_id: tals_and_glyphs.id)
      
    #else
    #  logger.debug("Found personal info already")
    #end # If Personal infos exist already.    
    
    
    
    
    
    
    
  end # after_save
    
  
  # Given a raw battle string from the addon, pull out the scores as arrays.
  # Also, because the player names are not joined with the server name for
  # the player's own server, uniformize the player names to always have
  # the server name.
  def parse_scores_from_raw_battle 
    score_list = Array.new
    score_split = self.raw_battle_data.split("{{")    
    score_split.each do |s|
      # If the string starts with "SCORE", parse out the actual score elements
      if s.start_with?('SCORE:')
        # Strip off the beginning and everything starting with }}
        re = /SCORE:(.*)}}.*/
        matches = s.match re
        if matches.nil?
          logger.debug("malformatted score")
        else
          logger.debug("got score: " + matches[1]) 
          logger.debug(matches[1].split(','))
          
          # Here we have:          
          # Furiousbess,2,0,0,0,1,Human,Death Knight,DEATHKNIGHT,4785580,84534,0,11,0,0,Frost
          # And barring change on Blizzard's side, should always be the same number of elements.
          # Split on the commas and add to the score array.
          score_list << matches[1].split(',')
        end # we pulled the score from the context garbage        
      end # we have a score
    end # Parse out scores
    
    # Sort the scores by name
    score_list = score_list.sort {|a,b| a[0] <=> b[0]}

    # Clean up all the player names to also have servers appended, for uniformity between loggers.
    score_list.map{|score| tidy_score_name(score)}
        
    # At this point we should have an array, score_list, each element of which is
    # an array with each element being a score.
    logger.debug "Score listing:"
    logger.debug score_list
    return score_list
  end
  
  # The match reference will be the zone name followed by the
  # scores, sorted and turned into comma separated strings.
  def generate_match_reference 
    score_list = parse_scores_from_raw_battle   
    reference = ""
    
    score_list.each do |score|
      reference = reference + score.join(",") + ","
    end
    
    reference = reference + get_arena_name_from_match
    return reference
  end
  
  # Because Blizzard sometimes doesn't give the player name fully qualified
  # with the server name, fix that here.
  def get_server_from_match 
    re = /REALM:([^,]*)/
    matches = self.raw_battle_data.match re
    if matches.nil?      
      server_name = "UNKNOWN"
    else
      server_name = matches[1]      
    end         
    
    return server_name
  end
  
  # Append the server name to the score name if necessary
  def tidy_score_name (score)
    if !score[0].include? "-"
      score[0] = score[0] + "-" + get_server_from_match      
    end    
    return score
  end
  
  def get_arena_name_from_match 
      if result = /.*ZONE:([^,]*)/.match(self.raw_battle_data)
        arena_name = result.captures[0]
      else
        arena_name = "NOT FOUND"
      end
      
      return arena_name
  end
  
  def get_fight_from_match
    if result = /.*Fight:([^,]*)/.match(self.raw_battle_data)
      fight = result.captures[0]
    else
      fight = 0
    end
    
    return fight    
  end
  
  def player_winner(player_name)
    # Find the winning faction
    if result = /.*WINNING TEAM: ([^,]*)/.match(self.raw_battle_data)
      winner = result.captures[0].to_i
    else
      winner = 9
    end
    
    # Find the faction of the player who made the log    
    score_list = parse_scores_from_raw_battle   
    score_list.each do |score|
        if score[0].include? player_name
          # Find the faction of the player
          if score[5].to_i == winner 
            return true
          end
        end # if it's a properly formed mmr
      end # for each mmr collection in the match      
    return false
  end
  
  # Relies upon match scores being just before the talent listing.
  # RATINGS:(,-1,-13,1654)(,-1,-13,1650)TALENTS:
  def get_mmrs_from_match    
    logger = Logger.new('test.log')
    mmrs = ""
   
    re = /RATINGS:(.*)TALENTS/
    matches = self.raw_battle_data.match re
    if matches.nil?
      logger.debug("MMRs not found")
    else
    
      logger.debug("got MMRs: " + matches[1]) 
      mmrs_split = matches[1].split("(")
      # So the split will look like this:
      # <empty>
      # ,-1,-13,1654)
      # ,-1,-13,1650)
      #
      # If the split has length, therefore, we want to further split on commas.
      # After that, we look at array value 3 for the actual MMR.      
      mmrs_split.each do |mmr_set|
        if mmr_set.count(",") == 3
          # we got a score.  pull out array[3], remove the trailing ), and append to our string.
          mmrs = mmrs + mmr_set.split(",")[3].chop + ","
        end # if it's a properly formed mmr
      end # for each mmr collection in the match      
      # Chop off the final comma
      mmrs = mmrs.chop
    end # if mmrs were found for match
    return mmrs
  end # f get mmrs from match
  
  def get_times_from_match
    logger = Logger.new('test.log')
    logger.debug("Getting times from match - start/end/died")
    
    match_times = { }
    
    re = /.*JOINED:([^,]*)/
    matches = self.raw_battle_data.match re
    if matches.nil?
      logger.debug("Joined time not found")
    else      
      match_times[:joined_time] = matches[1].to_datetime      
    end
    
    re = /.*LEFT:([^,]*)/
    matches = self.raw_battle_data.match re
    if matches.nil?
      logger.debug("Left time not found")
    else
      match_times[:left_time] = matches[1].to_datetime
    end
    
    # BDEATH:Ülträdin-Outland|2015-11-08T11:34:55 EDEATH
    re = /BDEATH(?:(?!BDEATH).)*? EDEATH/
    matches = self.raw_battle_data.scan re
    if matches.nil?
      logger.debug("Death time not found")
    else
      logger.debug ("death time array:")
      logger.debug (matches.to_s)
      death_string = ""
      matches.each do |death_time|
      
        re = /BDEATH:([^|]*)/
        name_matches = death_time.match re
        if name_matches.nil?
          logger.debug("Name not found in death time: " + death_time)
        else
          logger.debug("name  found array: " + name_matches.to_s)
          logger.debug("Name found: " + name_matches[1])
          death_name = name_matches[1]
          
          # now get time.
          re = /\|(20[^ ]*)/
          time_matches = death_time.match re
          if time_matches.nil?
            logger.debug("time not found in death time: " + death_time)
          else
            logger.debug("time found: " + time_matches.to_s)
            death_timestamp = time_matches[1].to_datetime
            logger.debug(death_timestamp.utc.strftime("%H:%M:%S"))
            logger.debug(death_timestamp.utc.strftime("%c"))
            logger.debug(match_times[:joined_time].utc.strftime("%H:%M:%S"))
            logger.debug(match_times[:joined_time].utc.strftime("%c"))
            match_len = (death_timestamp - match_times[:joined_time]) * 1.days
            logger.debug("length: " + Time.at(match_len).utc.strftime("%M:%S"))
            
            death_string = death_string + death_name + ": " +  Time.at(match_len).utc.strftime("%M:%S") + ","
            logger.debug("death string: " + death_string)
          end # end if found time in death
            
        end # end if found name in death
        match_times[:death_times] = death_string
      end # for each death time
    end # if there are death times
    
    match_times[:length] = Time.at((match_times[:left_time] - match_times[:joined_time])  * 1.days)
    logger.debug("total match length: " + match_times[:length].to_s)
    logger.debug("total match length in seconds: " + (match_times[:left_time] - match_times[:joined_time]).to_s)
    logger.debug("match durati: " + Time.at(match_times[:length]).utc.strftime("%M:%S"))
    
    
    return match_times
  end # f get_times_from_match
  
 
	
  
end # RawBattle
