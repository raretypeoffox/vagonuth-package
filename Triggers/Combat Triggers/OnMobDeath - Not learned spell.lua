-- Trigger: OnMobDeath - Not learned spell 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^You have not learned HOW to cast (\w+) yet!

-- Script Code:
if (MobDeath.LastCommand == "cast " .. matches[2]) then
  MobDeath.LastCommand = ""
end