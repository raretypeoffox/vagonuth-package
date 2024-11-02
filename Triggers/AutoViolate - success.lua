-- Trigger: AutoViolate - success 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): It briefly glows with an evil aura.

-- Script Code:

if StaticVars.LootBagName then
  send("put " .. GlobalVar.AutoViolateItem .. " " .. StaticVars.LootBagName)
else
  send("drop " .. GlobalVar.AutoViolateItem)
end
send("cast violation " .. GlobalVar.AutoViolateItem)