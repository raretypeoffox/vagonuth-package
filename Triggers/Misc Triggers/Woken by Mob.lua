-- Trigger: Woken by Mob 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): You stand up and face your attacker.

-- Script Code:
QuickBeep()
printGameMessage("Beep!", "Woken by mob!", "red", "white")
send("stand")

