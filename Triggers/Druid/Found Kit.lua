-- Trigger: Found Kit 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^You forage for a while and procure natural fletching materials.

-- Script Code:
  StatTable.forage_kits = StatTable.forage_kits + 1
  cecho("Kit Step Fired.")