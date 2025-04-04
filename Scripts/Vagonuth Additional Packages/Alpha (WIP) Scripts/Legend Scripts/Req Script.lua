-- Script: Req Script
-- Attribute: isActive

-- Script Code:
-- Global tables to hold the req queue and cooldown timestamps.
reqQueue = reqQueue or {}       -- Holds all pending req requests.
reqCooldown = reqCooldown or {} -- Tracks last req time for each target.

-- Function to add a new request to the queue.
function addReqRequest(sender, target)
  local now = os.time()
  
  -- Check if this target was already req'd within the last 5 minutes (300 seconds).
  if reqCooldown[target] and (now - reqCooldown[target] < 300) then
    send("tell " .. sender .. " Sorry, " .. target .. " was req'd recently. Please try again later.")
    return
  end

  -- Record the time for this target to enforce the cooldown.
  reqCooldown[target] = now
  
  -- Add the request to the queue.
  table.insert(reqQueue, {sender = sender, target = target, time = now})
  
  -- Inform the sender if their request has been queued.
  if #reqQueue > 1 then
    send("tell " .. sender .. " Your req for " .. target .. " is queued. Please wait your turn.")
  else
    send("tell " .. sender .. " Req'ing " .. target)
    processReqQueue()  -- If the queue was empty, start processing immediately.
  end
end

-- Function to process the req queue one entry at a time.
function processReqQueue()
  -- If the queue is empty, nothing to do.
  if #reqQueue == 0 then return end
  
  local currentReq = reqQueue[1]
  local sender = currentReq.sender
  local target = currentReq.target
  
  -- (Optional) Check if you are in the correct room for casting.
  if gmcp.Room.Info.name ~= "A Sphere of Silver Light" then
    send("tell " .. sender .. " You must be in a Sphere of Silver Light to cast requiem.")
    table.remove(reqQueue, 1)
    tempTimer(1, processReqQueue)  -- Process the next request after a short delay.
    return
  end

  -- If needed, stand up (or do any pre-cast checks).
  local wasAsleep = false
  if StatTable.Position == "sleep" then
    wasAsleep = true
    send("stand")
  end

  -- Now do the req commands (in your example, 5 casts).
  for i = 1, 5 do
    send("cast requiem " .. target)
  end
  
  send("tell " .. sender .. " " .. target .. " req'd 5 times")
  
  if wasAsleep then
    send("sleep")
  end
  
  -- Remove the processed request from the queue.
  table.remove(reqQueue, 1)
  
  -- Schedule the processing of the next request after a delay (the req takes about 60 seconds).
  if #reqQueue > 0 then
    tempTimer(60, processReqQueue)
  end
end
