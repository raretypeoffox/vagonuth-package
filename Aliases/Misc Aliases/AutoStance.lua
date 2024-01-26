-- Alias: AutoStance
-- Attribute: isActive

-- Pattern: ^(?i)autostance ?(on|off)?

-- Script Code:
local args = matches[2] or nil

if not args or args == "" then
  showCmdSyntax("AutoStance\n\tSyntax: autostance (on|off)", {{"autostance (on|off)", "whether to auto switch stances (eg bld, war, etc)"}})
  print("")
  printMessage("AutoStance", "Set to " .. (GlobalVar.AutoStance and "ON" or "OFF"))
  return
end

args = string.lower(args)

if args == "on" then
  GlobalVar.AutoStance = true
else
  GlobalVar.AutoStance = false
end

SaveProfileVars()

printMessage("AutoStance", "Set to " .. (GlobalVar.AutoStance and "ON" or "OFF"))
