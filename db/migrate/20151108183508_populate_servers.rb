class PopulateServers < ActiveRecord::Migration
  def up
    {
      "Ahn'Qiraj"          =>  "ahnqiraj",
      "Aman'Thul"          =>  "amanthul",
      "Area52"             =>  "area-52",
      "ArgentDawn"         =>  "argent-dawn",
      "AzjolNerub"         =>  "azjol-nerub",
      "BurningBlade"       =>  "burning-blade",
      "BurningLegion"      =>  "burning-legion",
      "C'Thun"             =>  "cthun",
      "ChamberofAspects"   =>  "chamber-of-aspects",
      "Chantséternels"     =>  "chants-eternels",
      "Cho’gall"           =>  "chogall",
      "CultedelaRivenoire" =>  "culte-de-la-rive-noire",
      "DarkmoonFaire"      =>  "darkmoon-faire",
      "DefiasBrotherhood"  =>  "defias-brotherhood",
      "DieArguswacht"      =>  "die-arguswacht",
      "DieNachtwache"      =>  "die-nachtwache",
      "Drak'thul"          =>  "drakthul",
      "DunModr"            =>  "dun-modr",
      "Eldre'Thalas"       =>  "eldrethalas",
      "EmeraldDream"       =>  "emerald-dream",
      "GrimBatol"          =>  "grim-batol",
      "KhazModan"          =>  "khaz-modan",
      "Kil'jaeden"         =>  "kiljaeden",
      "KulTiras"           =>  "kul-tiras",
      "KultderVerdammten"  =>  "kult-der-verdammten",
      "LaCroisadeécarlate" =>  "la-croisade-ecarlate",
      "LosErrantes"        =>  "los-errantes",
      "Mal'Ganis"          =>  "malganis",
      "Pozzodell'Eternità" =>  "pozzo-delleternita",
      "Quel'Thalas"        =>  "quelthalas",
      "ScarshieldLegion"   =>  "scarshield-legion",
      "ShatteredHalls"     =>  "shattered-halls",
      "ShatteredHand"      =>  "shattered-hand",
      "TarrenMill"         =>  "tarren-mill",
      "TheMaelstrom"       =>  "the-maelstrom",
      "Twilight'sHammer"   =>  "twilights-hammer",
      "TwistingNether"     =>  "twisting-nether",
      "Zul'jin"            =>  "zuljin",
      "Гром"               =>  "grom",
      "Разувий"            =>  "razuvious",
      "Азурегос"           =>  "azuregos",
      "Подземье"           =>  "deephome",
      "Голдринн"           =>  "goldrinn",
      "Седогрив"           =>  "greymane",
      "Галакронд"          =>  "galakrond",
      "Корольлич"          =>  "lich-king",
      "ЧерныйШрам"         =>  "blackscar",
      "ТкачСмерти"         =>  "deathweaver",            #  guess
      "Дракономор"         =>  "fordragon",
      "Ясеневыйлес"        =>  "ashenvale",
      "СтражСмерти"        =>  "deathguard",
      "ВечнаяПесня"        =>  "eversong",
      "Ревущийфьорд"       =>  "howling-fjord",
      "Термоштепсель"      =>  "thermaplugg",
      "Пиратскаябухта"     =>  "booty-bay",              #  guess
      "СвежевательДуш"     =>  "soulflayer"
    }.each do |name, trans|
      Server.create name: name, translation: trans
    end
    Player.all.each do |p|
      Server.find_or_create_by(name: p.server_name)
    end
  end

  def down
    Server.delete_all
  end
end
