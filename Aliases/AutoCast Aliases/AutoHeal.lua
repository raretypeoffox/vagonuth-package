-- Alias: AutoHeal
-- Attribute: isActive

-- Pattern: ^(?i)(autoheal|ah)(?: (.*))?$

-- Script Code:
local function AutoHealStatus()
  cecho("<dodger_blue>AutoHeal is currently " .. (GlobalVar.AutoHeal and "<green>ON" or "<red>OFF") .. "</b> \n")
  cecho("<dodger_blue>AutoHeal target set to <yellow>" .. (GlobalVar.AutoHealLowest and "lowest HP %" or GlobalVar.AutoHealTarget) .. "\n")
end

args = matches[3] or ""
args = string.lower(args)

if (args == "on") then
  GlobalVar.AutoHeal = true
  AutoHealStatus()
  
elseif (args == "off") then
  GlobalVar.AutoHeal = false
  AutoHealStatus()
  
elseif (args == "") then
  print("AutoHeal - automatically heals during combat (only for divinity/comfort)")
  print("Synax: AutoHeal (on|off|<target>|lowest)")
  print("Use AutoHeal <target> to set heal target")
  print("Use AutoHeal lowest to automatically heal the groupies with the lowest hp % (default)")
  print("The target can be changed even when AutoHeal is off")
  print("--------------------------------------------------")
  AutoHealStatus()

else
  if args == "lowest" then
    GlobalVar.AutoHealLowest = true
  else
  
    if (GlobalVar.GroupMates[GMCP_name(args)] == nil) then
      cecho("<red>AutoHeal Error:<yellow> " .. GMCP_name(args) .. "<white> not in the group")
      return
    end
    GlobalVar.AutoHealLowest = false
    GlobalVar.AutoHealTarget = GMCP_name(args)
  end
    AutoHealStatus()
  
end

-- old: ^(?i)autoheal\s*(.*)