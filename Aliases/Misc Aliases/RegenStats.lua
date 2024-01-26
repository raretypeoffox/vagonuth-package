-- Alias: RegenStats
-- Attribute: isActive

-- Pattern: ^regenstats$

-- Script Code:
coroutine.wrap(function()

  printGameMessage("Regen", "Tracking regen rates [current health/mana: " .. StatTable.current_health .. " / " ..StatTable.current_mana .. "]")
  local lastmana = tonumber(gmcp.Char.Vitals.mp)
  local lasthealth = tonumber(gmcp.Char.Vitals.hp)
  
  if (StatTable.Foci == nil) then
    send("stand")
    send("cast foci")
    wait(15)
  end
  send("sleep")
  
  local lasttick = tonumber(StatTable.Foci)
  local tickcount = 1

  repeat
    wait(2)
    send("score")
    send("group")
    GMCP_Vitals()
    
    
    StatTable.current_mana = tonumber(gmcp.Char.Vitals.mp)
    StatTable.current_health = tonumber(gmcp.Char.Vitals.hp)
    
    if (StatTable.current_mana > lastmana) then
      
      if (tonumber(StatTable.Foci) < lasttick) then
        printGameMessage("Regen", "Tick " .. tickcount .. "! Current Health/Mana: " .. StatTable.current_health .. " / " .. StatTable.current_mana .. " : Last Health/Mana: " .. lasthealth .. " / " .. lastmana .. " diff: " .. (StatTable.current_health - lasthealth) .. " / " .. (StatTable.current_mana - lastmana))
        lasttick = tonumber(StatTable.Foci)
        tickcount = tickcount + 1
      else
        printGameMessage("Regen", "Mid Tick! Current Health/Mana: " .. StatTable.current_health .. " / " .. StatTable.current_mana .. " : Last Health/Mana: " .. lasthealth .. " / " .. lastmana .. " diff: " .. (StatTable.current_health - lasthealth) .. " / " .. (StatTable.current_mana - lastmana))
      end
      
      lastmana = StatTable.current_mana
      lasthealth = StatTable.current_health
    end
    
    
  until (StatTable.current_mana == StatTable.max_mana and StatTable.current_health == StatTable.max_health)

  printGameMessage("Regen", "Full mana! Done tracking\n")


end)()