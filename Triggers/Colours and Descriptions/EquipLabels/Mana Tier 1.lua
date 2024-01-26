-- Trigger: Mana Tier 1 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): a Golden Dragonskull
-- 1 (substring): a lord's head chalice
-- 2 (substring): a glimmer of hellfire
-- 3 (substring): the rod of elemental power
-- 4 (substring): a watershape
-- 5 (substring): belt of sorcery
-- 6 (substring): a staff of ancient magicks
-- 7 (substring): the quarterstaff, "Wanderer"
-- 8 (substring): the cloak of darkness
-- 9 (substring): wraith essence
-- 10 (substring): Phoenix-Feather Greaves

-- Script Code:
cecho (string.rep (" ",80-tonumber(string.len(line))) .. "<purple> [Mana T1]")