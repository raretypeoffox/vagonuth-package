-- Trigger: AutoLotto - can't carry 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(\w+) can't carry that much weight.$

-- Script Code:
local str = line

if AutoLotto.CurrentItemName ~= nil then
  str = matches[2] .. " couldn't carry " .. AutoLotto.CurrentItemName
end

QuickBeep()
printMessage("AutoLotto", str)
printGameMessage("AutoLotto", str, "red", "white")

