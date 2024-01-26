-- Alias: MobList Set

-- Pattern: ^mobset (\w+)$

-- Script Code:
if (MobListCoroutine == nil) then
  MobListCoroutine = coroutine.create(SetMobList)
  coroutine.resume(MobListCoroutine)
else
  MobListSetKeyword = matches[2]
  if not coroutine.resume(MobListCoroutine) then MobListCoroutine = nil end
end
  
  


  