-- Trigger: AutoFletch 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^Your efforts produced (\d+) (.*) (sling stone|arrow|bolt|dart)
-- 1 (regex): ^You make (\d+) (.*) (sling stones|arrows|bolts|darts), loaded with (\w+).

-- Script Code:
local lag = tonumber(gmcp.Char.Vitals.lag)

local fletch = "fletch '" .. matches[4] ..  "' '" .. matches[3] .. "'"
if (matches[3] == "poison") then
  -- todo: customize poison item (e.g. fang below)
  fletch = fletch .. " fang"
end
GlobalVar.LastFletch = fletch
echo("\nAutoFletch Triggered\n")
echo("\nLast Fletch is: " .. GlobalVar.LastFletch .. "\n")

coroutine.wrap(function()
 
  if (lag > 1) then
    lag = lag - 1
  else
    lag = 1
  end
 
  wait(lag)
  
  if GlobalVar.AutoFletch then
    if (StatTable.current_mana < 500 and StatTable.Level == 125) then
      send("sleep")
      
      repeat
        wait(10)
        StatTable.current_mana = tonumber(gmcp.Char.Vitals.mp)
      until (StatTable.current_mana == StatTable.max_mana)
      send("stand")

    end
    send(fletch)
    send("score") 
  end
end)()





