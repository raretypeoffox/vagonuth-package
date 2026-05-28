-- Trigger: Ether Link 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): You no are no longer linked to others through the Ether.

-- Script Code:
if not StatTable.Fortitude then return end

TryAction("cast 'ether link'",5)

OnMobDeathQueue("cast 'ether link'")