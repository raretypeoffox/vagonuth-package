-- Trigger: Salv Help 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^\[LORD INFO\]: \w+ starts a Salvation rite for (?<target>\w+) in (?<room>.*).$

-- Script Code:
SalvTarget = matches.target

-- Only triggers if we're in the same room
if gmcp.Room.Info.name ~= matches.room then return; end

-- Only triggers if we are a class that can cast salv
if IsClass({"Berserker", "Assassin", "Black Circle Initiate", "Shadowfist"}) then return; end

-- Only triggers if we're not in lag
if tonumber(gmcp.Char.Vitals.lag) > 0 then return; end

-- Only triggers if we're awake
if not (StatTable.Position == "Stand") then return; end

-- Keep track of # of salv participants. You'll attempt to salv in a random time between 0 and 1 seconds
NumberOfSalvParticipants = 1
SalvTimer = (math.floor((math.random()) * 100) / 100)

-- Add 1 to NumberofSalvParticipants each time a player casts
-- TODO: if someone fail salvation, this trigger would still count it.
-- TODO: grab the trigger text for a successful salvation and use that text instead
safeTempTrigger("NumOfSalvTrigger", "utters the words, 'salvation'.", function() NumberOfSalvParticipants = NumberOfSalvParticipants + 1; end, "substring", 4)

safeTempTimer("SalvHelpTrigger", SalvTimer, function()
  if NumberOfSalvParticipants < 5 then
    send("cast salvation " .. SalvTarget)
    printGameMessage("Salv Trigger", "Attempting to salv " .. SalvTarget)
  end
  
  -- printGameMessage for debug, remove later
  printGameMessage("Salv Trigger", "Didn't salv " .. SalvTarget .. ", already 5 participants")
  
  safeKillTrigger("NumOfSalvTrigger")
end)



