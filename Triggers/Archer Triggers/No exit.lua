-- Trigger: No exit 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): There's no exit that way.

-- Script Code:
if not GlobalVar.Silent then send("gtell I can't shoot through walls, try again.") end