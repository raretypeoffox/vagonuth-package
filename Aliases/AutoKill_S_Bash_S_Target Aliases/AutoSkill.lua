-- Alias: AutoSkill
-- Attribute: isActive

-- Pattern: ^(?i)(autoskill|as)(?: (.*))?$

-- Script Code:
local args = matches[3] or ""

if not args or args == "" then
  showCmdSyntax("AutoSkill\n\tSyntax: autoskill (on|off|<skill>)", {{"autoskill (on|off|<skill>)", "whether to auto use <skill> during battle, turn on / off"}})
  return
end

if args == "on" then
  if not GlobalVar.SkillStyle or GlobalVar.SkillStyle == "" then
    printMessage("AutoSkill Error", "set skillstyle first - usage: skillstyle <skill>")
    return  
  end
  GlobalVar.AutoSkill = true
elseif args == "off" then
  GlobalVar.AutoSkill = false
else
  GlobalVar.SkillStyle = args
end

printMessage("AutoSkill", "Set to " .. (GlobalVar.AutoSkill and "ON" or "OFF"))
printMessage("AutoSkill", "Current trigger skillstyle is " .. GlobalVar.SkillStyle .. " - change with autoskill <skill>")
if (GlobalVar.GUI) then AutoSkillSetGUI() end