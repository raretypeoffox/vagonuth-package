-- Trigger: Sleep 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (exact): sleep

-- Script Code:
if (SafeArea() and (StatTable.Sneak or StatTable.MoveHidden)) then
  send("visible",false)
end

if StatTable.Savespell == nil or StatTable.Savespell then send("config -savespell",false); StatTable.Savespell = false end

if (StatTable.Position ~= "Sleep") then
  if not (StatTable.Level == 125 and StatTable.Class == "Bladedancer" and StatTable.current_mana > 2000 and not SafeArea()) then 
   send("sleep",false) 
  elseif StatTable.Bladetrance then
   send("bladetrance break")
  end
end

if StatTable.Class == "Bladedancer" then send("sleep") end


