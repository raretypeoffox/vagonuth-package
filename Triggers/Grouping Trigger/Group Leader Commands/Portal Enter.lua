-- Trigger: Portal Enter 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^ent?e?r? (\w+)$

-- Script Code:
if (gmcp.Char.Status.area_name == "{ ALL  } AVATAR  Sanctum" and StatTable.Position == "Sleep") then send("stand") end

if string.sub(matches[2],1,2) == "ne" or string.sub(matches[2],1,2) == "mi" then
  TryAction("enter " .. matches[2], 15)
else
  send("enter " .. matches[2])
end