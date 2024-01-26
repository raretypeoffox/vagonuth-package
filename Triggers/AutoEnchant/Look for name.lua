-- Trigger: Look for name 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^You look at (?<fullname>.*) in your inventory...$

-- Script Code:
AutoEnchantTable.ItemName = string.lower(matches.fullname)
