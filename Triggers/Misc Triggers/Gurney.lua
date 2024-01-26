-- Trigger: Gurney 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(\w+)'s Gurney has moved you to your corpse!
-- 1 (start of line): Your corpse appears in a burst of blue light!

-- Script Code:
if (StatTable.Position == "Sleep" or StatTable.Position == "Rest") then send("stand") end
send("get all " .. StatTable.CharName)
TryLook()
send("wear all")

if matches[1] == "Your corpse appears in a burst of blue light!" then send("train") end
