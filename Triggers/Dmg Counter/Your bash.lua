-- Trigger: Your bash 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^You bash (?<victim>.*) with (?<dmgdesc>.*) \w+[!.]

-- Script Code:
DamageCounter.AddDmg(StatTable.CharName, matches.dmgdesc, true)







