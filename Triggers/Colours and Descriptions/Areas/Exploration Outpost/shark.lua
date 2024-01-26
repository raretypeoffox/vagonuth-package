-- Trigger: shark 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): A hungry shark dives at your kill!

-- Script Code:
if not GlobalVar.Silent then
  send("emote  " .. texttocolour("R", " SHARK") .. "|N|!")
end