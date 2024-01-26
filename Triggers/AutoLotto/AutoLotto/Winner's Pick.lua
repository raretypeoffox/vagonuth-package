-- Trigger: Winner's Pick 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^\*?(\w+)\*? tells? the group '(\d+|pass)'$

-- Script Code:
if matches[2] == AutoLotto.LottoList[AutoLotto.PlayerPick] or matches[2] == "You" then
  print(matches[2], matches[3])
  AutoLotto.ProcessWinner(matches[3])
  return
end