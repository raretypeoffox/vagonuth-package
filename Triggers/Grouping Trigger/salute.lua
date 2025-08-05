-- Trigger: salute 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^\*?\w+\*? tells the group 'salute'$

-- Script Code:
-- do salute
if gmcp.Room.Info.name == "The Gleaming Hall" then
  math.randomseed(os.time())

  -- pick a real number in [0,3)
  tempTimer(math.random() * 3, function() TryAction("salute", 1) end)


end