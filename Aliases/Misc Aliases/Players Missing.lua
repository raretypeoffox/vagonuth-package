-- Alias: Players Missing
-- Attribute: isActive

-- Pattern: ^(?i)missing$

-- Script Code:
if TryLook() then
  if not GlobalVar.Silent then
    tempTimer(1, function() CheckMissingGtell() end)
  else
    tempTimer(1, function() CheckMissingEcho() end)
  end
else
  print("Players Missing ERROR: try again out of lag")
end
