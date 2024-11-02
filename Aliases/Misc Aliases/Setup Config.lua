-- Alias: Setup Config
-- Attribute: isActive

-- Pattern: ^(?i)setup$

-- Script Code:
local NewCharSetup = {
"alias ul unlock %1:open %1",
"alias wowo open wooden:get all wooden:drop wooden:sac wooden:inspect lockbox",
"pagelength 50",
"config -battleother",
"config -battleself",
"config -battlenone",
"config +demonbank",
"config +blind",
"config +label",
"config +condition",
"config +autogroup",
"info +all",
"chan +all",
}

local LordSetup = {
"",
}

local count = 0

coroutine.wrap(function()
  
  local count = 0
  for i,v in ipairs(NewCharSetup) do
    count = count + 1
    if count % 48 == 0 then wait(1) end 
    send(v,false) 
  end

  if (StatTable.Level == 125) then 
    for i,v in ipairs(LordSetup) do
      count = count + 1
      if count % 48 == 0 then wait(1) end  
      send(v,false) 
    end 
  end
  
end)()

