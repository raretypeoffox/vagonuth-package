if Battle.Combat then
  printGameMessage("Earthbind", "You've lost fly!", "red", "white")
  if IsClass({"Beserker"}) then return end
  OnMobDeath("cast fly")
end