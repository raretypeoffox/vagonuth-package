-- Trigger: BattleTracker - Rescue 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(\w+) rescues (\w+)!

-- Script Code:
GroupiesUnderAttack = GroupiesUnderAttack or {}

local rescuer = GMCP_name(matches[2])
local rescuee = GMCP_name(matches[3])

if GroupiesUnderAttack[rescuer] == nil then
  GroupiesUnderAttack[rescuer] = 1
else
  GroupiesUnderAttack[rescuer] = GroupiesUnderAttack[rescuer] + 1
end

if GroupiesUnderAttack[rescuee] ~= nil then
  if GroupiesUnderAttack[rescuee] == 1 then 
    GroupiesUnderAttack[rescuee] = nil
  else
    GroupiesUnderAttack[rescuee] = GroupiesUnderAttack[rescuee] - 1
  end
end

BattleTracker.UpdateMobAttackTable("nil")