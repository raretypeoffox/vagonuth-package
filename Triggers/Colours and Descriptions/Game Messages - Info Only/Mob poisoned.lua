-- Trigger: Mob poisoned 
-- Attribute: isActive
-- Attribute: isColorizerTrigger

-- mFgColor: #ff0000
-- mBgColour: #ffff00

-- Trigger Patterns:
-- 0 (regex): ^(.*) succumbs to poison and shivers.$

-- Script Code:
if not IsGroupMate(matches[2]) then
  printGameMessageVerbose("Mob Poisoned!", matches[2])
end