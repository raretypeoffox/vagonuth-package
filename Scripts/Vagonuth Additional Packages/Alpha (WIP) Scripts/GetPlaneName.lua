-- Script: GetPlaneName
-- Attribute: isActive

-- Script Code:
  local planeLookup = {
    ["{ LORD } Dev     The Sun Cabal"]               = "Nowhere",
    ["{ LORD } Vorak   Lord Mud School"]              = "Thorngate",
    ["{ LORD } Crom    Thorngate"]                    = "Thorngate",
    ["{ LORD } Crom    The House of Bandu"]           = "Thorngate",
    ["{ LORD } Odin    A Temple of Gorn"]             = "Thorngate",
    ["{ LORD } Dev     Thorngate Keep"]               = "Thorngate",
    ["{ LORD } Dev     Rietta's Wonders"]             = "Thorngate",
    ["{ LORD } Odin    Labyrinth of Bo'vul"]          = "Hell",
    ["{ LORD } Snikt   Outland"]                      = "Outland",
    ["{ LORD } Kylara  Tarterus"]                     = "Tarterus",
    ["{ LORD } Dev     The Garden"]                   = "Tarterus",
    ["{ LORD } Ducer   Fire Realm"]                   = "Fire",
    ["{ LORD } Mimir   Cinderheim"]                   = "Fire",
    ["{ LORD } Dev     Airscape"]                     = "Air",
    ["{ LORD } Crowe   Plane of Water"]               = "Water",
    ["{ LORD } Crowe   World of Stone"]               = "Stone",
    ["{ LORD } Yevaud  Mountain of Madness"]          = "Stone",
    ["{ LORD } Yevaud  The Accursed Lands"]           = "Karnath",
    ["{ LORD } Yevaud  The Silent Sphinx"]            = "Karnath",
    ["{ LORD } Yevaud  The Dark Pyramid"]             = "Karnath",
    ["{ LORD } Yevaud  The Reckoning"]                = "Water",
    ["{ LORD } Yevaud  The Ascension"]                = "Tarterus",
    ["{ LORD } Dev     Citadel Arcadia"]              = "Arcadia",
    ["{ LORD } Dev     Dark Fae Tower"]               = "Arcadia",
    ["{ LORD } Dev     The Fantasy Forest"]           = "Arcadia",
    ["{ LORD } Andi    The Astral Plane"]             = "Astral",
    ["{ LORD } Dev     Memory Lane"]                  = "Astral",
    ["{ LORD } Dev     Astral Invasion"]              = "Astral",
    ["{ LORD } Ctibor  Shadowlands"]                = "Midgaardia", -- call "Midgaardia" so hero spells are used
    ["{ LORD } Ctibor  Netherworld"]                = "Midgaardia", -- call "Midgaardia" so hero spells are used
    ["{ LORD } Zahri   The Shunned World"]            = "Kzinti",
    ["{ LORD } CC-Ctib Savage Jungle"]               = "Kzinti",
    ["{ LORD } CC-Ctib Inferno Peak"]                = "Kzinti",
    ["{ LORD } CC-Ctib Kzinti Spire of Knowledge"]   = "Kzinti",
    ["{ LORD } CC-Ctib Kzinti Spire of War"]          = "Kzinti",
    ["{ LORD } Mimir   Patriarchs' Gulch"]            = "Karnath",
    ["{ LORD } Mim&Mel Forbidden Wasteland"]         = "Karnath",
    ["{ LORD } Dev     Under the Stars"]              = "Noctopia",
    ["{ LORD } Dev     The Shiftwatch Orb"]           = "Noctopia",
    ["{ LORD } Dev     Obsidian Arena; Stands"]         = "Noctopia",
    ["{ LORD } Dev     Obsidian Arena; Floor"]          = "Noctopia",
    ["{ LORD } Dev     Pits of Blood and Chain"]        = "Noctopia",
    ["{ LORD } Dev     The Unravelling"]              = "Nowhere",
    ["{ LORD } Kariya  Temple of the Council"]        = "Tarterus",
    ["{ LORD } Mal     Demi-plane of Dread"]          = "DEFAULT",
    ["{ LORD } Skorn   Soulchar Desolation"]          = "Stone",
    ["{ LORD } Silence Githzerai Keep"]               = "Outland",
    ["{ LORD } Moir    Battle of Avalon"]             = "Shard",
    ["{ LORD } WntRose The Conundrum"]                = "Shard",
    ["{ LORD } Mal     Dreamscape"]                 = "Shard",
    ["{ LORD } Jaromil When Elements Align"]         = "Shard",
    ["{ LORD } Ginta   Eragoran Laylines"]            = "Shard",
    ["{ LORD } Mimir   Forsaken Asylum"]              = "Shard",
    ["{ LORD } Waite   Soulgorger's Lair"]             = "Shard",
    ["{ LORD } Imij    Spirit Forge"]                 = "Shard",
    ["{ LORD } Mirlion The Shattered Mirror"]         = "Shard",
    ["{ LORD } Yrth    Tribulations of Zin"]          = "Shard",
    ["{ LORD } MalFlor Echo Monastery"]              = "Transmog",
    ["{ LORD } MalShrt  Tssasskkas's Lair Redux"]      = "Transmog",
    ["{ LORD } MalKar  Darker Castle"]                = "Transmog",
    ["{ LORD } ChoMal  Borley's Bond"]                = "Transmog",
    ["{ LORD } Jaromal Overgrowth"]                  = "Transmog",
    ["{ LORD } Megamal Kwalashai"]                    = "Transmog",
    ["{ LORD } Mal     Flayer Keep"]                 = "Transmog",
    ["{ LORD } DevMal  Stalemate"]                   = "Transmog",
    ["{ LORD } Draeger Silmavar Lost"]               = "Transmog", 
    ["{ LORD } Mal     Nexus of the Crisis"]         = "Tarterus",
    ["{ LORD } Ctibor  Realm of Chaos"]              = "Special",
    ["{ LORD } Ctibor  Domain of Law"]               = "Astral",
    ["{ LORD } Mal     The Bond"]                    = "Special",
    ["{ LORD } DevMal  Apotheosis"]                  = "DEFAULT",
    ["{ LORD } Mal     Horavacui"]                   = "Horavacui",
    ["{ LORD } Tyberos Mindscape"]                   = "Outland",
    ["{ LORD } Mal     Accursed Graveyard"]          = "Horavacui",
    ["{ LORD } Ctibor  Gem Repository"]              = "Air",
    ["{ LORD } Akharan Bo'Vul's Imagery Gate"]         = "Air",
    ["{ LORD } Ctibor  Gate of Indecision"]          = "Air",
    ["{ LORD } Ctibor  Arcadian Menagerie"]          = "Air",
    ["{ LORD } Ctibor  Elemental Menagerie"]         = "Air",
    ["{ LORD } Ctibor  Tarterus Menagerie"]          = "Air",
    ["{ LORD } Santana Bo'Vul's Mermen Gate"]         = "Air",
    ["{ LORD } Ctibor  Bo'Vul's Vault"]              = "Air",
  }

function GetTier(area_name)
  if not area_name then area_name = gmcp.Room.Info.zone end
  
  if StatTable.Level < 125 then return "Hero" end
  if StatTable.Level == 250 then return "Legend" end
  
  if area_name == "{ LORD } Ctibor  Shadowlands" or
     area_name == "{ LORD } Ctibor  Netherworld" then
      return "Hero"
  end
  
  
  if string.sub(area_name, 1, 8) == "{ LORD }" then return "Lord" end
  
  -- Check if the area_name contains two numbers inside curly braces.
  local x, y = area_name:match("{%s*(%d+)%s*(%d+)%s*}")
  if x and y then
    return "LowMort"
  end
  
  return "Hero"
end


function GetPlaneName(area_name)
  if not area_name then area_name = gmcp.Room.Info.zone end
  --print("Area name:", area_name)
  
  if GetTier(area_name) ~= "Lord" then return "Midgaardia" end
 
  -- Look up the area name in the table and return the result,
  -- or "Unknown" if the area name is not found.
  return planeLookup[area_name] or "Unknown"
end


function GetAreaName(area_name)
  --\{( |\*)(\w+)( |\*)\} (\w+)\s*(.*)
  --{ LORD } Ctibor  Tarterus Menagerie
  --{ HERO } Mimir   Temple of Quixoltan
  --{*HERO*} Dev     Abishai's Pass

end