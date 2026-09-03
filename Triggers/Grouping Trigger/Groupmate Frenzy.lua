if GroupLeader() or 
  IsClass({"Berserker", "Priest", "Shadowfist", "Sorcerer", "Necromancer"}) or 
  (StatTable.Level < 51 or StatTable.SubLevel < 41) or 
  StatTable.Alignment < 300 then
    return
end

if Battle.Combat then
  OnMobDeath("cast frenzy " .. matches[2])
  printGameMessage("Request", "Added frenzy on " .. matches[2] .. " to queue")
else
  send("cast frenzy " .. matches[2])
  printGameMessage("Request", "Casting frenzy on " .. matches[2])
end