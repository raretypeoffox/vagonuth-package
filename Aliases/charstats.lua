-- Alias: charstats
-- Attribute: isActive

-- Pattern: ^(?i)charstats (\w+)$

-- Script Code:
-- todo

local char_name = GMCP_name(matches[2])

if not AltList.Chars[char_name] then
  printMessage("Error", char_name .. " not found in your altlist")
  return
end

print(char_name)
print("Level:\t" .. AltList.Chars[char_name].Level .. " (" .. AltList.Chars[char_name].SubLevel .. ")" .. " " .. AltList.Chars[char_name].Race .. " " .. AltList.Chars[char_name].Class)
print("Max HP:\t" .. AltList.Chars[char_name].Max_HP)
print("Max Ma:\t" .. AltList.Chars[char_name].Max_MP)
print("AC:\t" .. AltList.Chars[char_name].ArmorClass)
print("HR/DR:\t" .. AltList.Chars[char_name].HitRoll .. " / " .. AltList.Chars[char_name].DamRoll)