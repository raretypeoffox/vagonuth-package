-- Trigger: Planar Summon 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): planar summon
-- 1 (substring): anchor summon
-- 2 (substring): summon anchor

-- Script Code:
if (StatTable.Class == "Psionicist" or StatTable.Class == "Mindbender") then
  TryAction("cast planar summon", 10)
end