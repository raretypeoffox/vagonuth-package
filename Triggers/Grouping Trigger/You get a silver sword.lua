-- Trigger: You get a silver sword 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^You get (\w+)'s silver sword from corpse
-- 1 (regex): ^You get (\w+)'s offhand silver sword from corpse

-- Script Code:
send("give " .. matches[2] .. " " .. matches[2])