-- Trigger: Lotto Trigger - Single 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^The winner of the Lotto is:  (\w+)!$

-- Script Code:
LottoCapture = {}

table.insert(LottoCapture, matches[2])
raiseEvent("OnLotto")

printGameMessage("Lotto!", "Winner is " .. matches[2], "yellow", "white")