-- Alias: spellcostcomp
-- Attribute: isActive

-- Pattern: ^spellcostcomp (.*)$

-- Script Code:
local race = matches[2]

local effectivemana = StatTable.max_mana

effectivemana = (effectivemana / GetSpellCostModRacial(StatTable.Race, "arcane"))
effectivemana = (effectivemana * GetSpellCostModRacial(race, "arcane"))
effectivemana = math.floor(effectivemana)


print("Your equivalent effective arcane mana for a " .. race .. " is " .. format_int(effectivemana))

local effectivemana = StatTable.max_mana
effectivemana = (effectivemana / GetSpellCostModRacial(StatTable.Race, "divine"))
effectivemana = (effectivemana * GetSpellCostModRacial(race, "divine"))
effectivemana = math.floor(effectivemana)

print("Your equivalent effective divine mana for a " .. race .. " is " .. format_int(effectivemana))

local effectivemana = StatTable.max_mana
effectivemana = (effectivemana / GetSpellCostModRacial(StatTable.Race, "psionic"))
effectivemana = (effectivemana * GetSpellCostModRacial(race, "psionic"))
effectivemana = math.floor(effectivemana)

print("Your equivalent effective psionic mana for a " .. race .. " is " .. format_int(effectivemana))


