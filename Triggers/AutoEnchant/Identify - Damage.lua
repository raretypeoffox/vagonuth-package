-- Trigger: Identify - Damage 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^Damage is (?<mindmg>\d+) to (?<maxdmg>\d+) \(average (?<averagedmg>\d+)\)\.$

-- Script Code:
AutoEnchantTable.ItemMinDmg = tonumber(matches.mindmg)
AutoEnchantTable.ItemMaxDmg = tonumber(matches.maxdmg)
  
-- We collected all the info we need from identify now, we can now try casting enchant
AutoEnchantTable.ID = 1
AutoEnchantTry()

