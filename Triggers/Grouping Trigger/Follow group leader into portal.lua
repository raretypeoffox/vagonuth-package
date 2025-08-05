-- Trigger: Follow group leader into portal 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(\w+) enters a portal.

-- Script Code:
--if not IsMDAY() then return end

if (IsGroupLeader(matches[2])) then
  tempTimer(1, function() send("enter portal") end)
end