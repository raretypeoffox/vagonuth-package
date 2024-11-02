-- Trigger: Alertness down 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): You feel less perceptive.

-- Script Code:
if SafeArea() then return end

if not StatTable.Fortitude then return end

if StatTable.current_moves < 1000 then return end

if Battle.Combat then
  OnMobDeath("alertness")
else
  send("alertness")
end
