-- Trigger: Group PreachUp Trigger 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): * tells the group 'preachup'
-- 1 (substring): * tells the group 'preach'
-- 2 (start of line): You tell the group 'preach'
-- 3 (start of line): You tell the group 'preachup'

-- Script Code:
if StatTable.Level == 125 and (StatTable.current_mana / StatTable.max_mana) < 0.95 and not IsMDAY() then
  beep()
  printGameMessage("Beep", "Preachup without full regen, stayed asleep")
  return
end


OnMobDeathQueueClear()
PreachUp()


 