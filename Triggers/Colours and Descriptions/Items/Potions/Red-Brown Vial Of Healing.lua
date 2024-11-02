-- Trigger: Red-Brown Vial Of Healing 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): red-brown vial
-- 1 (substring): a piece of golden crystal
-- 2 (substring): an enchanted stem

-- Script Code:
cecho (string.rep (" ",65-tonumber(string.len(line))) .."<purple> **[250 HP]**")