-- Trigger: PowerState Show 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^\w+ Legend \w+\s*\( \d+\)    \w+    ?(.*)$

-- Script Code:
local PowerStateLookup = {
    ["the Dagger of the Three Fates"] = "2x Random",
    ["the Shatterer of Hopes"] = "SP +10% / DR +20 / -3 wis",
    ["the Sword of Battle"] = "AC -220 (-45)",
    ["the Skewer of Sublime Supremecy"] = "HP/Mana Regen +15%",
    ["the Monolith"] = "AC -220 (-45)",

    ["the Righteous Orb of the Sage"] = "Spell Duration +15%",
    ["the Tree of Life"] = "Heal Power + 15%",
    ["the Will o' the Wisp"] = "AC -200 OR HR/DR +30",
    ["the Scales of Destiny"] = "HP/Mana (Flat or Regen): +10%",
    ["the Resplendent Light of the Ancients"] = "Mana +7.5%",

    ["the Blade of Victory"] = "Xp +15%, -5 int",
    ["the Terminus of Tranquility"] = "Heal Power +15% OR DR +15",
    ["the Eye of the Storm"] = "HR/DR +30",
    ["the Ribbon of Valor"] = "HP/Mana +10%",
    ["the Infinity Cube"] = "XP +10%",
}






cecho (string.rep (" ",75-tonumber(string.len(line))) .. "<yellow> [" .. PowerStateLookup[matches[2]] .. "]")