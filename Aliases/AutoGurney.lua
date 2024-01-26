-- Alias: AutoGurney

-- Pattern: ^autogurney\s*(\w*)

-- Script Code:
if (matches[2] == "") then
  showCmdSyntax("AutoGurney\n\tSyntax: autogurney (target)", 
  {
  {"autogurney <target>","automatically gurneys a group mate at shift"},
  {"autogurney","clears previous autogurney target"}
  
  })
  GlobalVar.AutoGurney = ""
elseif (StatTable.Class == "Sorcerer" or StatTable.Class == "Shadowfist" or StatTable.Class == "Berserker") then
  print("AutoGurney: " .. StatTable.Class .. " can't cast gurney!")
else
  GlobalVar.AutoGurney = string.lower(matches[2])
  send("info +lord", false) -- relies on the lord info announcement, turn it on just incase its off
  print("AutoGurney target set to " .. matches[2])
end
  