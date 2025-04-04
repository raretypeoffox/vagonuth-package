-- Trigger: loot your corpse 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^     The corpse of (\w+) is lying here

-- Script Code:
if matches[2] == StatTable.CharName then
  TryAction("get all " .. StatTable.CharName .. cs .. "wear all", 30)
end