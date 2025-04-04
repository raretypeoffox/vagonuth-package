-- Trigger: Drop junk item on rc 
-- Attribute: isActive
-- Attribute: isMultiline


-- Trigger Patterns:
-- 0 (regex): ^Your (.*) glows blue\.$
-- 1 (start of line): You feel an unclean aura lift from you.

-- Script Code:
if StatTable.Level ~= 125 then return end

local item_name = RemoveArticle(multimatches[1][2])

-- if we just RC'd an alleg item, either put it in our bag or pass it to leader.
if type(checkItemIsAlleg) == "function" and checkItemIsAlleg(item_name) then

  alleg_item = getAllegKeyword(item_name)
  
  if IsMDAY() or not Grouped() then
    send("put '" .. alleg_item .. "' " .. StaticVars.AllegBagName)
  elseif GlobalVar.GroupLeader ~= StatTable.CharName then 
      send("give '" .. alleg_item .. "' " .. GlobalVar.GroupLeader)
  else
    pdebug("Trigger (Drop Junk item on rc): not expected to be here, debug")
  end

-- if its junk, drop it
elseif StaticVars.Junk[item_name] then 
  send("drop '" .. StaticVars.Junk[item_name] .. "'")
  printGameMessageVerbose("Junk", "Dropped " .. item_name)
end
