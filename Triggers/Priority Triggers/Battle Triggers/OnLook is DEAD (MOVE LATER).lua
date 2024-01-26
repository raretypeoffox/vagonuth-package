-- Trigger: OnLook is DEAD (MOVE LATER) 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(.*) is DEAD!!$

-- Script Code:
target = string.lower(matches[2])



if not IsGroupMate(target) then
  local count = 0
  local index = nil
  local allmobsonone = false
  for i, j in pairs(Battle.EnemiesAttacking) do
    if j[1] == target then 
      count = count + 1
      
      -- a bit of a hack, but if there's more than one mob with the same name and they're all attacking the same player, we can safely
      -- remove it from Battle.EnemiesAttacking even though we maybe be remove the wrong "numbered" mob name (i.e. Player[k].name)
      if (count > 1) then
        if (j[2] == Battle.EnemiesAttacking[index][2]) then 
            allmobsonone = true
        else
            allmobsonone = false
        end
      end
       
      index = i
    end
  end
  if count > 1 then
    Battle.MobCount = Battle.MobCount - 1
    if allmobsonone then
    --  print("allmobsonone")
      Battle.GroupiesUnderAttack[Battle.EnemiesAttacking[index][2]] = Battle.GroupiesUnderAttack[Battle.EnemiesAttacking[index][2]] - 1
      Battle.EnemiesAttacking[index] = nil -- we don't actually know if this is the right "numbered" name so we'll issue a look after anyways 
    else
       -- print("duplicate mob name attacking more than one player")
    end
    TryLook()
  elseif count == 1 then
    Battle.GroupiesUnderAttack[Battle.EnemiesAttacking[index][2]] = Battle.GroupiesUnderAttack[Battle.EnemiesAttacking[index][2]] - 1 
    Battle.EnemiesAttacking[index] = nil
    Battle.MobCount = Battle.MobCount - 1
  else
    --print("not our mob")
  end
 -- print("OnLook is DeaD:")
 -- TableShow(Battle.GroupiesUnderAttack)
 -- TableShow(Battle.EnemiesAttacking)
 -- print("Battle.MobCount = " .. Battle.MobCount)

end





  

