-- Trigger: Cast intervention on wake 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): You wake and stand up.

-- Script Code:
if not SafeArea() and StatTable.Foci and not StatTable.Intervention then
  send("cast intervention")
end