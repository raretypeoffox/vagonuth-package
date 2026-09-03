
if StaticVars.LootBagName then
  send("put " .. GlobalVar.AutoViolateItem .. " " .. StaticVars.LootBagName)
else
  send("drop " .. GlobalVar.AutoViolateItem)
end
send("cast violation " .. GlobalVar.AutoViolateItem)