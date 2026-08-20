if StatTable.Level == 250 then return end

printGameMessage("Tingle!", matches[2], "purple", "yellow")
TingleBeep()

raiseEvent("OnTingle", matches[2])
