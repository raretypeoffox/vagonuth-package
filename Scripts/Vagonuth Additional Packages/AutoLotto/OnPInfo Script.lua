-- Script: OnPInfo Script
-- Attribute: isActive

-- Script Code:
OnPInfo = OnPInfo or {}
OnPInfo.isOpen = OnPInfo.isOpen or false
OnPInfo.len = OnPInfo.len or 0
OnPInfo.PInfoArray = OnPInfo.PInfoArray or {}
OnPInfoBackup = OnPInfoBackup or {}
OnPInfo.Lock = OnPInfo.Lock or false

OnPInfo.PromptPattern = "^(.*)<(%d+)/(%d+)hp (%d+)/(%d+)ma (%d+)v (%d+)> (%d+)"


function OnPInfo.Save()
  local location = getMudletHomeDir() .. "/OnPInfoBackup.lua"
  table.save(location, OnPInfoBackup)
end

function OnPInfo.Load()
  local location = getMudletHomeDir() .. "/OnPInfoBackup.lua"
  if io.exists(location) then
    table.load(location, OnPInfoBackup)
  end
end

if TableSize(OnPInfoBackup) == 0 then OnPInfo.Load() end

-- Note: if you're using a prompt that is not the standard prompt from setup, you'll need to edit this line so that this regex matches your prompt (test at regex101.com)
function OnPInfo.IsPrompt(line)
    return string.match(line, OnPInfo.PromptPattern) ~= nil
end

function OnPInfo.ArrayAddLine(line)
  if OnPInfo.Lock then return end
  
  table.insert(OnPInfo.PInfoArray,line)
end

function OnPInfo.ArrayFinish()
  if OnPInfo.Lock then return end
  
  table.remove(OnPInfo.PInfoArray,1) -- remove's first line, i.e., Your playerinfo is:
  table.remove(OnPInfo.PInfoArray, #OnPInfo.PInfoArray) -- removes last line (empty line, before the prompt)
  
  OnPInfoBackup[StatTable.CharName] = deepcopy(OnPInfo.PInfoArray)
  OnPInfo.Save()
  
  OnPInfo.Lock = true
end

function OnPInfo.Clear()
  if not OnPInfo.Lock then
    pdebug("OnPInfo.Clear(): didn't clear, OnPInfo.Lock is false")
    return
  end
  send("pinfo clear", false)
end

function OnPInfo.Write()
  for index, pinfo_line in ipairs(OnPInfo.PInfoArray) do
    send("pinfo + " .. pinfo_line, false)
  end
  OnPInfo.Lock = false
end