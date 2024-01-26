-- Trigger: Soitude 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^You dream of (\w+) telling you 'solitude'
-- 1 (regex): ^(\w+) tells you 'solitude'

-- Script Code:
-- TODO: write a better solitude trigger

if StatTable.Level == 125 then

  if StatTable.Position == "Sleep" then
    send("tell " .. matches[2] .. " Sorry, I'm currently sleeping and can't cast solitude. Please try again when I'm awake")
    return
  end
  
  if StatTable.SolitudeTimer then
    send("tell " .. matches[2] .. " Sorry, my solitude is currently exhausted")
  end

  send("cast solitude " .. matches[2])
end