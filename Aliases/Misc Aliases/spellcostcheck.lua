-- Alias: spellcostcheck
-- Attribute: isActive

-- Pattern: ^spellcostcheck$

-- Script Code:
print("Spell Cost Reductions for your character")
print("----------------------------------------")

print("Arcane  (foci): (" .. 100-GetSpellCostMod("arcane")*100 .. "%)" .. "\tbase: 400 / you: " .. 400*GetSpellCostMod("arcane") )
print("Divine  (awen): (" .. 100-GetSpellCostMod("divine")*100 .. "%)" .. "\tbase: 500 / you: " .. 500*GetSpellCostMod("divine") )
print("Psionic (fort): (" .. 100-GetSpellCostMod("psionic")*100 .. "%)" .. "\tbase: 400 / you: " .. 400*GetSpellCostMod("psionic") )
send("spell foci" .. cs .. "spell awen" .. cs .. "spell fort",false)
