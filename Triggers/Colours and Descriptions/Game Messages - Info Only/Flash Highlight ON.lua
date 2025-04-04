-- Trigger: Flash Highlight ON 
-- Attribute: isActive
-- Attribute: isColorizerTrigger

-- mFgColor: #0055ff
-- mBgColour: #ffffff

-- Trigger Patterns:
-- 0 (regex): ^The eyes of (.*) dim and turn milky white\.$

-- Script Code:
if not IsGroupMate(matches[2]) then
  printGameMessageVerbose("Mob Flashed!", matches[2])
end