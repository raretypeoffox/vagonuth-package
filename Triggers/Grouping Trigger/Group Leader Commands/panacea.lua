-- Trigger: panacea 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): blind
-- 1 (exact): cb
-- 2 (substring): panacea

-- Script Code:
if (StatTable.Class == "Priest" and StatTable.Level == 125) then
  TryAction("preach panacea",5)
end