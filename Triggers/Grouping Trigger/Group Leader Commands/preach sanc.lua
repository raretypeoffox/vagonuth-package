-- Trigger: preach sanc 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): preach sanc

-- Script Code:
if (StatTable.Class == "Priest" and StatTable.Level == 125 and StatTable.SubLevel >= 25) then
  if Battle.Combat and not StatTable.Solitude then
    send("quicken 9" .. getCommandSeparator() .. "cast inno" .. getCommandSeparator() .. "quicken off")
  end
  send("preach sanc")
end