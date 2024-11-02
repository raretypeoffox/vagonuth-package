-- Trigger: Flash Highlight OFF 
-- Attribute: isActive
-- Attribute: isColorizerTrigger

-- mFgColor: #ffffff
-- mBgColour: #0055ff

-- Trigger Patterns:
-- 0 (regex): ^The eyes of (.*) brighten and clear.$

-- Script Code:
if not IsGroupMate(matches[2]) then
  printGameMessage("Mob Eyes Clear!", matches[2])
end