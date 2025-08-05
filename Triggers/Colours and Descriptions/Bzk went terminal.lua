-- Trigger: Bzk went terminal 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^A desperate cry of fury howls from (\w+)'s lips!$

-- Script Code:
printGameMessage("Combat", matches[2] .. " just went terminal!")