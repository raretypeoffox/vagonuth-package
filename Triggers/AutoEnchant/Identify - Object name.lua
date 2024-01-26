-- Trigger: Identify - Object name 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^Object '(?<name>.*)' type (?<type>.*), extra flags (?<flags>.*)$

-- Script Code:
--AutoEnchantItemName = matches.name -- move to look
AutoEnchantTable.ItemIDType = matches.type
AutoEnchantTable.ItemFlags = matches.flags

  

