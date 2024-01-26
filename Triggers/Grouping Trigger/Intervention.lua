-- Trigger: Intervention 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): You are no longer due divine intervention.

-- Script Code:

if SafeArea() then return end

if not (StatTable.Class == "Priest") then
  send("emote |BW| intervention|N| is down!")
  return
end

--if (StatTable.Fortitude and 
--(StatTable.Level > 51 or StatTable.SubLevel > 250) and StatTable.current_mana > 100) then
--  if (StatTable.InterventionExhaust == nil) then
--    OnMobDeathQueuePriority("cast intervention")
--  else
--    tempTimer(30 * (StatTable.InterventionExhaust + 1), function() OnMobDeathQueuePriority("cast intervention") end)
--  end
--end

