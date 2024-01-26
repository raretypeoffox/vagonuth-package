-- Alias: Autotrack
-- Attribute: isActive

-- Pattern: ^(?i)autotrack\s*(\w*)

-- Script Code:
local function syntax()
  print("Auotrack:  will automove or report to the group tracking results")
  print("syntax: autotrack [on|off|echo]")
  print("")
  print("autotrack on - will automove to find your target")
  print("autotrack kill - will automove to find your target then attack it")
  print("autotrack echo - will report to group your target")
  print("autotrack off - turns off the either option above")
  print("autotrack show - shows current stats")
end

if (matches[2] == "") then
  syntax()
else
  matches[2] = string.lower(matches[2])
  if (matches[2] == "on" or matches[2] == "echo" or matches[2] == "off" or matches[2] == "kill") then
    print("AutoTrack " .. matches[2])
    GlobalVar.AutoTrack = matches[2]
  
  elseif matches[2] == "show" then
    print("Auotrack " .. GlobalVar.AutoTrack)
  else
    syntax()
  end
end