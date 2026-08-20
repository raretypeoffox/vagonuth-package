if splitstring(MobDeath.LastCommand, " ")[2] == matches[2] then
  pdebug("OnMobDeath(): Not enough mana to " .. MobDeath.LastCommand .. " - won't attempt to recast")
  MobDeath.LastCommand = ""
elseif (string.match(MobDeath.LastCommand, [['([^']+)]]) == matches[2]) then
  pdebug("OnMobDeath(): Not enough mana to " .. MobDeath.LastCommand .. " - won't attempt to recast")
  MobDeath.LastCommand = "" 
end