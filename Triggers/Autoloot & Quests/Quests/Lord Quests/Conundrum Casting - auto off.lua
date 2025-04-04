-- Trigger: Conundrum Casting - auto off 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^You (brimstone|maelstrom|mindwipe) quest fellowship of superheroes

-- Script Code:
beep()
printGameMessage("AutoCast", "Turned off, don't target quest mob", "red", "white")
AutoCastOFF()

safeTempTrigger("AutoCastAfterQuestSuperHeroes", "\"Sanctum, how sweet. Torch it.\"", function() AutoCastON() end, "begin", 1)