
# 2015-10-10T19:10:36,Fight:10,PARTNERS:Asaemon-Silvermoon,256 EPART,ZONE:Dalaran Arena,MYFACTION:1,PLAYER:Furiousbess-Silvermoon,OPPCLASS:DRUID,OPPSPEC:Restoration,OPPCLASS:ROGUE,OPPSPEC:Assassination,WINNING TEAM: 1,{{SCORE:Furiousbess,2,0,0,0,1,Human,Death Knight,DEATHKNIGHT,4785580,84534,0,11,0,0,Frost}},{{SCORE:Asaemon,0,0,0,0,1,Draenei,Priest,PRIEST,2877698,4868563,0,11,0,0,Discipline}},{{SCORE:Bêkbêk-Archimonde,0,0,0,0,0,Night Elf,Druid,DRUID,285064,6537408,0,-12,0,0,Restoration}}TALENTS:,Plague Leech,Lichborne,Chilblains,Runic Corruption,Death Siphon,Gorefiend's Grasp,Necrotic Plague ETAL,GLYPHS:,Glyph of Army of the Dead,Glyph of Icy Touch,Glyph of Path of Frost,Glyph of Empowerment,Glyph of Tranquil Grip,Glyph of Runic Power EGLY
class RawBattle < ActiveRecord::Base
  after_save do      
    logger = Logger.new('test.log')
    # "self" is an object, so pull out by the column name self.raw_battle_data
    logger.debug "Parsing Raw Battle"
    logger.debug self.raw_battle_data
    raw_battle_string = self.raw_battle_data
    
    #####################################################
    # Grab out the server name
    #####################################################
    re = /REALM:([^,]*)/
    matches = self.raw_battle_data.match re
    if matches.nil?
      logger.debug("Server not found")
      server_name = "UNKNOWN"
    else
      server_name = matches[1]
      logger.debug("got server: " + server_name)       
    end 
    
    #####################################################
    # Create a match
    #####################################################
    match = Match.create do |m|
      m.date_time = self.raw_battle_data[0..18]
      
      if result = /.*ZONE:([^,]*)/.match(self.raw_battle_data)
        m.arena_name = result.captures[0]
      else
        m.arena_name = "NOT FOUND"
      end
      
      if result = /.*WINNING TEAM: ([^,]*)/.match(self.raw_battle_data)
        m.winning_faction = (result.captures[0]).to_i
      else
        m.winning_faction = -1
      end      
    end
        
    #####################################################
    # Parse out the scores.  Without these, we don't care about stuff.
    #####################################################
    # A score looks like this on the split: 
    # SCORE:Furiousbess,2,0,0,0,1,Human,Death Knight,DEATHKNIGHT,4785580,84534,0,11,0,0,Frost}},
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
        
    # At this point we should have an array, score_list, each element of which is
    # an array with each element being a score.
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
      # Append server name if it's not there. TODO Make get real server for other players =P
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
        
      end # for each score in the score list
    end    
    
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
    
    # There should be only one, should check this someday =P
    logging_player = Player.find_by(name: player_name, server_name: player_server)
    
    logger.debug("found player, spec: " + logging_player.spec_name)
      
    # Now pull out the talents and glyphs, and store the alphabetically (to reduce storage)
    # TALENTS:,Plague Leech,Lichborne,Chilblains,Runic Corruption,Death Siphon,Gorefiend's Grasp,Necrotic Plague ETAL,GLYPHS:,Glyph of Army of the Dead,Glyph of Icy Touch,Glyph of Path of Frost,Glyph of Empowerment,Glyph of Tranquil Grip,Glyph of Runic Power EGLY
    re = /TALENTS:,(.*) ETAL/
    matches = self.raw_battle_data.match re
    if matches.nil?
      logger.debug("Talents not found")
    else
      logger.debug("got talents: " + matches[1]) 
      talents_split = matches[1].split(",")
      talents_split.sort_by{|talent| talent.downcase}
      logger.debug(talents_split)
      talents_split.count > 0 ? t1 = talents_split[0] : t1 = ""
      talents_split.count > 1 ? t2 = talents_split[1] : t2 = ""
      talents_split.count > 2 ? t3 = talents_split[2] : t3 = ""
      talents_split.count > 3 ? t4 = talents_split[3] : t4 = ""
      talents_split.count > 4 ? t5 = talents_split[4] : t5 = ""
      talents_split.count > 5 ? t6 = talents_split[5] : t6 = ""
      talents_split.count > 6 ? t7 = talents_split[6] : t7 = ""
      talents_split.count > 7 ? t8 = talents_split[7] : t8 = ""
      
    end 
      
    re = /GLYPHS:,(.*) EGLY/
    matches = self.raw_battle_data.match re
    if matches.nil?
      logger.debug("Glyphs not found")
    else
      logger.debug("got glyphs: " + matches[1]) 
      glyphs_split = matches[1].split(",")
      glyphs_split.sort_by{|glyph| glyph.downcase}
      logger.debug(glyphs_split)
      glyphs_split.count > 0 ? g1 = glyphs_split[0] : g1 = ""
      glyphs_split.count > 1 ? g2 = glyphs_split[1] : g2 = ""
      glyphs_split.count > 2 ? g3 = glyphs_split[2] : g3 = ""
      glyphs_split.count > 3 ? g4 = glyphs_split[3] : g4 = ""
      glyphs_split.count > 4 ? g5 = glyphs_split[4] : g5 = ""
      glyphs_split.count > 5 ? g6 = glyphs_split[5] : g6 = ""
      glyphs_split.count > 6 ? g7 = glyphs_split[6] : g7 = ""
      glyphs_split.count > 7 ? g8 = glyphs_split[7] : g8 = ""
      glyphs_split.count > 8 ? g9 = glyphs_split[8] : g9 = ""
      glyphs_split.count > 9 ? g10 = glyphs_split[9] : g10 = ""
    end 
     
        
    tals_and_glyphs = TalentGlyphSelection.find_or_create_by(
          tal01: t1,  tal02: t2,  tal03: t3,  tal04: t4,  
          tal05: t5,  tal06: t6,  tal07: t7,  tal08: t8,  
          gly01: g1, gly02: g2, gly03: g3, gly04: g4, gly05: g5, 
          gly06: g6, gly07: g7, gly08: g8, gly09: g9, gly10: g10)
    
    #####################################################
    # Create association between match and glyph/talent
    #####################################################    
    MatchTalentGlyphSelection.create do |a|      
      a.player_id = logging_player.id
      a.match_id = match.id
      a.TalentGlyphSelection_id = tals_and_glyphs.id
    end    
  end # after_save
end # RawBattle
