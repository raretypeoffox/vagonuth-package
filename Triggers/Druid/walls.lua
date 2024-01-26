-- Trigger: walls 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^\*\w+\* tells the group 'wall (\w+)'

-- Script Code:
send("c wall " .. matches[2])
