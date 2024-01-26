-- Alias: silent mode
-- Attribute: isActive

-- Pattern: ^(?i)silent ?(on|off)?$

-- Script Code:
if matches[2] == nil or matches[2] == "" then
  print("silent (on|off) -- turns on or off silent mode (minimal gtell / emotes)")
elseif string.lower(matches[2]) == "on" then
  print("silent mode on")
  GlobalVar.Silent = true
  SaveProfileVars()
elseif string.lower(matches[2]) == "off" then
  print("silent mode off")
  GlobalVar.Silent = false
  SaveProfileVars()
end