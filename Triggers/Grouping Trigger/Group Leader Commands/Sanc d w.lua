-- Trigger: Sanc d w 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): sanc d w
-- 1 (exact): ok sanctum
-- 2 (substring): sanc dw

-- Script Code:
send("sanctum")
send("down")
send("west")
if StatTable.Savespell == nil or StatTable.Savespell then send("config -savespell",false); StatTable.Savespell = false end
send("sleep")