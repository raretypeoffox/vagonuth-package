-- Alias: AutoTarget
-- Attribute: isActive

-- Pattern: ^(?i)(autotarget|at)(?:\s+(on|off|delay|hp)(?:\s+(\d+(?:\.\d+)?))?)?$

-- Script Code:
local args = (matches[3] or ""):lower()
local value = tonumber(matches[4])

AutoTargetCastDelay = AutoTargetCastDelay or 1
AutoTargetMinHPPct = AutoTargetMinHPPct or 0.5

if args == "on" then
    GlobalVar.AutoTarget = true
elseif args == "off" then
    GlobalVar.AutoTarget = false
    safeKillEventHandler("AutoSlipResetAutoTargetOnMobDeath")
elseif args == "delay" then
  if not value or value < 0 or value > 5 then
    printMessage("AutoTarget error", "Delay must be a number between 0 and 5.")
    return
  end
  AutoTargetCastDelay = value
  printMessage("AutoTarget", "Cast delay set to " .. AutoTargetCastDelay .. " seconds")
  return
elseif args == "hp" then
  if not value or value < 0 or value > 100 then
    printMessage("AutoTarget error", "HP must be a number between 0 and 100.")
    return
  end
  AutoTargetMinHPPct = value / 100
  printMessage("AutoTarget", "Minimum HP set to " .. value .. "%")
  return
else
  showCmdSyntax("AutoTarget\n\tSyntax: autotarget (on|off|delay <#>|hp <#>)", {
    {"autotarget (on|off)", "Non-casters: targets all the mobs in the room with your killstyle"},
    {"autotarget delay <#>", "Caster delay before attacking, from 0 to 5 seconds [default: 1]"},
    {"autotarget hp <#>", "Minimum HP percent needed before targeting, from 0 to 100 [default: 50]"},
    {"","Current status: " .. (GlobalVar.AutoTarget and "ON" or "OFF")},
    {"","Current caster delay: " .. AutoTargetCastDelay .. " seconds"},
    {"","Current minimum HP: " .. (AutoTargetMinHPPct * 100) .. "%"},
    {"","Casters: autocasts your spell on first mob with the configured delay"},
    {"","Casters: if killstyle not set to kill, will do killstyle instead"}
  })
  return
end

printMessage("AutoTarget", "Set to " .. (GlobalVar.AutoTarget and "ON" or "OFF"))
if (GlobalVar.GUI) then AutoTargetSetGUI() end
