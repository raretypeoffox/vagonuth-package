-- Trigger: Identify - Level 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^Weight (?<weight>\d+), value (?<value>\d+), level (?<level>\d+).$

-- Script Code:
AutoEnchantTable.ItemBaseLevel = tonumber(matches.level)
AutoEnchantTable.ItemLevel = tonumber(matches.level)

local set_level = 0

if AutoEnchantTable.ItemLevel > 120 then
  set_level = 125 
elseif AutoEnchantTable.ItemLevel > 45 then
  set_level = 51
else
  set_level = AutoEnchantTable.ItemLevel
end

if set_level ~= AutoEnchantTable.BaseLevel then
  AutoEnchantTable.BaseLevel = set_level
  AutoEnchantPrint("Level set to " .. AutoEnchantTable.BaseLevel)
end