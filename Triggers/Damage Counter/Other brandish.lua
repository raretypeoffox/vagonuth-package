local CharName = GMCP_name(matches[2])

if GlobalVar.GroupMates[CharName] then
  DamageCounter.AddBrandish(CharName)
end