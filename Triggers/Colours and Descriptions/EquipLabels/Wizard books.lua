-- Trigger: Wizard books 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): a dusty tome of forgotten lore
-- 1 (substring): rediscovering Ether
-- 2 (substring): the book of Flash
-- 3 (substring): the book of Force Field
-- 4 (substring): the book of shard storm
-- 5 (substring): the book of Rune

-- Script Code:
cecho (string.rep (" ",80-tonumber(string.len(line))) .. "<blue> [Wzd Book]")