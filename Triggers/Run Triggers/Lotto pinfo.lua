-- Trigger: Lotto pinfo 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^\*?(\w+)\*? tells the group '(\w+)'s pick\. Check my pinfo and gt # to pick\.( Upcoming: )?(\w+)?,? ?(\w+)?,? ?(\w+)?
-- 1 (regex): ^\*?(\w+)\*? tells the group '(\w+) - Pick an item from Pinfo \w+( - Upcoming: )?(\w+)?,? ?(\w+)?,? ?(\w+)?
-- 2 (regex): ^\*(\w+)\*? tells the group '(\w+)'s pick.'
-- 3 (regex): ^\*(\w+)\*? tells the group '(\w+)'s pick! Check pinfo \w+ and gtell <#> or gtell pass. Next up: (\w+)?,? ?(w\+)?, ?(\w+)?,? ?(\w+)?

-- Script Code:
local lottobot = matches[2] -- can't use matches inside tempTimer

if matches[3] == StatTable.CharName then
  print("YOUR PICK!!!")
  QuickBeep()
end

-- For the first round of lotto, always check out the lottobot
local FirstPeek = TryAction("pinfo " .. lottobot, 600)
if FirstPeek then beep() end

-- Otherwise Check the lottobot when its almost our turn
if not FirstPeek then
  if not matches[4] and matches[3] == StatTable.CharName then
    tempTimer(1,function() send("pinfo " .. lottobot) end)
    return
  end

  if (matches[3] == StatTable.CharName or
      matches[4] == StatTable.CharName or
      matches[5] == StatTable.CharName or
      matches[6] == StatTable.CharName) then
    
    tempTimer(1,function() send("pinfo " .. lottobot) end)
  end
end
