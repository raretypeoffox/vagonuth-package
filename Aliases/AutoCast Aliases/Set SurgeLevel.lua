-- Alias: Set SurgeLevel
-- Attribute: isActive

-- Pattern: ^(?i)s?(1|2|3|4|5)$

-- Script Code:
local requested_surge_level = tonumber(matches[2])
local max_surge_level = Surge and Surge.GetMaxLevel() or 5

GlobalVar.SurgeLevel = Surge and Surge.ClampLevel(requested_surge_level, max_surge_level) or requested_surge_level

if requested_surge_level > GlobalVar.SurgeLevel then
  printGameMessage("Surge", "Max surge is surge " .. max_surge_level .. ", setting surge level to " .. GlobalVar.SurgeLevel)
end

if (StatTable.Position ~= "Sleep") then send("surge " .. GlobalVar.SurgeLevel) end
AutoCastStatus()
