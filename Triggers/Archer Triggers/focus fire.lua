-- Trigger: focus fire 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(\w+) initiates focused fire against
-- 1 (start of line): You focus fire against

-- Script Code:
if not GlobalVar.AutoCast and not GlobalVar.AutoSkill then
  send("focus")
end