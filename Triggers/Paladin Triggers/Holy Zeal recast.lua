-- Trigger: Holy Zeal recast 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): You feel less zealous.

-- Script Code:
if StatTable.Fortitude and not SafeArea() then
  OnMobDeathQueue("cast 'holy zeal'")
end