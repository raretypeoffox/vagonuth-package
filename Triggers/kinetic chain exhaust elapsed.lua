-- Trigger: kinetic chain exhaust elapsed 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): One of your Exhaust timers has elapsed. (kinetic chain)

-- Script Code:

if StatTable.current_mana > 10000 then 
  OnMobDeathQueue("cast 'kinetic chain'")
end