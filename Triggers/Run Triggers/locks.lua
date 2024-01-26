-- Trigger: locks 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^\*\w+\* tells the group 'un\w* (\w+)'

-- Script Code:
send("unlock " .. matches[2])
send("open " .. matches[2])