-- Trigger: Sneak 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): You no longer feel stealthy.

-- Script Code:
if not (gmcp.Room.Info.zone == "{ ALL  } AVATAR  Sanctum" or gmcp.Room.Info.zone == "{ LORD } Dev     Rietta's Wonders") then
  if StatTable.Fortitude then
    OnMobDeathQueue("sneak")
  end
end