-- Trigger: Move Hidden 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): You no longer move hidden.

-- Script Code:
if not (gmcp.Room.Info.zone == "{ ALL  } AVATAR  Sanctum" or gmcp.Room.Info.zone == "{ LORD } Dev     Rietta's Wonders") then
  if StatTable.Fortitude then
    OnMobDeathQueue("move hidden")
  end
end