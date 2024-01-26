-- Trigger: Identify - AC 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^Armor class is (?<ac>\d+).$

-- Script Code:
AutoEnchantTable.ItemAC = tonumber(matches.ac)

-- We collected all the info we need from identify now, we can now try casting enchant
AutoEnchantTable.ID = 1
AutoEnchantTry()
