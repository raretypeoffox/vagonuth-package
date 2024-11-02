-- Trigger: poison trigger 
-- Attribute: isActive
-- Attribute: isMultiline


-- Trigger Patterns:
-- 0 (lua function): return (StatTable.Class == "Sorcerer" and StatTable.Level == 125)
-- 1 (regex): ^pois?o?n? ?(\w+)?

-- Script Code:
if StatTable.current_mana < 1000 then printGameMessage("GroupLeader Command", "ignored poison request, low mana") return end

local poi_target = ""
if multimatches[2][2] and multimatches[2][2] ~= "it" then
 poi_target = " " .. multimatches[2][2]
end

TryAction("quicken 9" .. getCommandSeparator() .. "cast poison" .. poi_target .. getCommandSeparator() .. "quicken off", 5)


--printGameMessage("Debug", "quicken 9" .. getCommandSeparator() .. "cast poison" .. poi_target .. getCommandSeparator() .. "quicken off")

