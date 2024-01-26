-- Trigger: AutoPanacea 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(\w+) shivers and suffers.$
-- 1 (regex): ^(\w+) clutches at his heart in pain!$

-- Script Code:
if not IsGroupMate(matches[2]) then return; end

-- If we're a super hero, just cast panacea not preach
if StatTable.Level < 125 then
  if StatTable.SubLevel < 500 then return end
  
  Battle.DoAfterCombat("cast panacea " .. matches[2], 30)
  return
end

-- Otherwise, we will wait to Panacea until no groupmate is critically injured
-- This is done by checking every 10 seconds and not preaching Panacea until no one is critically injured
-- Will time out after 10 tries (eg 100 seconds)
local function PanaceaAfterHealing(attempts)
  attempts = attempts or 0
  if attempts > 10 then return; end
  
  if StatTable.CriticalInjured > 0 then 
    -- don't Panacea if groupies are injured, rather check again in 10 seconds
    safeTempTimer("AutoPanaceaTimer", 10, function() PanaceaAfterHealing(attempts + 1); end)
  else
    -- no one critically injured, safe to Panacea
    if TryFunction("PreachPanacea", Battle.NextAct, {"preach panacea", 7}, 15) then
      printGameMessage("GameLoop", "Attempting to preach panacea")
    end
    safeKillTimer("AutoPanaceaTimer")
  end
end

-- if we manually preach Panacea (or some other trigger/script acts), then kill the recursive calls
function PreachedPanaceaBeforeTrigger(event, args)
  if args == "preach panacea" then
    safeKillTimer("AutoPanaceaTimer")
    safeKillEventHandler("PreachedPanaceaBeforeTrigger")
  end
end

safeEventHandler("PreachedPanaceaBeforeTrigger", "sysDataSendRequest", "PreachedPanaceaBeforeTrigger", false)

PanaceaAfterHealing()


    


