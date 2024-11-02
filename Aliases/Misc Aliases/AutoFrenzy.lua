-- Alias: AutoFrenzy
-- Attribute: isActive

-- Pattern: ^(?i)autofrenzy ?(on|off)?

-- Script Code:
local args = (matches[2] or ""):lower()

if args == "on" then
    GlobalVar.AutoFrenzy = true
elseif args == "off" then
    GlobalVar.AutoFrenzy = false
else
  showCmdSyntax("AutoFrenzy\n\tSyntax: autofrenzy (on|off)", {{"autofrenzy (on|off)", "autocasts frenzy when its down"},})
  return
end

printMessage("AutoFrenzy", "Set to " .. (GlobalVar.AutoFrenzy and "ON" or "OFF"))


