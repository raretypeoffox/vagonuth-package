-- Alias: giveall
-- Attribute: isActive

-- Pattern: ^giveall (.*)$

-- Script Code:
for x,_ in pairs(GlobalVar.GroupMates) do
  send("give " .. matches[2] .. " " .. string.lower(x))
end