-- Trigger: Pick 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^\*\w+\* tells the group 'pick (\w+)'

-- Script Code:
send("wear door")
send("pick " .. matches[2])
send("wear lode") -- todo make better
