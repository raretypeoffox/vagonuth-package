-- Trigger: Sleep 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (exact): bld sleep

-- Script Code:
if StatTable.Class ~= "Bladedancer" then return end

if (SafeArea() and (StatTable.Sneak or StatTable.MoveHidden)) then
  send("visible",false)
end

if StatTable.Savespell == nil or StatTable.Savespell then send("config -savespell",false); StatTable.Savespell = false end

if (StatTable.Position ~= "Sleep") then
   send("sleep",false)
end


