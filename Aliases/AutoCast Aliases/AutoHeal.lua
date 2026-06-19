-- Alias: AutoHeal
-- Attribute: isActive

-- Pattern: ^(?i)(autoheal|ah)(?: (.*))?$

-- Script Code:
GlobalVar.AutoHealExclusionList = GlobalVar.AutoHealExclusionList or {}

local function AutoHealExclusionCount()
  local count = 0
  for _, excluded in pairs(GlobalVar.AutoHealExclusionList or {}) do
    if excluded then count = count + 1 end
  end
  return count
end

local function AutoHealShowExclusions()
  local excluded_names = {}

  for name, excluded in pairs(GlobalVar.AutoHealExclusionList or {}) do
    if excluded then table.insert(excluded_names, name) end
  end

  if #excluded_names == 0 then
    cecho("<dodger_blue>AutoHeal exclusion list is <yellow>empty\n")
    return
  end

  table.sort(excluded_names)
  cecho("<dodger_blue>AutoHeal exclusion list: <yellow>" .. table.concat(excluded_names, ", ") .. "\n")
end

local function AutoHealStatus()
  cecho("<dodger_blue>AutoHeal is currently " .. (GlobalVar.AutoHeal and "<green>ON" or "<red>OFF") .. "</b> \n")
  cecho("<dodger_blue>AutoHeal target set to <yellow>" .. (GlobalVar.AutoHealLowest and "lowest HP %" or GlobalVar.AutoHealTarget) .. "\n")
  cecho("<dodger_blue>AutoHeal exclusions: <yellow>" .. AutoHealExclusionCount() .. "\n")
end

args = matches[3] or ""
args = string.lower(args)
local command, command_args = args:match("^(%S+)%s*(.*)$")
command_args = command_args or ""

if (args == "on") then
  GlobalVar.AutoHeal = true
  AutoHealStatus()
  
elseif (args == "off") then
  GlobalVar.AutoHeal = false
  AutoHealStatus()
  
elseif (args == "") then
  print("AutoHeal - automatically heals during combat (only for divinity/comfort)")
  print("Syntax: AutoHeal (on|off|<target>|lowest)")
  print("Use AutoHeal <target> to set heal target")
  print("Use AutoHeal lowest to automatically heal the groupies with the lowest hp % (default)")
  print("Use AutoHeal exclude <target> to exclude a groupie from automatic healing")
  print("Use AutoHeal include <target> or remove <target> to remove a groupie from the exclusion list")
  print("Use AutoHeal exclusions or show to show the exclusion list")
  print("The target can be changed even when AutoHeal is off")
  print("--------------------------------------------------")
  AutoHealStatus()

elseif command == "exclude" or command == "ex" then
  if command_args == "" then
    cecho("<red>AutoHeal Error:<white> exclude needs a target name\n")
    return
  end

  local exclude_name = GMCP_name(command_args)
  GlobalVar.AutoHealExclusionList[exclude_name] = true
  cecho("<dodger_blue>AutoHeal:<yellow> " .. exclude_name .. "<white> excluded from automatic healing\n")

elseif command == "include" or command == "inc" or command == "remove" or command == "rm" then
  if command_args == "" then
    cecho("<red>AutoHeal Error:<white> " .. command .. " needs a target name\n")
    return
  end

  local include_name = GMCP_name(command_args)
  GlobalVar.AutoHealExclusionList[include_name] = nil
  cecho("<dodger_blue>AutoHeal:<yellow> " .. include_name .. "<white> removed from automatic healing exclusions\n")

elseif command == "exclusions" or command == "excluded" or command == "list" or command == "show" then
  AutoHealShowExclusions()

elseif command == "clear" and (command_args == "exclusions" or command_args == "excluded") then
  GlobalVar.AutoHealExclusionList = {}
  cecho("<dodger_blue>AutoHeal exclusion list cleared\n")

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
