if not SafeArea() and StatTable.Foci and not StatTable.Intervention and StatTable.max_health < 10000 then
  send("cast intervention")
end