-- Trigger: Threned corpse 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^\[LORD INFO\]: \w+ finishes Threnody, moving corpse of (\w+) to safety.

-- Script Code:
if (matches[2] == StatTable.CharName) then
  send("get all corpse")
  send("get all " .. StatTable.CharName)
  TryLook()
  send("wear all")
end
