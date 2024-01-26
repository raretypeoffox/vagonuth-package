-- Alias: AutoPlane
-- Attribute: isActive

-- Pattern: ^(?i)autoplane ?(on|off)?

-- Script Code:
local args = matches[2] or nil

if not args or args == "" then
  showCmdSyntax("AutoPlane\n\tSyntax: autostance (on|off)", {{"autoplane (on|off)", "whether to auto plane when the leader does"}})
  print("")
  printMessage("AutoPlane", "Set to " .. (GlobalVar.AutoPlane and "ON" or "OFF"))
  return
end

args = string.lower(args)

if args == "on" then
  GlobalVar.AutoPlane = true
else
  GlobalVar.AutoPlane = false
end

SaveProfileVars()

printMessage("AutoStance", "Set to " .. (GlobalVar.AutoPlane and "ON" or "OFF"))
