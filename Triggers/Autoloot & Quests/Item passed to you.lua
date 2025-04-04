-- Trigger: Item passed to you 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(?<mobname>.*) gives you (an|a|the)? ?(?<item>.*)\.$

-- Script Code:
if IsGroupMate(matches.mobname) and not IsMDAY() then 
  printGameMessageVerbose("Item Given", matches[1])
  return
end

if StatTable.Level == 125 and type(checkItemIsAlleg) == "function" and checkItemIsAlleg(matches.item) then
  
  if matches.mobname ~= "Allegaagse" then 
    printGameMessageVerbose("Alleg Recvd", matches[1], "yellow", "white")
  end
  
  alleg_item = getAllegKeyword(matches.item)
  send("put '" .. alleg_item .. "' " .. StaticVars.AllegBagName)
  return
else
  if matches.mobname ~= "Allegaagse" then
    printGameMessageVerbose("Item Recvd", matches[1], "yellow", "white")
  end 
end

    


