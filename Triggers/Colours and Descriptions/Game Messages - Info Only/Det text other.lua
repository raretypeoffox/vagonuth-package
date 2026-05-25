-- Trigger: Det text other 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^Moments before detonation, (\w+)'s the (.*) vanishes suddenly!

-- Script Code:
printGameMessage("Det Alert!", matches[2] .. " lost their " .. matches[3] .. "!", "red", "white")