-- Trigger: On PInfo 


-- Trigger Patterns:
-- 0 (regex): ^Your playerinfo is:

-- Script Code:

if not OnPInfo.isOpen then   -- this checks for the first line, and initializes your variables
   OnPInfo.len = 1
   OnPInfo.isOpen = true
   if not OnPInfo.Lock then OnPInfo.PInfoArray = {} end
end

OnPInfo.len = OnPInfo.len + 1   -- this keeps track of how many lines the trigger is capturing

if not OnPInfo.IsPrompt(line) then
  OnPInfo.ArrayAddLine(line)
else
  OnPInfo.ArrayFinish()

   OnPInfo.len = 0
   OnPInfo.isOpen = false
end

setTriggerStayOpen("On PInfo",OnPInfo.len)   -- this sets the number of lines for the trigger to capture

