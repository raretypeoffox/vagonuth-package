-- Alias: spellcostcheck
-- Attribute: isActive

-- Pattern: ^spellcostcheck$

-- Script Code:
print("foci: " .. 400*GetSpellCostMod("arcane") .. " (" .. 100-GetSpellCostMod("arcane")*100 .. "%)")
send("spell foci",false)
print("awen: " .. 500*GetSpellCostMod("divine") .. " (" .. 100-GetSpellCostMod("divine")*100 .. "%)")
send("spell awen",false)
print("fort: " .. 400*GetSpellCostMod("psionic") .. " (" .. 100-GetSpellCostMod("psionic")*100 .. "%)")
send("spell fort",false)
