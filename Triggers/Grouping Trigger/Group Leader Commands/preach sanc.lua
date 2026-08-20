if (StatTable.Class == "Priest" and StatTable.Level == 125 and StatTable.SubLevel >= 25) then
  if Battle.Combat and not StatTable.Solitude then
    send("quicken 9" .. getCommandSeparator() .. "cast inno" .. getCommandSeparator() .. "quicken off")
  end
  send("preach sanc")
end