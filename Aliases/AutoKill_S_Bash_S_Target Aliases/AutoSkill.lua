-- Alias: AutoSkill
-- Attribute: isActive

-- Pattern: ^(?i)autoskill ?(on|off)?

-- Script Code:
local args = matches[2] or nil

if not args or args == "" then
  showCmdSyntax("AutoSkill\n\tSyntax: autoskill (on|off)", {{"autoskill (on|off)", "whether to attack with skillstyle during battle"},{"skillstyle <style>", "what autoskill style to use in battle (eg smash)"},})
  return
end

args = string.lower(args)

if args == "on" then
  if not GlobalVar.SkillStyle or GlobalVar.SkillStyle == "" then
    printMessage("AutoSkill Error", "set skillstyle first - usage: skillstyle <skill>")
    return  
  end
  GlobalVar.AutoSkill = true
else
  GlobalVar.AutoSkill = false
end

printMessage("AutoSkill", "Set to " .. (GlobalVar.AutoSkill and "ON" or "OFF"))
printMessage("AutoSkill", "Current trigger skillstyle is " .. GlobalVar.SkillStyle .. " - change with skillstyle <style>")
if (GlobalVar.GUI) then AutoSkillSetGUI() end