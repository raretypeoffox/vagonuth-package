-- Alias: AutoEnchant
-- Attribute: isActive

-- Pattern: ^auto(weapon|armor|bow) (\w+)$

-- Script Code:
if (matches[3] == "stop" or matches[3] == "off") then
  AutoEnchantTable.Status = false
else

  if (StatTable.current_mana < 200) then
    print("AutoEnchant: please have 200 mana before starting")
  else
    print("AutoEnchant " .. matches[2] .. " init: " .. matches[3])
    AutoEnchantInit(matches[3], matches[2])
  end
end