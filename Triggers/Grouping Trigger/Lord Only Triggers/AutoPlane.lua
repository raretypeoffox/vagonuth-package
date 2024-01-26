-- Trigger: AutoPlane 
-- Attribute: isActive
-- Attribute: isMultiline


-- Trigger Patterns:
-- 0 (regex): ^(?<player>\w+) wavers for a moment,? and with a bright flash of green light,? is gone!$
-- 1 (regex): ^\[LORD INFO\]: (?<player>\w+) has just (shifted|returned) to (The |the )?(?<plane>.*)!$

-- Script Code:
local plane = multimatches[2].plane
if plane == "WaterRealm" then plane = "water" end
if plane == "EarthRealm" then plane = "earth" end
if plane == "Astral Plane" then plane = "astral" end
if plane == "Planar Anchor" then plane = "anchor" end
if plane == "Kzinti Homeworld" then plane = "kzinti" end



if GlobalVar.GroupLeader == GMCP_name(multimatches[2].player) and plane == "Thorngate" then
  printGameMessageVerbose("AutoPlane", "Leader planed to thorngate, following")
  send("cast plane thorn")
  local tempTriggerID = tempBeginOfLineTrigger("You failed your planeshift due to lack of concentration!", function() send("cast plane thorn") end)
  tempBeginOfLineTrigger("You form a magical vortex and step into it...", function() killTrigger(tempTriggerID) end, 1) 
  
elseif GlobalVar.GroupLeader == GMCP_name(multimatches[2].player) and StatTable.Foci then
  -- Leader was in the room and has just plane shifted and we are spelled
  if plane == "Midgaardia" then
    printGameMessage("Beep!", "Leader planed to Midgaardia, NOT following")
    beep()
    return
  end
  
  -- Waits 8 seconds less 1 second for each 10k of hp, to a minimum of 1 (i.e. small sprite = 8 seconds, big warrior = 1 second)
  local wait = math.max(8-math.floor(StatTable.current_health/10000),1)

  printGameMessageVerbose("AutoPlane", "Leader planed, following in " .. wait .. " seconds")
  
  local tempTriggerID = tempBeginOfLineTrigger("You failed your planeshift due to lack of concentration!", function() send("cast plane " .. plane) end)
  tempBeginOfLineTrigger("You form a magical vortex and step into it...", function() killTrigger(tempTriggerID) end, 1)
  
  tempTimer(wait, function() send("cast plane " .. plane) end)
  safeTempTrigger("OutOfPlaneLag", "You form a magical vortex and step into it...", [[send("emote is |W|out of plane lag|N|")]], "begin", 1)
  
end


