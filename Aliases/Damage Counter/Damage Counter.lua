-- Alias: Damage Counter
-- Attribute: isActive

-- Pattern: ^(?i)rep(dmg|dmg top|dmg bot|dmg #) ?(\d+)?$

-- Script Code:
local cmd = (matches[2] or ""):lower()
local args = (matches[3] or "")
args = tonumber(args)

if cmd == "dmg top" then
  if args then
    DamageCounter.Report("<=", args)
  end
elseif cmd == "dmg bot" then
  if args then
    DamageCounter.Report(">=", args)
  end
elseif cmd == "dmg #" then
  if args then
    DamageCounter.Report("==", args)
  end
else
  DamageCounter.ReportEcho("<", 20)
end




