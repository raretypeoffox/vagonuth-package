-- Trigger: Flee 
-- Attribute: isActive
-- Attribute: isColorizerTrigger

-- mFgColor: #000000
-- mBgColour: #ffff00

-- Trigger Patterns:
-- 0 (regex): ^You flee (\w+)! What a COWARD! You lose (\d+) exps!$

-- Script Code:
--You flee east! What a COWARD! You lose 146 exps!
if (GlobalVar.GUI) then
  printGameMessage("Flee!", "You fled <yellow>" .. string.upper(matches[2]) .. "<ansi_white>! (XP Loss:<red>" .. matches[3] .. "<ansi_white>)")
end
QuickBeep()
