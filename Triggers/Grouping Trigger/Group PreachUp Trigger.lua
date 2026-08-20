if StatTable.Level == 125 and (StatTable.current_mana / StatTable.max_mana) < 0.95 and not IsMDAY() then
  beep()
  printGameMessage("Beep", "Preachup without full regen, stayed asleep")
  return
end


OnMobDeathQueueClear()
PreachUp()


 