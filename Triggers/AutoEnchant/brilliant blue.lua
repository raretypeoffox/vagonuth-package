coroutine.wrap(function()

  
  if (AutoEnchantTable.ItemName ~= string.lower(matches[2])) then
    AutoEnchantDebug("AutoEnchant: Other enchanter's brill detected")
    return
  else
    if (AutoEnchantTable.ItemType == "armor") then
      AutoEnchantPrint("Brill! " .. AutoEnchantTable.ItemName .. " (b" .. AutoEnchantTable.ItemAC .. ") [" .. AutoEnchantTable.Brills + 1 .."]")
    else
      AutoEnchantPrint("Brill! " .. AutoEnchantTable.ItemName .. " (m" .. AutoEnchantTable.ItemMaxDmg .. ") [" .. AutoEnchantTable.Brills + 1 .."]")
    end
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
  
  AutoEnchantDBAdd("brill")
  
  if (AutoEnchantAddLevel() == true) then
    AutoEnchantBrill()
  end
  
  
end)()