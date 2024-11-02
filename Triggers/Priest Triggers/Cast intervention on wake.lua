-- Trigger: Cast intervention on wake 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): You wake and stand up.

-- Script Code:
if not SafeArea() and StatTable.Foci and not StatTable.Intervention and StatTable.max_health < 10000 then
  send("cast intervention")
end