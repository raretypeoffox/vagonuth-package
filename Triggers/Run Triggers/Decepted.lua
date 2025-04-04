-- Trigger: Decepted 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^You frantically attempt to remove (.*)!$

-- Script Code:
QuickBeep()
printGameMessage("Decepted!", matches[2])
