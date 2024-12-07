-- Trigger: Force Field 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(.*) summons a force field to protect (it|him|her) from harm!$

-- Script Code:
local shatter_enemy = matches[2]

if IsGroupMate(shatter_enemy) then return end

printGameMessage("Forcefield", "Psi/Mnd to shatter " .. shatter_enemy)

if IsClass({"Psionicist","Mindbender"}) then
  if GlobalVar.AutoCast then
    safeTempTrigger("ShatterAlertID", shatter_enemy .. " is DEAD!!", function() AutoCastON() end, "begin", 1)
    AutoCastOFF()
  end
  local quicken = false
  if StatTable.current_mana > 10000 then send("quicken 5"); quicken = true end
  shatter_enemy = string.lower(shatter_enemy)
  shatter_enemy = " " .. shatter_enemy .. " "
  shatter_enemy = string.gsub(shatter_enemy, " of ", " ")
  shatter_enemy = string.gsub(shatter_enemy, " the ", " ")
  shatter_enemy = string.gsub(shatter_enemy, " with ", " ")
  shatter_enemy = string.gsub(shatter_enemy, "A ", " ")
  shatter_enemy = string.gsub(shatter_enemy, " a ", " ")
  shatter_enemy = string.gsub(shatter_enemy, '^%s*(.-)%s*$', '%1')
  send("cast shatterspell " .. shatter_enemy)
  if quicken then send("quicken off") end
  
end
