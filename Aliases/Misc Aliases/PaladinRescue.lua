-- Alias: PaladinRescue
-- Attribute: isActive

-- Pattern: ^(?i)palrescue ?(on|off)?

-- Script Code:
local args = (matches[2] or ""):lower()

if args == "on" then
    GlobalVar.PaladinRescue = true
elseif args == "off" then
    GlobalVar.PaladinRescue = false
else
  showCmdSyntax("Paladin Rescue\n\tSyntax: palrescue (on|off)", {
    {"palrescue (on|off)", "Will attempt to rescue group mates to trigger boons"},

  })
  return
end

printMessage("PaladinRescue", "Set to " .. (GlobalVar.PaladinRescue and "ON" or "OFF"))
