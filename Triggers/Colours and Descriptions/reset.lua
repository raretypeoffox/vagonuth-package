-- Trigger: reset 
-- Attribute: isActive
-- Attribute: isColorizerTrigger

-- mFgColor: #ffff00
-- mBgColour: #aa00ff

-- Trigger Patterns:
-- 0 (start of line): Bosses, once defeated have returned anew.

-- Script Code:
if (GlobalVar.GUI) then
  printGameMessage("Reset!", "Server reset", "purple", "yellow")
  beep()
end

--Somewhere on distant planes, a disturbance is felt.
--Bosses, once defeated have returned anew.