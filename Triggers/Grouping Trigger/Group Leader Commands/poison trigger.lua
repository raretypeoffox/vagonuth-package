if StatTable.current_mana < 1000 then printGameMessage("GroupLeader Command", "ignored poison request, low mana") return end

local poi_target = ""
if multimatches[2][2] and multimatches[2][2] ~= "it" then
 poi_target = " " .. multimatches[2][2]
end

TryAction("quicken 9" .. getCommandSeparator() .. "cast poison" .. poi_target .. getCommandSeparator() .. "quicken off", 5)


--printGameMessage("Debug", "quicken 9" .. getCommandSeparator() .. "cast poison" .. poi_target .. getCommandSeparator() .. "quicken off")

