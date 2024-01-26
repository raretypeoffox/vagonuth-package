-- Alias: chaos-look
-- Attribute: isActive

-- Pattern: ^(lookdirs|ldirs)$

-- Script Code:
local dirs = {}

tmpDirTrigger = tempRegexTrigger("^(North|South|East|West|Up|Down)", function() 
  table.insert(dirs, matches[2])
  if #dirs == 12 then
    local string = ""

    for i = 1, 12 do
      string = string .. string.lower(string.sub(dirs[i],1,1))
      if i ~= 12 then string = string .. "," end
    end
    
    send("gtell Dirs: " .. string)
  end
end, 12)

for i = 1, 12 do
  send("look direction" .. i)
end

-- You look at the white tablet here...
-- North


--tempRegexTrigger("^(North|South|East|West|Up|Down)", function() print(matches[2]) end, 2)