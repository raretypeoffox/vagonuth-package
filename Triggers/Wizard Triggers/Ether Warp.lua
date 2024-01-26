-- Trigger: Ether Warp 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): You no longer warp the Ether around you.

-- Script Code:
if not StatTable.Fortitude then return end

Battle.DoAfterCombat("cast 'ether warp'")