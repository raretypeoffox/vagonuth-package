-- Trigger: Artificer blessing 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^Spell: 'artificer blessing aura'  by  (?<artificer>\d+) for .*.$

-- Script Code:
AutoEnchantTable.Artificer = tonumber(matches.artificer)
