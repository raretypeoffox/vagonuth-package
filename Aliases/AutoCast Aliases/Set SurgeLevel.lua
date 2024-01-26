-- Alias: Set SurgeLevel
-- Attribute: isActive

-- Pattern: ^(1|2|3|4|5)$

-- Script Code:
GlobalVar.SurgeLevel = tonumber(matches[2])
if (StatTable.Position ~= "Sleep") then send("surge " .. GlobalVar.SurgeLevel) end
AutoCastStatus()

