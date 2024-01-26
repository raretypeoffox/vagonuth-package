-- Alias: g-adv
-- Attribute: isActive

-- Pattern: ^g-adv (.*)$

-- Script Code:
if StatTable.Level == 125 then send("lord " .. matches[2]) end 
if StatTable.Level >= 51 then send("hero " .. matches[2]) end
send("chat " .. matches[2])