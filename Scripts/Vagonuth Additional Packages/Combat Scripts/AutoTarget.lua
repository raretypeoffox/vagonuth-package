-- Script: AutoTarget
-- Attribute: isActive
-- AutoTarget() called on the following events:
-- gmcp.Room.Players

-- Script Code:
GlobalVar.AutoTarget = GlobalVar.AutoTarget or false
GlobalVar.AutoTargetEmote = GlobalVar.AutoTargetEmote or false

local TargetExclusions = {

--Arcanist Nascents
"This small pool of acid licks at the rock hungrily.",
"Flickering and leaping, these flames look around for more fuel.",
"This rock moves of its own will, hither and yon.",
"A tiny spark zaps from one crystal to the next, building its charge.",
"This breeze twirls about playfully.",
"This clump of snowflakes drifts silently about.",
"This rivulet of water trickles across the ground, gathering droplets.",

-- Companions
"Scanning the surrounding area for trouble, Besaur waits nearby.",
"Nalfar tests the weight of his weapon, shuffling it from hand to hand.",
"With a grim smile, Teli idly waits to jump into the fray.",

-- Immo Mobs
"This Githyanki coughs, blood bubbling up through his open mouth.",
"A dying Githzerai crawls, dragging his useless legs behind him.",
"Unsure on his feet, this young Githzerai tries to stay out of the way.",
"A small fiend crawls through the blood.",
"A former Lord of Midgaardia serves the Fae.",
"Red particles swirl together in a fierce cluster.",
"A dark cloud of diminishing hate struggles to keep itself together.",
"This demon is emaciated with elongated limbs.",
"A mound of topaz starts to move listlessly.",
"Back from the dead, this Githzerai stumbles to his feet.",

-- NPCS
"Resting on the throne, Bestellen contemplates a white cube in his hand.",
"This ent places a handful of gold coins on his weighing scale.",
"The shadowy fog has formed a maelstrom of darkness.", -- shadowlands, dje
"A tall sentry stands here blocking your entrance.", -- darker castle


-- Special
"Something interesting is here",

-- Chaos
"The Chaotic Abyss controls everything else.",

-- Garden
"The servant of the Six glares at you and deems you unpure!",

-- Vault
"A wraithlike devil looks quite bored.",

-- Astral
"A githzerai plots his escape plan.",

-- Astral Invasion
"A Fae Cleric rolls his eyes at you, and casts a protection spell on himself.",
"Flames dance playfully upon the back of some poor soul.",





}

AutoTargetCastDelay = AutoTargetCastDelay or 1

function AutoTarget()
  if not GlobalVar.AutoTarget or Battle.Combat or SafeArea() then return end
  
  for _,mob in pairs(gmcp.Room.Players) do
    if(tonumber(mob.name) ~= nil and ArrayHasSubstring(TargetExclusions, mob.fullname) == false) then
      
      --if GroupLeader() then send("emote is killing " .. mob.name) end
      
      -- We're now ready to autotarget the mob. This first bit is for casters.
      if (GlobalVar.AutoCast and (GlobalVar.KillStyle == "kill" or not GlobalVar.AutoKill)) then
        if tonumber(gmcp.Char.Vitals.lag) > 0 then return end
        
        local cast_action = "cast '" .. GlobalVar.AutoCaster .. "' " .. mob.name
        
        if GlobalVar.SurgeLevel > 1 and StatTable.current_mana > 8000 then 
          cast_action = "surge " .. GlobalVar.SurgeLevel .. getCommandSeparator() .. cast_action .. getCommandSeparator() .. "surge off"
        end
        -- delay cast by AutoTargetCastDelay seconds to give tanks/stabbers a chance first
        tempTimer(AutoTargetCastDelay,function() send(cast_action) end)
        break
      else
        send(GlobalVar.KillStyle .. " " .. mob.name)
        if GlobalVar.KillStyle == "ass" or GlobalVar.KillStyle == "bs" then
          tempTimer(0, function() send("surp " .. mob.name) end)
        end
        if GlobalVar.AutoTargetEmote then send("emote is killing " .. mob.name) end
        if GroupLeader() then break end
      end
      
    end
  end
end


function AutoSlip(dir, target)
  local weapon_keyword = "long bow deep shadow"
  
  -- Initial checks, make sure we are a stabber and we have alert/sneak up
  if IsNotClass({"Rogue", "Assassin"}) then
    printMessage("AutoSlip", "Error, only Rogues and Assassins can slip")
    return
  end

  if not StatTable.Alertness then
    printMessage("AutoSlip", "Alertness not up, attempting alertness now")
    send("alertness")
  end

  if not StatTable.Sneak then
    printMessage("AutoSlip", "Sneak not up, attempting sneak now")
    send("sneak")
  end

  -- if no direction is provided, we will move back in the last direction we came from
  if not dir then
    if #GlobalVar.LastDirs >= 1 then
      dir = ReverseDir(GlobalVar.LastDirs[#GlobalVar.LastDirs])
    else
      printMessage("AutoSlip Erro", "No last direction available")
      return
    end
  end

  if not dir then
    printMessage("AutoSlip Error", "No direction specified")
    return
  end
  
  -- if no target is provided, we'll pick a random mob that's not on the exclusion list
  if not target then
    -- no target specified by player, find one
    for _,mob in pairs(gmcp.Room.Players) do
      if(tonumber(mob.name) ~= nil and ArrayHasSubstring(TargetExclusions, mob.fullname) == false) then
        target = tonumber(mob.name)
        --break
      end
    end      
  end
  
  if not target then
    printMessage("AutoSlip", "No target found")
    return
  end
   
  if GlobalVar.AutoTarget then
    GlobalVar.AutoTarget = false
    safeEventHandler("AutoSlipResetAutoTargetOnMobDeath", "OnMobDeath", function() GlobalVar.AutoTarget = true; end, true)
  end
  
  if not (StatTable.Enemy == nil or StatTable.Enemy == "") then 
    if StatTable.Class == "Rogue" and StatTable.SubLevel >= 25 then
      send("disengage " .. dir)
    else
      printMessage("AutoSlip", "In combat, can't slip")
      return
    end
  else
    send(dir)
  end
  
  send("remove '" .. weapon_keyword .. "'")
  send("slip " .. ReverseDir(dir) .. " " .. target)
  send("wield '" .. weapon_keyword .. "'")
  send("assassinate " .. target)

end

