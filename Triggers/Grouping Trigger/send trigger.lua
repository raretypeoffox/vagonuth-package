-- Trigger: send trigger 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^\*\w+\* tells the group 'send (\w+) (\w+)'$

-- Script Code:
if StatTable.Level < 125 or StatTable.current_mana < 1000 or StatTable.Class == "Berserker" then return end

local wait = 0
local SendTarget = matches[2]
local SendPlane = matches[3]

print(StatTable.Position)
if not (StatTable.Position == "Stand") then return; end

if IsNotClass({"Mage", "Psionicist", "Sorcerer", "Wizard"}) then
  wait = 3
end

safeTempTimer("send trigger", wait, function() send("cast send " .. SendTarget .. " " .. SendPlane); end)


-- You initiate the send ritual!
-- You begin chanting ominously as blue smoke fills the room...
-- [LORD INFO]: Zephyra initiates a Send Ritual for Kaaria to Arcadia.

-- You feel Neilsen's power mingle with yours as he joins the ritual!
-- The send ritual has 2 participants and it requires 1 more to complete.
-- Neilsen adds his voice to the chant! The blue smoke swirls around Kaaria...

-- You feel Shaykh's power mingle with yours as he joins the ritual!
-- Shaykh adds his voice to the chant! The blue smoke envelopes you!

-- Kaaria stands up.
-- Kaaria wavers for a moment, and with a bright flash of green light, is gone!
-- [LORD INFO]: Kaaria has just shifted to Arcadia!
-- [LORD INFO]: Shaykh finishes the Send Ritual, moving Kaaria.
