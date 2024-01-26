-- Trigger: BattleStart - Groupmates 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(?<attacker>.*)'s attacks? strikes?
-- 1 (regex): ^(?<attacker>.*)'s bash strikes?
-- 2 (regex): ^(?<attacker>.*)'s (?<spell>.*) strikes?

-- Script Code:
if IsGroupMate(matches.attacker) then
  raiseEvent("OnCombat")
end