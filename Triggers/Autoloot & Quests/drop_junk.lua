-- Trigger: drop_junk 


-- Trigger Patterns:
-- 0 (regex): ^You are carrying:

-- Script Code:
if not OnDropJunk then
  OnDropJunk.len = 1
  OnDropJunk.isOpen = true
end

OnDropJunk.len = OnDropJunk.len + 1

if line ~= "" then
  local item_qty = string.match(line, "^%(%s*(%d+)%s*%)")
  local parsed_line = OnDropJunk.parseLine(line)

  -- Now parsed_line should contain the cleaned-up text.
  if type(checkItemIsAlleg) == "function" and checkItemIsAlleg(parsed_line) then
    alleg_item = getAllegKeyword(parsed_line)
    if item_qty then alleg_item = "all." .. alleg_item end
    table.insert(OnDropJunk.Queue, "put '" .. alleg_item .. "' " .. StaticVars.AllegBagName)
  elseif StaticVars.Junk[parsed_line] then
  
    local drop_item = StaticVars.Junk[parsed_line]
    if item_qty then drop_item = "all." .. drop_item end
    table.insert(OnDropJunk.Queue, "drop '" .. drop_item .. "'")
    printGameMessageVerbose("Junk", "Dropped " .. parsed_line)

  end
  
else
  OnDropJunk.len = 0
  OnDropJunk.isOpen = false
  disableTrigger("drop_junk")
  -- If not already processing, start sending commands from the queue.
  if not OnDropJunk.isProcessing and #OnDropJunk.Queue > 0 then
    OnDropJunk.isProcessing = true
    OnDropJunk.sendNext()
  end
  

end

setTriggerStayOpen("drop_junk",OnDropJunk.len)   -- this sets the number of lines for the trigger to capture

