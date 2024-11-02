-- Trigger: stuning weapon 


-- Trigger Patterns:
-- 0 (start of line): Your weapons lose the ability to stun.

-- Script Code:
--todo
if StatTable.current_mana > 5000 then
  OnMobDeathQueue("cast 'stunning weapon'")
end