-- Trigger: Tingles 
-- Attribute: isActive
-- Attribute: isColorizerTrigger

-- mFgColor: #aa007f
-- mBgColour: transparent

-- Trigger Patterns:
-- 0 (regex): ^You feel more confidence in your ability with (.*).$
-- 1 (start of line): You feel a brief tingling sensation all over your body.

-- Script Code:
if (GlobalVar.GUI and matches[2]) then
  printGameMessage("Tingle!", matches[2], "purple", "yellow")
end