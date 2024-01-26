-- Trigger: You feel the presence of Shizaga! 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): You feel the presence of Shizaga!

-- Script Code:
-- DEBUG / TODO: needs fixing

coroutine.wrap(function()
 

  if (AutoEnchantTable.ItemType == "armor") then
    AutoEnchantPrint("Brill! " .. AutoEnchantTable.ItemName .. " (b" .. AutoEnchantTable.ItemAC .. ") [" .. AutoEnchantTable.Brills + 1 .."]")
  else
    AutoEnchantPrint("Brill! " .. AutoEnchantTable.ItemName .. " (b" .. AutoEnchantTable.ItemMaxDmg .. ") [" .. AutoEnchantTable.Brills + 1 .."]")
  end

  
  AutoEnchantDBAdd("Shizaga")

  
  
end)()