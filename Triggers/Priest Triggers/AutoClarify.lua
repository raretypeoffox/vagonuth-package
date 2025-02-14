-- Trigger: AutoClarify 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(\w+) starts to panic!$
-- 1 (regex): ^(\w+) is surrounded by a pink outline.$
-- 2 (regex): ^The eyes of (\w+) dim and turn milky white.$
-- 3 (regex): ^(\w+)'s body withers before your eyes!$
-- 4 (regex): ^Bhyss has come for you, (w\+)$
-- 5 (regex): ^A smarmy grin crosses (\w+)'s face!$
-- 6 (regex): ^(\w+) pales as (he|she|it) (see|sees) (his|her|its) death before (him|her|it).$

-- Script Code:
if not IsGroupMate(matches[2]) then return; end

-- Check if we have a feared tank, if so, clarify immediately
if string.find(matches[1], "death before") then 
  for _, class in ipairs({"War", "Rip", "Bod", "Mon", "Shf", "Bzk", "Bld", "Pal"}) do
    if GlobalVar.GroupMates[GMCP_name(matches[2])].class == class then
        TryAction("quicken 5" .. getCommandSeparator() .. "preach clarify"  .. getCommandSeparator() .. "preach clarify"   .. getCommandSeparator() .. "quicken off", 5)
        return
    end
  end
end

-- Otherwise, we will wait to clarify until no groupmate is critically injured
-- This is done by checking every 10 seconds and not preaching clarify until no one is critically injured
-- Will time out after 10 tries (eg 100 seconds)
local function ClarifyAfterHealing(attempts)
  attempts = attempts or 0
  if attempts > 10 then return; end
  
  if StatTable.CriticalInjured > 0 then 
    -- don't clarify if groupies are injured, rather check again in 10 seconds
    safeTempTimer("AutoClarifyTimer", 10, function() ClarifyAfterHealing(attempts + 1); end)
  else
    -- no one critically injured, safe to clarify
    if TryFunction("PreachClarify", Battle.NextAct, {"preach clarify", 7}, 15) then
      printGameMessage("GameLoop", "Attempting to preach clarify")
    end
    safeKillTimer("AutoClarifyTimer")
  end
end

-- if we manually preach clarify (or some other trigger/script acts), then kill the recursive calls
function PreachedClarifyBeforeTrigger(event, args)
  if args == "preach clarify" then
    safeKillTimer("AutoClarifyTimer")
    safeKillEventHandler("PreachedClarifyBeforeTrigger")
  end
end

safeEventHandler("PreachedClarifyBeforeTrigger", "sysDataSendRequest", "PreachedClarifyBeforeTrigger", false)

ClarifyAfterHealing()


    


