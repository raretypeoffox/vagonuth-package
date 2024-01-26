-- Trigger: Out of Ammo - Shot your last shot 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^You just shot your last (\w+)!

-- Script Code:
send("wear " .. matches[2])