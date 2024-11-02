-- Trigger: remove curse 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): Shizaga frowns at you...

-- Script Code:
-- cursed
if SafeArea() then
  local Players = gmcp.Room.Players
  for _, player in ipairs(StaticVars.DruidBots) do
    if Players[player] then
      send("tell " .. player .. " rc")
      break
    end
  end
  return
end

if IsMDAY() and Grouped() then
  send("gtell rc")
end