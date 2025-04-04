-- Trigger: Earth essence 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): The earth elemental's energy erupts from its corpse and drifts off towards distant planes.

-- Script Code:
if not GlobalVar.Silent then send("emote |BY| Earth essence lit!",false) end

printGameMessage("Essence", "Earth essence has been lit!", "white", "yellow")
