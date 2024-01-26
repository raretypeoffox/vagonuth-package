-- Trigger: absolve 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): absolve
-- 1 (substring): preach absolve

-- Script Code:
if (StatTable.Class == "Priest" and StatTable.Level == 125) then
  TryAction("preach absolve",5)
end