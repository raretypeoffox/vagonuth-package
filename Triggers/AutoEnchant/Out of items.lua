-- Trigger: Out of items 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^You are not carrying (.*)!$

-- Script Code:
if (AutoEnchantTable.Item == matches[2]) then
  AutoEnchantDebug("AutoEnchant: out of items, ending AutoEnchant")
  AutoEnchantPrint("out of items, ending")
  AutoEnchantTable.Status = false
  send("sleep")
end

