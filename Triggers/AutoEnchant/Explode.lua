coroutine.wrap(function()
  if (AutoEnchantTable.ItemName ~= string.lower(matches[2])) then
    AutoEnchantDebug("AutoEnchant: Other enchanter's explosion detected")
    return
  end
  
    if (StatTable.current_mana < 200) then
      send("sleep")
      
      repeat
        wait(10)
        StatTable.current_mana = tonumber(gmcp.Char.Vitals.mp)
      until (StatTable.current_mana == StatTable.max_mana)
      send("stand")
      print("max mana")
    end
    
    local base
    
    if (AutoEnchantTable.ItemType == "armor") then
      base = " (b" .. AutoEnchantTable.ItemAC .. ")"
    else
      base = " (m" .. AutoEnchantTable.ItemMaxDmg .. ")"
    end
    
    if (AutoEnchantTable.Brills > 0) then
      AutoEnchantPrint("Brill exploded!" .. base)
    else
      AutoEnchantPrint("Item exploded" .. base)
    end
    
    AutoEnchantDBAdd("explode")
    AutoEnchantReset()
  
  
end)()