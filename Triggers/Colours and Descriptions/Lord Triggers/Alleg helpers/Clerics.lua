-- Trigger: Clerics 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): A whipped and beaten Demon tends the garden.

-- Script Code:
cecho (string.rep (" ",80-tonumber(string.len(line))) .. "<yellow> [CLERIC]")