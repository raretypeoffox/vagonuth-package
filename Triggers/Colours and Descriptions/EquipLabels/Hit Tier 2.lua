-- Trigger: Hit Tier 2 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): a cloud of dancing shards
-- 1 (substring): the helm of the oblivious defender
-- 2 (substring): the ring of the Burning River
-- 3 (substring): a Tuataur battle tunic

-- Script Code:
cecho (string.rep (" ",80-tonumber(string.len(line))) .. "<purple> [Hit T2-3]")