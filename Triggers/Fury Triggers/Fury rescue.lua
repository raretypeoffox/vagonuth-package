-- Trigger: Fury rescue 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): looks pretty hurt.
-- 1 (substring): is in awful condition.

-- Script Code:
-- Provides for an alternative method of rescue healing
-- Benefit: when multiple mobs are fighting group, this trigger is able to detect if the mob we specifically are fighting (ie gmcp.Char.Status.opponent_name)
--          is only attacking one groupmate and if so, to rescue the groupmate when the mob is low
-- Con:     works less reliably when using skills with lag as it goes off of the look command

GlobalVar.FuryRescue = GlobalVar.FuryRescue or true -- for now

if not GlobalVar.FuryRescue  then return end
if not StatTable.Wildmind then return end

-- set rescue hp % levels for rescueing with sanc vs without
if StatTable.Sanctuary then
  if (StatTable.current_health / StatTable.max_health) < 0.50 then return end
else
  if (StatTable.current_health / StatTable.max_health) < 0.75 then return end
end

target = string.lower(gmcp.Char.Status.opponent_name)


local count = 0
local index = nil
for i, j in pairs(Battle.EnemiesAttacking) do
  if j[1] == target then 
    count = count + 1     
    index = i
  end
end

-- Only one mob of this name so we can accurately determine who its attacking
if (count == 1 and StatTable.Level <= 51) then
  rescuetarget = Battle.EnemiesAttacking[index][2]
  -- Is this the only mob attacking our rescue target? Also make sure we're not the rescue target
  if (Battle.GroupiesUnderAttack[rescuetarget] == 1 and rescuetarget ~= StatTable.CharName) then
    -- Are we in a position to rescue?
    if (tonumber(gmcp.Char.Vitals.lag) <= 2 and (StatTable.current_health / StatTable.max_health) > 0.50 and 
    (Battle.GroupiesUnderAttack[StatTable.CharName] == nil or (Battle.GroupiesUnderAttack[StatTable.CharName] ~= nil and tonumber(Battle.GroupiesUnderAttack[StatTable.CharName]) == 0))) then
      
      if (GlobalVar.GroupMates[rescuetarget].class ~= "Pal" and GlobalVar.GroupMates[rescuetarget].class ~= "Fyr") then 
        TryAction("r " .. rescuetarget,2) 
        TryFunction("printFuryRescue", printGameMessage, {"Fury Rescue!", "Trying to rescue " .. rescuetarget}, 2)
        end
    
    
    end  
  end  
end
