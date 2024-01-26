-- Script: AutoTarget
-- Attribute: isActive
-- AutoTarget() called on the following events:
-- gmcp.Room.Players

-- Script Code:
GlobalVar.AutoTarget = GlobalVar.AutoTarget or false

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

-- NPCS
"Resting on the throne, Bestellen contemplates a white cube in his hand.",

-- Special
"Something interesting is here",

-- Garden
"The servant of the Six glares at you and deems you unpure!",

-- Vault
"A wraithlike devil looks quite bored.",


}

AutoTargetCastDelay = AutoTargetCastDelay or 1

function AutoTarget()
  if not GlobalVar.AutoTarget or Battle.Combat or SafeArea() then return end
  
  for _,mob in pairs(gmcp.Room.Players) do
    if(tonumber(mob.name) ~= nil and ArrayHasSubstring(TargetExclusions, mob.fullname) == false) then
      
      --if GroupLeader() then send("emote is killing " .. mob.name) end
      
      -- We're now ready to autotarget the mob. This first bit is for casters.
      if (GlobalVar.AutoCast and (GlobalVar.KillStyle == "kill" or not GlobalVar.AutoKill) and tonumber(gmcp.Char.Vitals.lag) == 0) then
        local cast_action = "cast '" .. GlobalVar.AutoCaster .. "' " .. mob.name
        
        if GlobalVar.SurgeLevel > 1 and StatTable.current_mana > 8000 then 
          cast_action = "surge " .. GlobalVar.SurgeLevel .. getCommandSeparator() .. cast_action .. getCommandSeparator() .. "surge off"
        end
        -- delay cast by AutoTargetCastDelay seconds to give tanks/stabbers a chance first
        tempTimer(AutoTargetCastDelay,function() send(cast_action) end)
        break
      else
        send(GlobalVar.KillStyle .. " " .. mob.name)
        if GroupLeader() then break end
      end
      
    end
  end
end

-- previous code


--function AutoTarget()
--  if not GlobalVar.AutoTarget or Battle.Combat or SafeArea() then return end
  
--  for _,mob in pairs(gmcp.Room.Players) do
--    if(tonumber(mob.name) ~= nil and ArrayHasSubstring(TargetExclusions, mob.fullname) == false) then
      -- We're now ready to autotarget the mob. This first bit is for casters.
--      if (GlobalVar.AutoCast and tonumber(gmcp.Char.Vitals.lag) == 0) then
--        local cast_action = "cast '" .. GlobalVar.AutoCaster .. "' " .. mob.name
        
--        if GlobalVar.SurgeLevel > 1 and StatTable.current_mana > 8000 then 
--          cast_action = "surge " .. GlobalVar.SurgeLevel .. getCommandSeparator() .. cast_action .. getCommandSeparator() .. "surge off"
--        end
        -- delay cast by AutoTargetCastDelay seconds to give tanks/stabbers a chance first
--        tempTimer(AutoTargetCastDelay,function() send(cast_action) end)
--      else
--        send(GlobalVar.KillStyle .. " " .. mob.name)
--      end
--      break
--    end
--  end
--end

