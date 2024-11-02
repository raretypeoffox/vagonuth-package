-- Trigger: Artificer Blessing 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): Your artificer blessing is no more.

-- Script Code:
if (gmcp.Char.Status.area_name == "{ ALL  } AVATAR  Sanctum" or gmcp.Char.Status.area_name == "{ LORD } Crom    Thorngate" or gmcp.Char.Status.area_name == "{ LORD } Dev     Rietta's Wonders") then
  if Grouped() then return end
  local was_asleep = false
  if (StatTable.Position == "Sleep") then send("stand"); was_asleep = true end
  send("cast artificer")
  if was_asleep then send("sleep") end
end

