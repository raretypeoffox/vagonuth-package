-- Trigger: Gravitas self 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (exact): You lose your gravitas.

-- Script Code:
if StatTable.current_mana > 1000 then 
  Battle.DoAfterCombat("cast 'gravitas'")
end