-- Alias: KillStyle
-- Attribute: isActive

-- Pattern: ^(?i)killstyle ?(.*)?$

-- Script Code:
args = matches[2] or nil

if not args or args == "" then
  showCmdSyntax("KillStyle\n\tSyntax: killstyle <style>", {{"autokill (on|off)", "whether to attack with killstyle (see below) on leader emote"},{"killstyle <style>", "what autokill style to attack with (e.g. kill, bash, backstab)"},})
  return
end

args = string.lower(args)
  
GlobalVar.KillStyle = args
printMessage("KillStyle", "trigger is set to " .. args)
print("AutoKill is " .. (GlobalVar.AutoKill and "ON" or "OFF"))
if (GlobalVar.GUI) then AutoKillSetGUI() end