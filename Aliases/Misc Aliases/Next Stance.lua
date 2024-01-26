-- Alias: Next Stance
-- Attribute: isActive

-- Pattern: ^(?i)nextstance ?(.*)

-- Script Code:
local args = matches[2] or nil

if not args or args == "" then
  showCmdSyntax("NextStance\n\tSyntax: nextstance <stance>", {{"nextstance <stance>", "overides autostance to manually change to the next bld dance"}})
  return
end

if StatTable.Class ~= "Bladedancer" then
  printMessage("Nextstance error", "command is only for bladedancers")
  return
end

args = string.lower(args)

if not (StatTable.InspireTimer or StatTable.BladedanceTimer or StatTable.DervishTimer or StatTable.VeilTimer or StatTable.UnendTimer) then
  TryAction("stance " .. GlobalVar.NextStance, 5)
  printMessage("NextStance", "No stance active, activating " .. GlobalVar.NextStance .. "now.")
  GlobalVar.NextStance = nil
  return
end

GlobalVar.NextStance = args

printMessage("NextStance", "Next Stance will be " .. GlobalVar.NextStance)

