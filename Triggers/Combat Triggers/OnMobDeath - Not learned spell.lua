-- Trigger: OnMobDeath - Not learned spell 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^You have not learned HOW to cast (.+) yet!$
-- 1 (regex): ^(.+) is too powerful for you to cast in shadow form\.$

-- Script Code:
if type(BuffManager) == "table" and type(BuffManager.MarkSpellUnavailable) == "function" then
  local reason = string.find(matches[1] or "", "shadow form%.$") and "shadow form" or "not learned"
  BuffManager.MarkSpellUnavailable(matches[2], reason)
elseif MobDeath.LastCommand ~= "" then
  MobDeath.LastCommand = ""
end
