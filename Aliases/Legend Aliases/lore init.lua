-- Alias: lore init
-- Attribute: isActive

-- Pattern: ^init$

-- Script Code:
if StatTable.Level ~= 250 then return end

-- tweak as desired

local lore_init_table = {
  "lore init",
  "lore basic war",
  "lore basic magic",
  "lore basic wiz", 
  "lore lesser war",
  "lore lesser wizardry",
  "cast genesis self",
  "lore greater wizardry",
  "lore epic wizardry",
  "lore basic psi",
  "lore basic theology",
  "lore greater war",
  "lore epic war",
  "lore basic empty hand",
  "wear all"
}

local send_str = ""

for _,lore in ipairs(lore_init_table) do
  send_str = send_str .. lore .. cs
end

send(send_str)