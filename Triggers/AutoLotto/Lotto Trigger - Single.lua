LottoCapture = {}

table.insert(LottoCapture, matches[2])
raiseEvent("OnLotto")

printGameMessage("Lotto!", "Winner is " .. matches[2], "yellow", "white")