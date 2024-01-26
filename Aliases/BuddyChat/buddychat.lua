-- Alias: buddychat
-- Attribute: isActive

-- Pattern: ^(b|bud) (.*)

-- Script Code:
if GlobalVar.BuddyChatName and GlobalVar.BuddyChatColour then
  send("buddy |B"..GlobalVar.BuddyChatColour.."|{" .. texttocolour(GlobalVar.BuddyChatColour, GlobalVar.BuddyChatName)  .. "|B"..GlobalVar.BuddyChatColour.."|} |N|" .. matches[3],false)
else
  send("buddy " .. matches[3], false)
end