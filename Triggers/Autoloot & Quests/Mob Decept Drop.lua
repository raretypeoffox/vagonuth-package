-- Trigger: Mob Decept Drop 
-- Attribute: isActive
-- Attribute: isColorizerTrigger

-- mFgColor: #ff0000
-- mBgColour: #ffff00

-- Trigger Patterns:
-- 0 (regex): ^(?<mobname>.*) is so disgusted with (an|a|the) (?<item>.*) it tries to drop it!$
-- 1 (regex): ^(?<mobname>.*) is so disgusted with (?<item>.*) it tries to drop it!$

-- Script Code:
-- The Lord of the Earth Elementals is so disgusted with the earthen mace of might it tries to drop it!

if StatTable.Level == 125  then
  if type(checkItemIsAlleg) == "function" and checkItemIsAlleg(matches.item) then
    alleg_item = getAllegKeyword(matches.item)
    printGameMessage("Decept!", "Mob dropped " .. matches.item .. ", attempting to pick it up", "yellow", "white")
    TryAction("get '" .. alleg_item .. "'", 5)
  end
end
    