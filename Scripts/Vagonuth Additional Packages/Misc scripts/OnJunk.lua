-- Script: OnJunk
-- Attribute: isActive

-- Script Code:
OnDropJunk = OnDropJunk or {}
OnDropJunk.isOpen = OnDropJunk.isOpen or false
OnDropJunk.len = OnDropJunk.len or 0
OnDropJunk.Queue = OnDropJunk.Queue or {}
OnDropJunk.isProcessing = OnDropJunk.isProcessing or false


function OnDropJunk.parseLine(line)
  -- First, trim any leading/trailing whitespace.
  local parsed_line = line:gsub("^%s*(.-)%s*$", "%1")
  
  -- Remove a leading parenthesized number, e.g. "( 8) "
  parsed_line = parsed_line:gsub("^%(%s*%d+%s*%)%s*", "")
  
  -- Remove the condition message enclosed in brackets, e.g. "[Pristine  ] "
  parsed_line = parsed_line:gsub("^%[[^%]]+%]%s*", "")
  
  -- Remove any parenthesized words (for example, "(Glowing)") if present.
  parsed_line = parsed_line:gsub("%((%a+)%) ", "")
  parsed_line = parsed_line:gsub("%((%a+ %a+)%) ", "")
  
  -- Remove any leading article
  parsed_line = RemoveArticle(parsed_line)
  parsed_line = parsed_line:gsub("^%s*%d+%s+", "")
  
  -- (Optionally) Trim again in case extra spaces remain.
  parsed_line = parsed_line:gsub("^%s*(.-)%s*$", "%1")

  return parsed_line
end

function OnDropJunk.sendNext()
  if #OnDropJunk.Queue > 0 then
    send(OnDropJunk.Queue[1])
    table.remove(OnDropJunk.Queue, 1)
    -- Use tempTimer to wait (e.g., 1 second) before sending the next command.
    tempTimer(0.1, OnDropJunk.sendNext)
  else
    -- No more commands to process.
    OnDropJunk.isProcessing = false
  end
end

