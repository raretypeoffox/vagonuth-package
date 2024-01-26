-- Trigger: Follow Direction 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^You follow (?<leader>\w+) (?<direction>\w+).$

-- Script Code:
AddDir(matches.direction)