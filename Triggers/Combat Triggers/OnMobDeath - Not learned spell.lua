-- Trigger: OnMobDeath - Not learned spell 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^You have not learned HOW to cast (.+) yet!$

-- Script Code:
if type(BuffManager) == "table" and type(BuffManager.MarkSpellUnavailable) == "function" then
  BuffManager.MarkSpellUnavailable(matches[2], "not learned")
elseif MobDeath.LastCommand ~= "" then
  MobDeath.LastCommand = ""
end