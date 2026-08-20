if (StatTable.Position == "Sleep" or StatTable.Position == "Rest") then send("stand") end
send("get all " .. StatTable.CharName)
TryLook()
send("wear all")

if matches[1] == "Your corpse appears in a burst of blue light!" then send("train") end
