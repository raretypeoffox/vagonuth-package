-- Script: Safe Mudlet Functions
-- Attribute: isActive

-- Script Code:
-- MUDLET BUG
-- killTriggers take approx 2 seconds to kill before taking affect. This can result in triggers being called multiple times
-- if trigger is matched shortly after killTrigger
-- see issue for details: https://github.com/Mudlet/Mudlet/issues/5284

safeTimerTable = safeTimerTable or {}
safeEventTable = safeEventTable or {}
safeTriggerTable = safeTriggerTable or {}
safeAliasTable = safeAliasTable or {}

function safeTempTimer(id, time, func, repeating)
  local repeating = repeating or false

  -- If the timer exists, kill it
  if safeTimerTable[id] then
    killTimer(safeTimerTable[id])
  end
  
  safeTimerTable[id] = tempTimer(time, func, repeating)
  return safeTimerTable[id]
end

function safeKillTimer(id)
  if safeTimerTable[id] then
    local retval = killTimer(safeTimerTable[id])
    safeTimerTable[id] = nil
    return retval
  end
  return false
end


function safeEventHandler(id, event_name, func, one_shot)
  one_shot = one_shot or false
  
  -- If the event exists, kill it
  if safeEventTable[id] then
    killAnonymousEventHandler(safeEventTable[id])
  end
  
  safeEventTable[id] = registerAnonymousEventHandler(event_name, func, one_shot)
  return safeEventTable[id]
end

function safeKillEventHandler(id)
  if safeEventTable[id] then
    local retval = killAnonymousEventHandler(safeEventTable[id])
    safeEventTable[id] = nil
    return retval
  end
  return false
end

-- Table to associate trigger types to their respective functions
local triggerFunctions = {
  substring = tempTrigger,
  exact = tempExactMatchTrigger,
  begin = tempBeginOfLineTrigger,
  regex = tempRegexTrigger
}

function safeTempTrigger(id, pattern, func, triggerType, expireAfter)
  local triggerType = triggerType or "substring"  -- default type if not specified
  local expireAfter = expireAfter or nil

  -- Ensure the triggerType is valid
  if not triggerFunctions[triggerType] then
    error("Invalid trigger type specified!")
    return false
  end

  -- If the trigger exists, kill it
  if safeTriggerTable[id] then
    killTrigger(safeTriggerTable[id])
  end

  -- Call the appropriate function from the lookup table
  safeTriggerTable[id] = triggerFunctions[triggerType](pattern, func, expireAfter)
  return safeTriggerTable[id]
end

function safeKillTrigger(id)
  if safeTriggerTable[id] then
    local retval = killTrigger(safeTriggerTable[id])
    safeTriggerTable[id] = nil
    return retval
  end
  return false
end

function safeTempAlias(id, pattern, func)
  if safeAliasTable[id] then
    killAlias(safeAliasTable[id])
  end

  safeAliasTable[id] = tempAlias(pattern, func)
  return safeAliasTable[id]
end

function safeKillAlias(id)
  if safeAliasTable[id] then
    local retval = killAlias(safeAliasTable[id])
    safeAliasTable[id] = nil
    return retval
  end
  return false
end