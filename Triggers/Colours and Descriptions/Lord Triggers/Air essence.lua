-- Trigger: Air essence 


-- Trigger Patterns:
-- 0 (start of line): The air elemental's energy erupts from its corpse and drifts off towards distant planes.

-- Script Code:

if not GlobalVar.Silent then send("emote |BC| Air essence lit!",false) end

printGameMessage("Essence", "Air essence has been lit!", "white", "cyan")

