-- Trigger: Bzk terminal rampage end 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(\w+) stops using terminal rampage\.$

-- Script Code:
TryFunction("printAlertID", printGameMessage, {"Combat", matches[2] .. " has stopped their terminal rampage - don't let them die!", "red", "white"}, 10)