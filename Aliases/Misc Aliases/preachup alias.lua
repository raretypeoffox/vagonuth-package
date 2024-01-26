-- Alias: preachup alias
-- Attribute: isActive

-- Pattern: ^preachup$

-- Script Code:
if StatTable.Class ~= "Priest" then
  printMessage("PreachUp", "Not a priest!")
end

if StatTable.current_mana >= 3500 then
  local was_asleep = false
  if StatTable.Position == "Sleep" then send("wake"); was_asleep = true; end
  send("gtell Spells incoming, sanctuary is last")
  send("preach iron skin")
  send("preach holy sight")
  send("preach water breathing")
  send("preach fortitudes")
  send("preach foci")
  send("preach aegis")
  send("preach sanctuary")
  if was_asleep then send("sleep") end
else
  printMessage("PreachUp", "Need more mana before preaching a full spell up")
  printMessage("PreachUp", "Note: if you have the mana, try reseting your gmcp (by relogging)")
end