-- Trigger: Shatter Alert 
-- Attribute: isActive
-- Attribute: isColorizerTrigger

-- mFgColor: #ff0000
-- mBgColour: #ffff00

-- Trigger Patterns:
-- 0 (regex): ^Torrents of jagged ice cascade down upon (.*)'s enemies!

-- Script Code:
local shatter_enemy = matches[2]

if IsGroupMate(shatter_enemy) then return end

printGameMessage("Stormlord!!", "Target " .. shatter_enemy, "red", "white")
safeTempTrigger("ShatterAlertID", shatter_enemy .. " is DEAD!!", function() AutoCastON() end, "begin", 1)

if StatTable.Class == "Psionicist" or StatTable.Class == "Mindbender" then
  AutoCastOFF()
  local quicken = false
  if StatTable.current_mana > 10000 then send("quicken 5"); quicken = true end
  send("cast shatterspell " .. matches[2])
  if quicken then send("quicken off") end
  
end

beep()