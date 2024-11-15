-- Trigger: Unrest 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): There is no rest for the cursed!

-- Script Code:
if SafeArea() then
  for _, player in ipairs(StaticVars.PrsBots) do
    if gmcp.Room.Players[player] then
      TryAction("tell " .. player .. " clarify", 15)
      break
    end
  end
elseif not GlobalVar.Silent then
  TryAction("gtell clarify", 60)
end

printGameMessage("Unrest", "There is no rest for the cursed!", "red", "white")

if not IsMDAY() then QuickBeep() end