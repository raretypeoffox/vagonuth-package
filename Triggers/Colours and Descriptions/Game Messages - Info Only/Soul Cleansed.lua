-- Trigger: Soul Cleansed 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(\w+) soul has been cleansed!$

-- Script Code:
printGameMessage("SoulCleanse", matches[2] .. " soul has been cleansed!", "yellow", "white")