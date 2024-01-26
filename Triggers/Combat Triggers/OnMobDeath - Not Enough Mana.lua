-- Trigger: OnMobDeath - Not Enough Mana 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^You do not have enough mana to cast (.*).

-- Script Code:
if splitstring(MobDeath.LastCommand, " ")[2] == matches[2] then
  pdebug("OnMobDeath(): Not enough mana to " .. MobDeath.LastCommand .. " - won't attempt to recast")
  MobDeath.LastCommand = ""
elseif (string.match(MobDeath.LastCommand, [['([^']+)]]) == matches[2]) then
  pdebug("OnMobDeath(): Not enough mana to " .. MobDeath.LastCommand .. " - won't attempt to recast")
  MobDeath.LastCommand = "" 
end