-- Alias: spellcosttranslate
-- Attribute: isActive

-- Pattern: ^spellcosttrans (\d+) (.*)$

-- Script Code:
local race = matches[3]
local manacomp = tonumber(matches[2])

manacomp = (manacomp / GetSpellCostModRacial(race, "arcane"))
manacomp = (manacomp * GetSpellCostModRacial(StatTable.Race, "arcane"))
manacomp = math.floor(manacomp)

print("A " .. race .. " with " .. format_int(tonumber(matches[2])) .. " mana is equivalent to you having " .. format_int(manacomp) .. " mana")


