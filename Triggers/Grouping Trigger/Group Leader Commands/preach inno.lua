-- Trigger: preach inno 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): preach inno

-- Script Code:
if (StatTable.Class == "Priest" and StatTable.Level == 125) then
  TryAction("preach inno",5)
end