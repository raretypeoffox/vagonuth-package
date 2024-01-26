-- Script: Try Action Functions
-- Attribute: isActive

-- Script Code:
TryActionSet = TryActionSet or {}
TryFunctionSet = TryFunctionSet or {}
TryLockSet = TryLockSet or {}
TryLookStatus = TryLookStatus or true

-- TryAction: will attempt an action only if the action hasn't already been tried in the current wait period
-- Syntax: TryAction(action, wait)
-- action - command to send to server
-- wait - time to wait before allowing the command to be tried again
-- e.g. TryAction("racial revival", 10)
function TryAction(action, wait)
  assert(wait>0)
  assert(action~="cast" or action ~= "rescue" or action ~= "queue" or action ~= "queuepriority")
  if TryActionSet[action] == nil then
    TryActionSet[action] = true
    send(action)
    tempTimer(wait, function() TryActionSet[action] = nil end)
    return true
  else
    -- action already called
    return false
  end
end

-- TryCast: will try a spell only if another spell hasn't been cast in the wait period
-- Syntax: TryCast(action, wait)
-- action - command to send to server
-- wait - time to wait before allowing the command to be tried again
-- e.g. TryCast("cast sanc", 7)
function TryCast(action, wait)
  assert(wait>0)
  --pdebug("TryCast(" .. action .. ", " .. wait .. ") called")
  if TryActionSet["cast"] == nil then
    TryActionSet["cast"] = true
    send(action) 
    tempTimer(wait, function() TryActionSet["cast"] = nil end)
    return true
  else
    -- action already called
    return false
  end  
end

function TryRescue(action, wait)
  assert(wait>0)
  if TryActionSet["rescue"] == nil then
    TryActionSet["rescue"] = true
    send(action) 
    tempTimer(wait, function() TryActionSet["rescue"] = nil end)
    return true
  else
    -- action already called
    return false
  end  
end

function TryQueue(action, wait)
  assert(wait>0)
  if TryActionSet["queue"] == nil then
    TryActionSet["queue"] = true
    OnMobDeathQueue(action)
    tempTimer(wait, function() TryActionSet["queue"] = nil end)
    return true
  else
    -- action already called
    return false
  end  
end

function TryQueuePriority(action, wait)
  assert(wait>0)
  if TryActionSet["queuepriority"] == nil then
    TryActionSet["queuepriority"] = true
    OnMobDeathQueuePriority(action)
    tempTimer(wait, function() TryActionSet["queuepriority"] = nil end)
    return true
  else
    -- action already called
    return false
  end  
end

function TryPrint(message, wait)
  assert(wait>0)
  if TryActionSet["print"] == nil then
    TryActionSet["print"] = true
    print(message)
    tempTimer(wait, function() TryActionSet["print"] = nil end)
    return true
  else
    -- action already called
    return false
  end  
end

-- TryFunction(func_id, func, args, wait)
-- Usage: set a unique identifier with func_id
--        input function is passed in two parts: 
--        function name (without brackets) and function arguments as a table
--        wait is in seconds
-- Example: TryFunction("printAlertID", printGameMessage, {"Alert!", "This is a test alert"}, 10)
-- Example: TryFunction("BeepTest", beep, nil, 5)
function TryFunction(func_id, func, args, wait)
  if TryFunctionSet[func_id] == nil then
    TryFunctionSet[func_id] = true
    if args then func(unpack(args)) else func() end
    safeTempTimer("TryFunction-" .. func_id, wait, function() TryFunctionSet[func_id] = nil; end)
    return true
  else
    return false
  end
end


-- returns true if unlocked, otherwise false
function TryLock(lock_id, wait)
  assert(wait>0)
  if not TryLockSet[lock_id] then
    TryLockSet[lock_id] = true
    safeTempTimer("TryLock-" .. lock_id, wait, function() TryLockSet[lock_id] = nil; end)
    return true
  else
    return false
  end
end

function TryActionOnce(action)
  local Action_ID = "ONCE-" .. string.lower(action)
  if TryActionSet[Action_ID] == nil then
    TryActionSet[Action_ID] = true
    send(action)
    return true
  else
    -- action already called
    return false
  end
end


function TryLook()
  if TryLookStatus then
    send("look")
    TryLookStatus = false
    safeEventHandler("TryLookSetTrue", "gmcp.Room.Players", TryLookSetTrue, true)
    return true
  else
    return false
  end
end

function TryLookSetTrue()
  TryLookStatus = true
end

safeEventHandler("TryLookSetTrue", "gmcp.Room.Players", TryLookSetTrue, true)








