-- Trigger: AutoViolate - Out of Items 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^You are not carrying (.*)!$

-- Script Code:
if matches[2] == GlobalVar.AutoViolateItem then
  GlobalVar.AutoViolate = false
  send("sleep")
end