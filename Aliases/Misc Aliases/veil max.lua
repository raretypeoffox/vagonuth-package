-- Alias: veil max
-- Attribute: isActive

-- Pattern: ^veil max$

-- Script Code:
local btmax = BladetranceMax()
local btlevel = StatTable.BladetranceLevel


if StatTable.VeilExhaust then
  print("Veil is still exhausted for " .. StatTable.VeilExhaust .. " ticks",false)
else
  print("Entering Max Veil! ( current: " .. StatTable.BladetranceLevel .. " / max: " .. btmax .. ")")
  
  if not StatTable.VeilTimer then TryAction("stance veil of blades", 10) end
  
  local wait = tonumber(gmcp.Char.Vitals.lag) + (btmax - btlevel) * 2 + 2
  print(wait)
  
  if btlevel == 0 then
    send("bladetrance enter")
    btlevel = btlevel + 1
  end
  
  -- Assuming btlevel and btmax are already defined
  for i = btlevel, (btmax - 1) do
      send("bladetrance deepen")
  end

  tempTimer(wait, function() if StatTable.BladetranceLevel == btmax then send("emote  |BW|Veil at max! (" .. btmax .. ")") end; end)
  
end