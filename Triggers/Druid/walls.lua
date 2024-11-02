-- Trigger: walls 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^\*\w+\* tells the group 'wall (\w+)'

-- Script Code:
if StatTable.Position == "Stand" then
  send("cast wall " .. matches[2])
end