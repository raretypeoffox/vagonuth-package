-- Trigger: lock - trap 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): The a small wooden lockbox looks like it is armed with a (\w+) trap.

-- Script Code:
send("hold trap")
send("dismant " .. matches[2] .. " lockbox")
