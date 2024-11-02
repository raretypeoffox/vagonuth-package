-- Trigger: Your hit 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^Your attacks? strikes? (?<victim>.*) (\d+) times?, with (?<dmgdesc>.*) \w+[!.]
-- 1 (regex): ^Your shot hits (?<victim>.*) with (?<dmgdesc>.*) \w+[!.]
-- 2 (regex): ^You (\w+) (?<victim>.*) with (?<dmgdesc>.*) \w+[!.]

-- Script Code:
DamageCounter.AddDmg(StatTable.CharName, matches.dmgdesc, false)

--if not Battle.Combat then raiseEvent("OnCombat") end






