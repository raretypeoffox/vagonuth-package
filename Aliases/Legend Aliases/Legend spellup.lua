-- Alias: Legend spellup
-- Attribute: isActive

-- Pattern: ^spellup$

-- Script Code:
if StatTable.Level ~= 250 then return end

Legend = Legend or {}

if not Legend.SpellUp or not Legend.SpellUp.Run then
  printGameMessage("Legend SpellUp", "Legend.SpellUp is not loaded", "red", "white")
  return
end

Legend.SpellUp.Run()