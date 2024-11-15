-- Script: Tank Direction Trigger
-- Attribute: isActive

-- Script Code:
function TankDirection()
  -- Make sure the request came from the GroupLeader (should always be the case)
  if matches.leader ~= GlobalVar.GroupLeader then 
    pdebug("TankDirection() debug: matches.leader (" .. matches.leader .. ") didn't match GlobalVar.GroupLeader (" .. GlobalVar.GroupLeader .. ")")
    return 
  end
  
  -- Only move if we have AutoRescue on
  if not AR.Status then
    printGameMessage("TankDir", "Groupleader requested you to move but AutoRescue is off (will only move if AR is on)")
    QuickBeep()
    return
  end
  
  printGameMessage("TankDir", "Moving " .. matches.dir .. " in 2 secs on group leader's request")
  
  local dir = matches.dir
  
  tempTimer(2, function()
    send(dir)
    -- Every class other than Berserker should have access to burning hands. Berserker can whirlwind but only in combat
    if StatTable.Class == "Berserker" then
      safeEventHandler("BerserkerTankDirection", "OnCombat", function() send("whirlwind") end, true)
    else
      send("cast 'burning hands'")
    end
  end)
end

function TankDirectionCleanup()
    safeKillTrigger("TankDirectionID")
end

function TankDirectionInit()
    if not StatTable.CharName then printMessage("DEBUG ERROR", "TankDirectionInit() has no charname!!", "yellow") end
    if not StatTable or not StatTable.CharName then return end
    printMessage("DEBUG", "TankDirectionInit() successfully called", "yellow")
    
    -- Initialize the pattern
    local pattern = "^\\*(?<leader>\\w+)\\* tells the group '(?i)" .. string.sub(StatTable.CharName, 1, 3)
    
    if string.len(StatTable.CharName) > 3 then
        for i = 4, string.len(StatTable.CharName) do
            pattern = pattern .. "[" .. string.sub(StatTable.CharName, i, i) .. "]*"
        end
    end

    pattern = pattern .. "\\,? (?<dir>north|west|east|south|up|down|n|w|e|s|u|d)'$"

    safeTempTrigger("TankDirectionID", pattern, TankDirection, "regex")
    safeEventHandler("TankDirectionCleanupID", "sysDisconnectionEvent", TankDirectionCleanup, true)
end

-- TankDirection() will be called everytime ProfileInit is (eg, every login)
safeEventHandler("TankDirectionInitID", "CustomProfileInit", TankDirectionInit, true)