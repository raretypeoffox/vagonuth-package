-- Trigger: Frenzy failed 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): You failed your frenzy due to lack of concentration!

-- Script Code:
if GlobalVar.AutoFrenzy == false or SafeArea() then return end

if (StatTable.Fortitude and 
  (StatTable.Level > 51 or StatTable.SubLevel > 41) or
  (StatTable.Level >= 21 and (StatTable.Class == "Cleric" or StatTable.Class == "Druid" or StatTable.Class == "Vizier"))) then
  
  if (StatTable.Class == "Paladin") then 
    Battle.DoAfterCombat("cast fervor")
  else
    Battle.DoAfterCombat("cast frenzy")
  end
end