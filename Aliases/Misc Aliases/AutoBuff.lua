-- Alias: AutoBuff
-- Attribute: isActive

-- Pattern: ^(?i)autobuff ?(on|off)?

-- Script Code:
local args = matches[2] or nil

if not args or args == "" then
  showCmdSyntax("AutoBuff\n\tSyntax: autobuff (on|off)", {{"autobuff (on|off)", "whether to recast out-of-combat buffs after combat"}})
  print("")
  printMessage("AutoBuff", "Set to " .. (GlobalVar.AutoBuff and "ON" or "OFF"))
  return
end

args = string.lower(args)

if args == "on" then
  GlobalVar.AutoBuff = true
else
  GlobalVar.AutoBuff = false
end

SaveProfileVars()

printMessage("AutoBuff", "Set to " .. (GlobalVar.AutoBuff and "ON" or "OFF"))
