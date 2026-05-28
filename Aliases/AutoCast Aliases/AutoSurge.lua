-- Alias: AutoSurge
-- Attribute: isActive

-- Pattern: ^(?i)(autosurge|asurge)(?: (on|off))?$

-- Script Code:
local args = matches[3] and string.lower(matches[3]) or ""

if args == "on" then
  GlobalVar.AutoSurgeLevel = true
  printGameMessage("AutoSurge", "Auto surge turned on")
elseif args == "off" then
  GlobalVar.AutoSurgeLevel = false
  printGameMessage("AutoSurge", "Auto surge turned off")
else
  printGameMessage("AutoSurge", "Auto surge is " .. (GlobalVar.AutoSurgeLevel and "ON" or "OFF"))
end

SaveProfileVars()
AutoCastStatus()