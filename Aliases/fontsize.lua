-- Alias: fontsize
-- Attribute: isActive

-- Pattern: ^fontsize (\d+)$

-- Script Code:

local fontsize = tonumber(matches[2])

assert(type(fontsize)=="number")

if fontsize < 6 or fontsize > 20 then
  print("Error! Fontsize must be between 6 and 20")
end

GlobalVar.FontSize = fontsize
SaveProfileVars()
LoadLayout()