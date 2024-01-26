-- Trigger: Frenzy down 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): You slowly come out of your rage.

-- Script Code:
if not (gmcp.Char.Status.area_name == "{ ALL  } AVATAR  Sanctum") then
  if StatTable.Class == "Berserker" and not GlobalVar.Silent then
    send("gtell |BR|frenzy|N| is down! frenzy me please")
  elseif (StatTable.Fortitude and 
         (StatTable.Level > 51 or StatTable.SubLevel > 41) or
         (StatTable.Level >= 21 and (StatTable.Class == "Cleric" or StatTable.Class == "Druid" or StatTable.Class == "Vizier"))) then
      if (StatTable.Class == "Paladin") then 
        OnMobDeathQueue("cast fervor")
      else
        OnMobDeathQueue("cast frenzy")
      end
  end
  if not GlobalVar.Silent then send("emote is no longer |BR|Enraged|N|.") end
end

