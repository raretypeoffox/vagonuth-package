-- Trigger: Gravitas mob - bugged 


-- Trigger Patterns:
-- 0 (regex): ^(.*) surrounds \w+ with a telekinetic sink.$

-- Script Code:
if IsGroupMate(matches[2]) then return; end -- just a group mate casting gravitas

GlobalVar.UnequippedLight = GlobalVar.UnequippedLight or nil

-- script is really designed for one mob casting gravitas at a time. Will only run once every 30 seconds
if not TryLock("OnMobGravitas", 30) then
  printGameMessage("Psi", "Telekinetic sink alert! " .. matches[2] .. "(second in 30 seconds!!)") 
  return
end

-- Mob has casted gravitas, alert user and swap to mind wipe
printGameMessage("Psi", "Telekinetic sink alert! " .. matches[2] .. " (swapped to mindwipe, attempting dart)", "red", "white")
AutoCastSetSpell("mindwipe")

-- check if we have any mindtricks (magic lights) in our inventory
if GlobalVar.Mindtricks > 0 then

  -- track the light we unequip so we can reequip it after dart
  -- if we can't get the keywords, we'll just ask the user to reequip it
  safeTempTrigger("Gravitas.light_unequip", "You stop using (.*).", function()
    GlobalVar.UnequippedLight = safeCall(getAllegKeyword, matches[2]) -- requires vago inventory package
    
    if GlobalVar.UnequippedLight then
      printGameMessage("Psi", "Unequipped " .. matches[2] .. ", will attempt to reequip after dart", "yellow", "white")
    else
      printGameMessage("Psi", "Unequipped " .. matches[2] .. ", please reequip after dart", "yellow", "red")
    end  
  end, "regex", 1)
  
  -- check to see if mindtrick gets equipped, if so, start autocasting dart
  safeTempTrigger("Gravitas.wear_mindtrick", "You light " .. gmcp.Char.Status.character_name .. "'s glowing mindtrick and hold it.", function() 
    
    printGameMessage("Psi", "Equipped mindtrick - autocasting dart!", "yellow", "white")
    AutoCastSetSpell("dart") 
    
    -- we may need to dart multiple times (ie if a different mob than we're currently targetting is the one with gravitas)
    safeTempTrigger("Gravitas.dart_weapon", "You Dart " .. gmcp.Char.Status.character_name .. "'s glowing mindtrick at", function()
      tempTimer(0, function() if GlobalVar.AutoCaster == "dart" then send("get mindtrick"); send("wear mindtrick") end; end)
    end, "begin")
    
    -- mob has grabbed our mindtrick, it workeD! We can stop autocasting dart and reequip our light
    safeTempTrigger("Gravitas.mob_gravitas_down", gmcp.Char.Status.character_name .. "'s glowing mindtrick is captured! It floats into (.*)'s hands!", function()
      printGameMessage("Psi", "Mindtrick captured, mob gravitas is down!", "yellow", "white")
      AutoCastSetSpell("fandango")
      if GlobalVar.UnequippedLight then
        send("wear '" .. GlobalVar.UnequippedLight .. "'")
      else
        printGameMessage("Psi", "Please reequip your light!", "red", "white")
      end
      safeKillTrigger("Gravitas.dart_weapon")

    end, "regex", 1) -- end of mob_gravitas_down trigger
  end, "begin", 1) -- end of wear_mindtrick trigger
  
  send("wear mindtrick")
  
else
  -- we have no mindtricks, just cast mindwipe for the next 30 seconds
  printGameMessage("Psi", "No mindtricks found in inventory, will swap to fandango in 30 seconds", "yellow", "white")
  safeTempTimer("Gravitas.backup", 30, function() AutoCastSetSpell("fandango") end)
end