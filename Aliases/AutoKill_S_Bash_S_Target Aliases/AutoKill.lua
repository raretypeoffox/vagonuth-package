-- Alias: AutoKill
-- Attribute: isActive

-- Pattern: ^(?i)autokill ?(on|off)?

-- Script Code:
local args = (matches[2] or ""):lower()

if args == "on" then
    GlobalVar.AutoKill = true
elseif args == "off" then
    GlobalVar.AutoKill = false
else
  showCmdSyntax("AutoKill\n\tSyntax: autokill (on|off)", {{"autokill (on|off)", "whether to attack with killstyle (see below) on leader emote"},{"killstyle <style>", "what autokill style to attack with (e.g. kill, bash, backstab)"},})
  return
end

printMessage("AutoKill", "Set to " .. (GlobalVar.AutoKill and "ON" or "OFF"))
printMessage("AutoKill", "Current trigger killstyle is " .. GlobalVar.KillStyle .. " - change with killstyle <style>")
if (GlobalVar.GUI) then AutoKillSetGUI() end