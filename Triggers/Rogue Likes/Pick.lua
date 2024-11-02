-- Trigger: Pick 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^\*\w+\* tells the group 'pick (\w+)'

-- Script Code:
-- todo make better
local PickBagName = "loot"

send("get door " .. PickBagName)
send("wear door")
send("pick " .. matches[2])

if StatTable.Level == 125 then
  if StatTable.ArmorClass < -1800 then
    send("wear lode")
    send("wear dawiz")
  else
    send("wear hand")
  end
end

send("put door " .. PickBagName)

