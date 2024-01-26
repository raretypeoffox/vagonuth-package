-- Trigger: Savespell Off 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (exact): spellsave off
-- 1 (exact): savespell off
-- 2 (exact): mss
-- 3 (substring): tick off

-- Script Code:
if StatTable.Savespell == nil or StatTable.Savespell then send("config -savespell",false); StatTable.Savespell = false end