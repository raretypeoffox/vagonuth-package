-- Alias: AutoTarget
-- Attribute: isActive

-- Pattern: ^(?i)autotarget ?(on|off)?

-- Script Code:
local args = (matches[2] or ""):lower()

if args == "on" then
    GlobalVar.AutoTarget = true
elseif args == "off" then
    GlobalVar.AutoTarget = false
    safeKillEventHandler("AutoSlipResetAutoTargetOnMobDeath")
else
  showCmdSyntax("AutoTarget\n\tSyntax: autotarget (on|off)", {
    {"autotarget (on|off)", "Non-casters: targets all the mobs in the room with your killstyle"},
    {"","Casters: autocasts your spell on first mob with 1 second delay"},
    {"","Casters: if killstyle not set to kill, will do killstyle instead"}
  })
  return
end

printMessage("AutoTarget", "Set to " .. (GlobalVar.AutoTarget and "ON" or "OFF"))
