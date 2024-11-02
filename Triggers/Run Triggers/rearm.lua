-- Trigger: rearm 
-- Attribute: isActive
-- Attribute: isColorizerTrigger

-- mFgColor: #ff0000
-- mBgColour: #ffff00

-- Trigger Patterns:
-- 0 (substring): disarms you and sends your weapon flying!

-- Script Code:
printGameMessage("Disarmed!", "Weapon was disarmed!", "red", "white")
send("rearm")
send("get all")
send("wield all")