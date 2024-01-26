-- Alias: SkillStyle
-- Attribute: isActive

-- Pattern: ^(?i)skillstyle ?(.*)?$

-- Script Code:
args = matches[2] or nil

if not args or args == "" then
  showCmdSyntax("SkillStyle\n\tSyntax: skillstyle <style>", {{"autoskill (on|off)", "whether to attack with skillstyle during battle"},{"skillstyle <style>", "what autoskill style to use in battle (eg smash)"},})
  return
end

args = string.lower(args)
  
GlobalVar.SkillStyle = args
printMessage("SkillStyle", "trigger is set to " .. args)
print("AutoSkill is " .. (GlobalVar.AutoSkill and "ON" or "OFF"))
if (GlobalVar.GUI) then AutoSkillSetGUI() end