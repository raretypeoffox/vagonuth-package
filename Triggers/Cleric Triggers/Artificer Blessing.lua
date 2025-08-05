-- Trigger: Artificer Blessing 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): Your artificer blessing is no more.

-- Script Code:
local ArtBlessCounter = ArtBlessCounter or 0

if gmcp.Char.Status.area_name == "{ ALL  } AVATAR  Sanctum"
   or gmcp.Char.Status.area_name == "{ LORD } Crom    Thorngate"
   or gmcp.Char.Status.area_name == "{ LORD } Dev     Rietta's Wonders"
then
  if Grouped() then return end

  local was_asleep = false
  if StatTable.Position == "Sleep" then
    send("stand")
    was_asleep = true
  end

  send("cast artificer")

  -- only every 5th blessing, to prevent spam warnings
  if (ArtBlessCounter % 5) == 0 then
    send("score")
  end

  if was_asleep then
    send("sleep")
  end
end
