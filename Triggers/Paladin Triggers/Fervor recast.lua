-- Trigger: Fervor recast 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(Bhyss|Durr|Gorn|Kra|Quixoltan|Roixa|Shizaga|Tor|Tul-sith|Werredan)'s fanatical blessing fades away.

-- Script Code:
if (StatTable.Fortitude and StatTable.Level > 40) then
  OnMobDeathQueue("cast fervor")
end