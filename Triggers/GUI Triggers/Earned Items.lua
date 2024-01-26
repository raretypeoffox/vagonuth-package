-- Trigger: Earned Items 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^You have earned an item! \((.*)\)

-- Script Code:
if (matches[2] ~= "a hellbreach amulet") then
  --cecho("GroupChat", "<yellow><b>You have earned an item! (" .. matches[2] .. ")</b>\n")
  printGameMessage("AutoLoot!", "You received: " .. matches[2], "yellow", "white")
  QuickBeep()
end

--You have earned an item! (black staff of Typhus) 

