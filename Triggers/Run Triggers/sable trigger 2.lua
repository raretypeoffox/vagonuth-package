SableTarget = SableTarget or nil

if StatTable.Class == "Assassin" or StatTable.Class == "Archer" then return end

TryAction("get sableroix ", 5)

if SableTarget then
  TryAction("give sableroix " .. SableTarget, 5)
end