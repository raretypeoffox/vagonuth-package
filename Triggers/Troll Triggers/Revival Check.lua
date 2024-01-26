-- Trigger: Revival Check 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^\*\w+\* tells the group 'revival check'$

-- Script Code:
if StatTable.RacialRevivalFatigue then
  send("gtell |BW|Revival |BY|EXHAUSTED: |BW|" .. StatTable.RacialRevivalFatigue .. " |N|ticks")
else
  send("gtell |BW|Revival |BY|Avaiable")
end
  