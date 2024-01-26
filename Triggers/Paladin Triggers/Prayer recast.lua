-- Trigger: Prayer recast 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(Bhyss|Durr|Gorn|Kra|Quixoltan|Roixa|Shizaga|Tor|Tul-sith|Werredan)'s presence disappears.

-- Script Code:
if (GlobalVar.PrayerName ~= "") then
  OnMobDeathQueue("cast prayer '" .. GlobalVar.PrayerName .. "'")
end