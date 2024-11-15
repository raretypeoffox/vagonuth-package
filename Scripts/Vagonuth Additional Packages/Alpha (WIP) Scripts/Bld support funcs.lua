-- Script: Bld support funcs
-- Attribute: isActive

-- Script Code:
          
function BldDanceCheck()
  if StatTable.Class ~= "Bladedancer" then return "NotBld", -1 end
  if StatTable.InspireTimer then
    return "Inspire", StatTable.InspireTimer
  elseif StatTable.BladedanceTimer then
    return "Bladedance", StatTable.BladedanceTimer
  elseif StatTable.DervishTimer then
    return "Dervish", StatTable.DervishTimer
  elseif StatTable.VeilTimer then
    return "Veil", StatTable.VeilTimer
  elseif StatTable.UnendTimer then
    return "Unend", StatTable.UnendTimer
  else
    return "NotDance", -1
  end
end

function BldDancing()
  local dance, _ = BldDanceCheck()
  if dance == "NotDance" then
    return false
  else
    return true
  end
end

function BldTest()
  dance, timer = BldDanceCheck()
  print(dance,timer)
  if dance == "Inspire" then print("inspire is up!") end
end