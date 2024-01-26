-- Trigger: Cursed Items 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): You can't let go of

-- Script Code:
-- When you encounter a cursed item
-- 1. if you're a sorcerer, cast remove curse
-- 2. if you're in a safe area, see if there's a druid to help
-- 3. If it's mday, ask group for rc

if StatTable.Class == "Sorcerer" and StatTable.Level >= 18 then
  Battle.DoAfterCombat("cast 'remove curse'")
  return
end

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
