if (matches[2] == StatTable.CharName) then
  send("get all corpse")
  send("get all " .. StatTable.CharName)
  TryLook()
  send("wear all")
end
