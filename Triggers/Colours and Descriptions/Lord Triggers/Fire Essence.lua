-- Trigger: Fire Essence 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): The fire elemental's energy erupts from its corpse and drifts off towards distant planes.

-- Script Code:

if not GlobalVar.Silent then send("emote |BR| Fire essence lit!",false) end

printGameMessage("Essence", "Fire essence has been lit!", "white", "red")
