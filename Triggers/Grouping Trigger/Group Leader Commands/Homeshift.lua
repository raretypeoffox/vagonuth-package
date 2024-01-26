-- Trigger: Homeshift 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (exact): home

-- Script Code:
if (gmcp.Room.Info.zone ~= "{ LORD } Crom    Thorngate") then
  if (StatTable.Position == "Sleep") then send("stand") end
  
  local tempTriggerID = tempBeginOfLineTrigger("You failed your homeshift due to lack of concentration!", function() send("cast homeshift") end)
  tempBeginOfLineTrigger("You form a magical vortex and step into it...", function() killTrigger(tempTriggerID) end, 1)
  send("cast homeshift")
end