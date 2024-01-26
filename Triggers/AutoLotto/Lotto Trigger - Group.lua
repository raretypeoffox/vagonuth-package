-- Trigger: Lotto Trigger - Group 
-- Attribute: isActive
-- Attribute: isMultiline


-- Trigger Patterns:
-- 0 (regex): ^\w+ prepares? to lotto among \w+ group of \d+
-- 1 (start of line): The winners of the Lotto are:

-- Script Code:
LottoCapture = {}
BlankLineCount = 0

safeTempTrigger("LottoCaptureTriggerID", "^  (\\w+)!$", function()
  table.insert(LottoCapture, matches[2])
end, "regex")

safeTempTrigger("LottoCaptureEndID", "^$", function() 
  if BlankLineCount == 0 then BlankLineCount = BlankLineCount + 1; return; end
  safeKillTrigger("LottoCaptureTriggerID")
  
  local msg = ""
  for i = 1, #LottoCapture do
    msg = msg .. i .. ". " .. LottoCapture[i] .. " "
  end
  
  printGameMessage("Lotto!", msg, "yellow", "white")
  raiseEvent("OnLotto")  

end, "regex", 2)