-- The Lord of the Earth Elementals is so disgusted with the earthen mace of might it tries to drop it!

if StatTable.Level == 125  then
  if type(checkItemIsAlleg) == "function" and checkItemIsAlleg(matches.item) then
    alleg_item = getAllegKeyword(matches.item)
    printGameMessage("Decept!", "Mob dropped " .. matches.item .. ", attempting to pick it up", "yellow", "white")
    TryAction("get '" .. alleg_item .. "'", 5)
  end
end
    