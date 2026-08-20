beep()
printGameMessage("AutoCast", "Turned off, don't target quest mob", "red", "white")
AutoCastOFF()

safeTempTrigger("AutoCastAfterQuestSuperHeroes", "\"Sanctum, how sweet. Torch it.\"", function() AutoCastON() end, "begin", 1)