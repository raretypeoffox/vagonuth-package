-- Trigger: Mystical down 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): Your mystical barrier shimmers and is gone.

-- Script Code:
if (GlobalVar.GroupLeader ~= StatTable.CharName and GlobalVar.GroupLeader ~= "") then
  if StatTable.Fortitude then
    OnMobDeathQueue("cast mystical")
  end
end
