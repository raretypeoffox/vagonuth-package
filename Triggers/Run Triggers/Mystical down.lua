-- Trigger: Mystical down 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): Your mystical barrier shimmers and is gone.

-- Script Code:
-- hack for legends for now, remove this trigger later (handled by buffmanager)
if StatTable.Level ~= 250 then return end

if (GlobalVar.GroupLeader ~= StatTable.CharName and GlobalVar.GroupLeader ~= "") then
  if StatTable.Fortitude then
    OnMobDeathQueue("cast mystical")
  end
end
