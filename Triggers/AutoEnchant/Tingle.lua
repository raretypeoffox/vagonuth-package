-- Trigger: Tingle 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^You have practiced enchant \w+ to (?<tingle>\d+) percent.$

-- Script Code:
AutoEnchantTable.Tingle = tonumber(matches.tingle)
