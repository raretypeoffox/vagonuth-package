-- Alias: spellcostcomp
-- Attribute: isActive

-- Pattern: ^spellcostcomp (.*)$

-- Script Code:
local race = matches[2]

local effectivemana = StatTable.max_mana

effectivemana = (effectivemana / GetSpellCostModRacial(StatTable.Race, "arcane"))
effectivemana = (effectivemana * GetSpellCostModRacial(race, "arcane"))
effectivemana = math.floor(effectivemana)


print("The equivalent effective arcane mana for a " .. race .. " is " .. format_int(effectivemana))


