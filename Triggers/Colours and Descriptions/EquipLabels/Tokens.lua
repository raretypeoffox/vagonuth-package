-- Trigger: Tokens 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): the fae rune for 'Hope'
-- 1 (substring): heart of Heat
-- 2 (substring): half of the Sundered Ring
-- 3 (substring): blood-mithril shackle
-- 4 (substring): blood-mithril shackle
-- 5 (substring): old double-curved sword
-- 6 (substring): a demon fang

-- Script Code:
cecho (string.rep (" ",80-tonumber(string.len(line))) .. "<blue> [TOKEN]")