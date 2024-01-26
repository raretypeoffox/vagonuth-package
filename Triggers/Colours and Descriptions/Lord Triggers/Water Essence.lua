-- Trigger: Water Essence 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): The water elemental's energy erupts from its corpse and drifts off toward distant planes.

-- Script Code:

if not GlobalVar.Silent then send("emote |BB| Water essence lit!",false) end

printGameMessage("Essence", "Water essence has been lit!", "white", "blue")
