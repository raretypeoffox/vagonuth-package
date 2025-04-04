-- Trigger: On Level 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): Your powers increase!!!

-- Script Code:
if (GlobalVar.LevelGear) then 
  send("unlevel")
  tempTimer(10,[[GlobalVar.LevelReady = false]])
end



if (StatTable.Class == "Sorcerer" and not SafeArea() and StatTable.Foci and StatTable.Foci > 15 and StatTable.Level > 39 and not StatTable.TaintedExhaust and (StatTable.current_mana / StatTable.max_mana) > 0.25 and Grouped()) then
  if GroupSize() <= 3 and StatTable.Level == 125 then return end
  send("cast tainted")
  if (StatTable.DeathShroud == nil) then    
      OnMobDeathQueue("cast 'death shroud'")
  end
end

raiseEvent("OnLevel")
