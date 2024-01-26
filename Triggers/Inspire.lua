-- Trigger: Inspire 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^\*\w+\* tells the group 'inspire'$

-- Script Code:
if StatTable.InspireExhaust then
  send("gtell Inspire is still exhausted for " .. StatTable.InspireExhaust .. " ticks",false)
else
  if StatTable.Bladetrance and IsMDAY() then TryAction("bladetrance break",5) end
  if not StatTable.InspireTimer then TryAction("stance inspiring dance", 5) end   

end