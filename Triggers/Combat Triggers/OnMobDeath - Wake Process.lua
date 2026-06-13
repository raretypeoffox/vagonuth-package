-- Trigger: OnMobDeath - Wake Process
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): You wake and stand up.

-- Script Code:
if type(OnMobDeathWake) == "function" then
  OnMobDeathWake(0.5)
elseif type(BuffManager) == "table" and type(BuffManager.Process) == "function" then
  BuffManager.Process()
end
