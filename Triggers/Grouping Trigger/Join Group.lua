-- Trigger: Join Group 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): You join (\w+)'s group.

-- Script Code:
send("monitor " ..matches[2])
