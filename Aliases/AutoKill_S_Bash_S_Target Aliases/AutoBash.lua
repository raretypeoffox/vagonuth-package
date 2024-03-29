-- Alias: AutoBash
-- Attribute: isActive

-- Pattern: ^(?i)autobash ?(on|off)?

-- Script Code:
local args = matches[2] or nil

if not args or args == "" then
  showCmdSyntax("AutoBash\n\tSyntax: autobash (on|off)", {{"autobash (on|off)", "attempts to bash enemies whenever they are standing"}})
  return
end

args = string.lower(args)

if args == "on" then
    GlobalVar.AutoBash = true
else
    GlobalVar.AutoBash = false
end

printMessage("AutoBash", "Set to " .. (GlobalVar.AutoBash and "ON" or "OFF"))
if (GlobalVar.GUI) then AutoBashSetGUI() end