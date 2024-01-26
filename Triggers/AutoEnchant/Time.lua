-- Trigger: Time 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^It is .*, (?<day>.*), .* in the Month of the (?<month>\w+).$

-- Script Code:
AutoEnchantTable.Day = matches.day
AutoEnchantTable.Month = matches.month
