-- Trigger: Earned Items 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^You have earned an item! \((?<item>.*)\)

-- Script Code:
if (matches.item == "a hellbreach amulet") then 
  send("touch token")
  return 
end

earned_item = RemoveArticle(matches.item)

printGameMessage("AutoLoot!", "You received: " .. earned_item, "yellow", "white")
QuickBeep()


if StatTable.Level == 125 and type(checkItemIsAlleg) == "function" and checkItemIsAlleg(earned_item) then
  alleg_item = getAllegKeyword(earned_item)
  send("put '" .. alleg_item .. "' " .. StaticVars.AllegBagName)
end