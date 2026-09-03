if (gmcp.Char.Status.area_name == "{ ALL  } AVATAR  Sanctum" and StatTable.Position == "Sleep") then send("stand") end

local colour_code = matches.colour_code or ""
local portal_action = colour_code ~= "" and (string.gsub(colour_code,"/", "|") .. matches.portal_string) or matches.portal_string

if string.sub(matches.portal_string,1,2) == "ne" or string.sub(matches.portal_string,1,2) == "mi" then
  TryAction("enter " .. portal_action, 15)
else
  send("enter " .. portal_action)
end
