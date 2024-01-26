-- Trigger: Miss 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(?<attacker>.*) fires at (?<victim>.*) and misses!
-- 1 (regex): ^(?<attacker>.*)'s attacks haven't hurt (?<victim>.*)!

-- Script Code:
if GlobalVar.GroupMates[GMCP_name(matches.attacker)] then
  DamageCounter.AddDmg(matches.attacker, "nil")
end