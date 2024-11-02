-- Trigger: Item Pickup 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^You get (a|an|the) (?<item>.*) from corpse of (?<mobname>.*).$
-- 1 (regex): ^You get (?<item>.*) from corpse of (?<mobname>.*).$

-- Script Code:
--You get a kzinti pickaxe from corpse of A kzinti miner.
--You get 129 gold coins from corpse of A kzinti guardian.

-- ^You get (a|an|the)? ?(?<item>.*) from corpse of (?<mobname>.*).$

-- first pattern attempts to strip away a/an/the
-- second pattern picks up matches without them, eg, You get omayra's kit from corpse of the broken Oni.

if matches.mobname == StatTable.CharName then return end

if StatTable.Level == 125  then

  if type(checkItemIsAlleg) == "function" and checkItemIsAlleg(matches.item) then
    printGameMessage("Alleg!", "Looted " .. matches.item, "yellow", "white")
    alleg_item = getAllegKeyword(matches.item)
    if IsMDAY() or not Grouped() then
      send("put '" .. alleg_item .. "' " .. StaticVars.AllegBagName)
    else
      if GlobalVar.GroupLeader ~= StatTable.CharName then 
        send("give '" .. alleg_item .. "' " .. GlobalVar.GroupLeader)
      end
    end
    
  elseif StaticVars.Junk[matches.item] then 
    send("drop '" .. StaticVars.Junk[matches.item] .. "'")
    printGameMessageVerbose("Junk", "Dropped " .. matches.item)
  end
end


