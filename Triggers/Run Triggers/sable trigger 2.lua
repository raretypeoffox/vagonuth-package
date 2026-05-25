-- Trigger: sable trigger 2 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line):      A brace of lordly Sableroix arrows are lying on the ground.
-- 1 (start of line):      A brace of Sableroix arrows are lying on the ground.

-- Script Code:
SableTarget = SableTarget or nil

if StatTable.Class == "Assassin" or StatTable.Class == "Archer" then return end

TryAction("get sableroix ", 5)

if SableTarget then
  TryAction("give sableroix " .. SableTarget, 5)
end