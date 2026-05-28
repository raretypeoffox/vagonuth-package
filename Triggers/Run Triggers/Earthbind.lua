-- Trigger: Earthbind 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (exact): You slowly float to the ground.

-- Script Code:
if Battle.Combat then
  printGameMessage("Earthbind", "You've lost fly!", "red", "white")
  if IsClass({"Beserker"}) then return end
  OnMobDeath("cast fly")
end