-- Script: OnInventoryUpdate
-- Attribute: isActive
-- OnInventoryUpdate() called on the following events:
-- gmcp.Char.Items.List

-- Script Code:

function OnInventoryUpdate()
  if gmcp.Char.Items.List.location ~= "inv" or StatTable.Position == "Sleep" then
    return
  end

  if not TryLock("OnInvUpdate", 5) then
    return
  end

  local Item_Tracker = {
    ["consecrated ashes"] = 0,
    ["sulfurous ashes"] = 0
  }
  
  local mindtrick = ""
  
  
  if StatTable.Level == 125 and StatTable.Class == "Psionicist" then
    mindtrick = "|B|" .. gmcp.Char.Status.character_name .. "'s glowing mindtrick|N|" -- use gmcp here not StatTable.CharName to preserve capitalization (to test, colours)
    Item_Tracker[mindtrick] = 0
  end 

  for _, item in ipairs(gmcp.Char.Items.List.items) do
    if Item_Tracker[item.name] then
      Item_Tracker[item.name] = Item_Tracker[item.name] + 1

      if Item_Tracker[item.name] > 1 and item.name ~= mindtrick then
        TryAction("put '" .. item.name .. "' '" .. StaticVars.LootBagName .. "'", 500)
      end
    end
  end
  
  if mindtrick then
    GlobalVar.Mindtricks = Item_Tracker[mindtrick]
  end
end



safeTempTrigger("MagicLightInvUpdate", "You twiddle your thumbs", function() sendGMCP("Char.Items.Inv") end, "begin")
