-- Trigger: Need to be Flying/Boat 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^You need to be flying to go (east|west|north|south|up|down).$
-- 1 (regex): ^You need a boat to go to the (\w+).$

-- Script Code:
if StatTable.Class == "Berserker" then
  if not GlobalVar.Silent then send ("gtell I couldn't follow - |BR|flying down!|N|") end
else
  if not not GlobalVar.Silent then send ("gtell I couldn't follow - attempting to cast fly!") end
  local direction = matches[2]
    
  local tempTriggerID = tempBeginOfLineTrigger("You failed your fly due to lack of concentration!", function() send("cast fly") end)
  tempBeginOfLineTrigger("Your feet rise off the ground.", function() killTrigger(tempTriggerID); send(direction) end, 1)

  send("cast fly")
    
    
end