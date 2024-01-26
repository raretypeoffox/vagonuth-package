-- Trigger: Xp Runes 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): the fae rune for '(Blood|Misfortune|Silence|Apathy|Ice|Vengeance|Entropy|Charm|Wrath|Power|Regeneration|Fatigue|Chaos|Obfuscation|Influence|Corruption|Darkness|Drought|Fear)'

-- Script Code:
local xpvalue = 300

if matches[2] == "Chaos" or matches[2] == "Obfuscation" then
  xpvalue = 400
elseif matches[2] == "Power" or matches[2] == "Wrath" then
  xpvalue = 250
elseif matches[2] == "Influence" or matches[2] == "Corruption" then
  xpvalue = 200
elseif matches[2] == "Misfortune" or matches[2] == "Blood" or matches[2] == "Silence" or matches[2] == "Apathy" or matches[2] == "Ice" or matches[2] == "Vengeance" then
  xpvalue = 100
end

cecho (string.rep (" ",80-tonumber(string.len(line))) .. "<green> [" .. xpvalue .. "XP Rune]")