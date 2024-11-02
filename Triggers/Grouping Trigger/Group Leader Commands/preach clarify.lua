-- Trigger: preach clarify 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): clarify
-- 1 (substring): preach clarify

-- Script Code:
if (StatTable.Class == "Priest" and StatTable.Level == 125) then
  TryAction("preach clarify",5)
end