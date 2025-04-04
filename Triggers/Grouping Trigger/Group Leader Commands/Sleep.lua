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
  if not (StatTable.Level == 125 and StatTable.Class == "Bladedancer" and StatTable.current_mana > 2000 and not SafeArea() and BldDancing()) then 
   send("sleep",false)
  else
    if StatTable.Bladetrance then
      send("bladetrance break")
    end
    if not IsMDAY() then
      QuickBeep()
      printGameMessage("QuickBeep", "BLD didn't sleep, still dancing", "yellow", "white")
    end 
  end
end



