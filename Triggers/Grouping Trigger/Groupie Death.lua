-- Trigger: Groupie Death 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^\[DEATH INFO\]: (?<charname>\w+) killed by (?<mobname>.*) in (?<room>.*) \((\d+)\)\.$

-- Script Code:
-- [DEATH INFO]: Yennefer killed by Chloroform in Ponderous Flowers (18423).

local DeadPlayer = matches.charname

-- Not our groupmate, return

if not GlobalVar.GroupMates[GMCP_name(DeadPlayer)] or GMCP_name(DeadPlayer) == StatTable.CharName then return end

-- Provide a game message
printGameMessage("Death!", DeadPlayer .. "<ansi_white> killed by " .. matches.mobname .. " in " .. matches.room .. ".", "red", "yellow")

-- If we are a Lord and have gurney available, try to gurney groupmate on plane
if StatTable.Level < 125 or StatTable.Class == "Sorcerer" or StatTable.Class == "Berserker" or StatTable.Class == "Shadowfist" then return end

GurneyTriggerHandle = GurneyTriggerHandle or {}
GurneyTriggerHandle[DeadPlayer] = GurneyTriggerHandle[DeadPlayer] or nil

if GurneyTriggerHandle[DeadPlayer] then
  killTrigger(GurneyTriggerHandle[DeadPlayer])
end

local regex_pattern = string.format("^\\[LORD INFO\\]: %s has just shifted to (.*)!", DeadPlayer)

printGameMessage("AutoGurney", DeadPlayer .. " added to autogurney")
GurneyTriggerHandle[DeadPlayer] = tempRegexTrigger(regex_pattern, function()
  if SafeArea() then return end 
  if StatTable.Position == "Stand" then send("cast gurney " .. DeadPlayer) end
  
end, 1)

function ClearGurneyTriggers()
  if not GurneyTriggerHandle then return end
  
  for Index,TriggerID in pairs(GurneyTriggerHandle) do
    killTrigger(TriggerID)
    GurneyTriggerHandle[Index] = nil
  end
end



