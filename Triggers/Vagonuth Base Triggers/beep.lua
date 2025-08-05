-- Trigger: beep 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^.You are being BEEPED by (\w+)!.$

-- Script Code:

TryFunction("BeepedAlert", alert, nil, 5)
TryFunction("BeepedSound", beep, nil, 5)


printGameMessage("Beep!", "You've been beeped by <cyan>" .. matches[2] .. "<ansi_cyan>!", "cyan")

