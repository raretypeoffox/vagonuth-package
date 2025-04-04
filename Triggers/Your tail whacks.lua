-- Trigger: Your tail whacks 
-- Attribute: isActive
-- Attribute: isColorizerTrigger

-- mFgColor: #ff0000
-- mBgColour: #ffff00

-- Trigger Patterns:
-- 0 (substring): Your tail whacks

-- Script Code:
if StatTable.InspireTimer and not GlobalVar.Silent then
  send("emote mana proc!")
end