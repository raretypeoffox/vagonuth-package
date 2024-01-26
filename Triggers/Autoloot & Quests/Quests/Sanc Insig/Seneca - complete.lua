-- Trigger: Seneca - complete 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): Seneca Rotberry pins a clay token onto your armor.

-- Script Code:
tempTimer(5, function() send("open south"); send("south"); send("sleep") end)
send("pinfo + Sanc insig until level " .. (StatTable.SubLevel + 74))