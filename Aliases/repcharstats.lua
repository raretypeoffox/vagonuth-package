-- Alias: repcharstats
-- Attribute: isActive

-- Pattern: ^(?i)repcharstats (\w+) (.*)$

-- Script Code:
-- todo

local char_name = GMCP_name(matches[2])
local chat_type = matches[3]

if not AltList.Chars[char_name] then
  printMessage("Error", char_name .. " not found in your altlist")
  return
end

if AltList.Chars[char_name].Level >= 51 then
  level_msg = (AltList.Chars[char_name].Level == 51) and "Hero " or "Lord "
  level_msg = level_msg .. AltList.Chars[char_name].SubLevel .. ": "
else
  level_msg = "Level " .. AltList.Chars[char_name].Level .. ": "
end
  

send(chat_type .. 
    " Stats for |BW|" .. 
    char_name .. "|N| " .. 
    level_msg ..
    AltList.Chars[char_name].Max_HP .. "hp / " .. 
    AltList.Chars[char_name].Max_MP .. "mp")
