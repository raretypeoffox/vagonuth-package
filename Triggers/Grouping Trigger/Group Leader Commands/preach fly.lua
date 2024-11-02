-- Trigger: preach fly 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): preach fly

-- Script Code:
if (StatTable.Class == "Priest" and StatTable.Level == 125 and StatTable.SubLevel >= 25) then
  if Battle.Combat then
    OnMobDeathQueuePriority("preach fly")
  else
    send("preach fly")
  end
end