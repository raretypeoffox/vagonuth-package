-- Trigger: AutoRescue - stabber 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(\w+)'s pierce strikes
-- 1 (regex): ^(\w+)'s backstab

-- Script Code:
if AR.RescueList[string.lower(matches[2])] and not Battle.Combat then
  send("rescue " .. matches[2])
--else
  --AR.Rescue(string.lower(matches[2]))
end