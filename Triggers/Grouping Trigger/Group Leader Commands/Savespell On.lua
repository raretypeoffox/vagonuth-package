-- Trigger: Savespell On 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (exact): spellsave on
-- 1 (exact): savespell on
-- 2 (exact): pss

-- Script Code:
if StatTable.Savespell == nil or StatTable.Savespell == false then send("config +savespell",false); StatTable.Savespell = true end
