-- Trigger: Need to be Flying/Boat 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^You need to be flying to go (east|west|north|south|up|down)\.$
-- 1 (regex): ^You need a boat to go to the (\w+)\.$

-- Script Code:
if StatTable.Class == "Berserker" then
  if not GlobalVar.Silent then send ("gtell I couldn't follow - |BR|flying down!|N|") end
else
  if not not GlobalVar.Silent then send ("gtell I couldn't follow - attempting to cast fly!") end
  local direction = matches[2]
     
  safeTempTrigger("YouFailedFly", "You failed your fly due to lack of concentration!", function() send("cast fly") end, "begin")
  safeTempTrigger("YourFeetRise", "Your feet rise off the ground.", function() safeKillTrigger("YouFailedFly"); send(direction) end, "begin", 1)
  
  
  safeEventHandler("NeedToBeFlyingEventID", "OnQuit", function() safeKillTrigger("YouFailedFly"); safeKillTrigger("YourFeetRise") end, true)  
  send("cast fly")
    
    
end