-- Alias: AutoCast
-- Attribute: isActive

-- Pattern: ^(?i)(autocast|ac)(?: (.*))?$

-- Script Code:

args = matches[3] or ""
args = string.lower(args)

if (args == "on") then
  AutoCastON()  
elseif (args == "off") then
  AutoCastOFF()
  if GlobalVar.AutoTarget then
    GlobalVar.AutoTarget = false
    printGameMessage("AutoTarget", "AutoTarget turned off with AutoCast")
  end
  
  if StatTable.Level == 125 and GlobalVar.SurgeLevel > 1 then
    send("surge " .. GlobalVar.SurgeLevel)
  end  
elseif (args == "") then
  print("AutoCast - automatically casts spell during combat")
  print("Synax: autocast (on|off|spellname)")
  print("Use autocast <spellname> to set up what spell to cast")
  print("The spell can be changed even when autocast is off")
  print("Change the attempted surge level with the command [1-5]")
  print("--------------------------------------------------")
  AutoCastStatus()
else
  AutoCastSetSpell(args)
end

--old: ^(?i)(autocast|ac)\*(.*)