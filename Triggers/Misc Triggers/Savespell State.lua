-- Trigger: Savespell State 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^Ok, your savespell is now set to (\w+)\.$

-- Script Code:
StatTable.Savespell = (matches[2] == "ON") and true or false