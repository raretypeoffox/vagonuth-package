tempTimer(5, function() send("open south"); send("south"); send("sleep") end)
send("pinfo + Sanc insig until past level " .. (StatTable.SubLevel + 74))