-- Trigger: dark embrace 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): You can't take the bright sunlight!

-- Script Code:
if SafeArea() then return end

if not (StatTable.Class == "Beserker" or StatTable.Class == "Priest" or StatTable.Class == "Paladin" or StatTable.Class == "Druid") then
  TryCast("cast 'dark embrace'",5)
else
 if not GlobalVar.Silent then
  TryAction("gtell dark embrace please",300)
 end
end