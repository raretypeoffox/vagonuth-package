-- Trigger: beep 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^.You are being BEEPED by (\w+)!.$

-- Script Code:
alert()
beep()

printGameMessage("Beep!", "You've been beeped by <cyan>" .. matches[2] .. "<ansi_cyan>!", "cyan")

