-- Alias: showdirs
-- Attribute: isActive

-- Pattern: ^(i?)showdirs?$

-- Script Code:
if #GlobalVar.LastDirs == 0 then
  printMessage("Directions" ,"No directions to report")
end
ShowDirs()