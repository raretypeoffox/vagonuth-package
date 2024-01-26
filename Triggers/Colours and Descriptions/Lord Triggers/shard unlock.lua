-- Trigger: shard unlock 
-- Attribute: isActive
-- Attribute: isColorizerTrigger

-- mFgColor: #ffff00
-- mBgColour: #aa00ff

-- Trigger Patterns:
-- 0 (start of line): Somewhere in the distance, you hear a being of energy cry out as the final seal to another realm breaks

-- Script Code:
if (GlobalVar.GUI) then
  printGameMessage("Shard!", "Shard unlocked", "purple", "yellow")
end

--Somewhere on distant planes, a disturbance is felt.
--Bosses, once defeated have returned anew.