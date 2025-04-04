-- Trigger: Open door 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^\w+ (pick|unlock)s? the \w+ (above|below) you\.$
-- 1 (regex): ^\w+ (pick|unlock)s? the \w+ to the (west|east|south|north)\.$

-- Script Code:
--Dojo picks the gate above you.
--You unlock the door to the south.

local dir = matches[3]

if dir == "above" then dir = "up"
elseif dir == "below" then dir = "down" end

send("open " .. dir)