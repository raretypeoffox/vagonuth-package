-- Trigger: AutoRescue - Remove Player From Stack 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^\w+ rescues (\w+)!
-- 1 (regex): ^You successfully rescue (\w+) from .*!

-- Script Code:
-- Remove player from stack when they're rescued (by groupmate or ourselves)
-- Note we require this for ourselves because sometimes there's a delay from the time the rescue command is issued and when they are actually rescued ( resulting in the player being re-added to the stack)
AR.RemovePlayerFromStack(string.lower(matches[2]))

if AR.MonitorRescue and GMCP_name(matches[2]) == GMCP_name(StatTable.Monitor) then
  AR.MonitorRescue = false
  printMessage("AutoRescue", "Monitor Rescue Off - Our monitor (" .. StatTable.Monitor .. ") was rescued")
end