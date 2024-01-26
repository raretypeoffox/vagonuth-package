-- Trigger: Lord Weapons 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): "Howl, the Windhammer"
-- 1 (substring): an ancient dragon claw
-- 2 (substring): a head on a stick
-- 3 (substring): a silver sword
-- 4 (substring): the Sting that Time Forgot
-- 5 (substring): a ruby dagger
-- 6 (substring): pick of the Mastodor
-- 7 (substring): the Chain of Thorns

-- Script Code:
cecho (string.rep (" ",80-tonumber(string.len(line))) .. "<purple> [WEAPONS]")