-- Trigger: Mystical down 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): Your mystical barrier shimmers and is gone.

-- Script Code:

if StatTable.Fortitude then
  OnMobDeathQueue("cast mystical")
end
