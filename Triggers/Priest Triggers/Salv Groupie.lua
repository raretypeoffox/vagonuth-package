-- Trigger: Salv Groupie 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^\*\w+\* tells the group 'salv (\w+)

-- Script Code:
TryAction("cast salvation " .. matches[2], 5)
