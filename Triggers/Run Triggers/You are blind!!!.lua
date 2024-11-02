-- Trigger: You are blind!!! 
-- Attribute: isActive
-- Attribute: isColorizerTrigger

-- mFgColor: #ff0000
-- mBgColour: #ffff00

-- Trigger Patterns:
-- 0 (start of line): You are blind!!!

-- Script Code:
printGameMessage("Battle", "You are blind!!!")

if StatTable.Class == "Sorcerer" or StatTable.Class == "Berserker" or AR.Status then
  if not GlobalVar.Silent then TryAction("gtell cb", 5) end
elseif StatTable.Class == "Priest" and (StatTable.Level == 125 or StatTable.SubLevel > 500) then
  Battle.DoAfterCombat("preach panacea")
elseif StatTable.Class == "Ripper" then
  Battle.DoAfterCombat("cast 'mass aid'")
else
  Battle.DoAfterCombat("cast 'cure blindness'")
end
