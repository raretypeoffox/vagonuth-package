-- Trigger: Hit Tier 0 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): a Champions Gauntlets
-- 1 (substring): the talisman of chaos
-- 2 (substring): a ghostly disk
-- 3 (substring): gossamer leggings
-- 4 (substring): the Ring that Time Forgot
-- 5 (substring): the mark of insanity
-- 6 (substring): the gauntlets of mad certainty
-- 7 (substring): Scales of Scalamandrix

-- Script Code:
cecho (string.rep (" ",80-tonumber(string.len(line))) .. "<purple> [Hit T0]")
