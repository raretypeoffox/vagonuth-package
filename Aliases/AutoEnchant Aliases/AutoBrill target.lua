-- Alias: AutoBrill target
-- Attribute: isActive

-- Pattern: ^autobrill\s*(\d*)

-- Script Code:
local autobrilltarget = tonumber(matches[2])

if (autobrilltarget == nil) then
  print("autobrill - sets target brills to achieve during AutoEnchant")
  print("Synax: autobrill <#>")
elseif (autobrilltarget > 0) then
  AutoEnchantTable.BrillTarget = tonumber(matches[2])
  print("AutoEnchant: Brill Target set to " .. matches[2] .. "\n")
else
  print("autobrill - sets target brills to achieve during AutoEnchant")
  print("Synax: autobrill <#>")
end