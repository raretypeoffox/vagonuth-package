-- Trigger: 2s 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): 2s

-- Script Code:
Try2sLock = Try2sLock or nil

if Try2sLock == true then return end

Try2sLock = true
tempTimer(10, [[Try2sLock = nil]])

coroutine.wrap(function()
    local RoomName = gmcp.Room.Info.name    
    if (RoomName == "Outside a Vent") then
      if (StatTable.current_health < 5000) then 
        local time_to_wait = math.max(5-math.floor(StatTable.current_health/1000),1)
        wait(time_to_wait) 
      end
      repeat
        local lag = tonumber(gmcp.Char.Vitals.lag)
        if lag == 0 then
          send("south")
          send("south")
          TryLook()
        end
        wait(2)
        RoomName = gmcp.Room.Info.name        
      until (RoomName == "Within the Nest")
    else
      pdebug("Trigger [Outside a Vent]: Not outside a vent, ignore 2s call")
    end
end)()
