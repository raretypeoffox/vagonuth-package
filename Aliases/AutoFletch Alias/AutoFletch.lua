-- Alias: AutoFletch
-- Attribute: isActive

-- Pattern: ^autofletch (.*)

-- Script Code:
if matches[2] == "off" or matches[2] == "stop" then
  echo("AutoFletch: turned off\n")
  GlobalVar.AutoFletch = false
else
  GlobalVar.AutoFletch = true
  send("fletch " .. matches[2])
end