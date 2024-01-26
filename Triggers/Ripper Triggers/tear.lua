-- Trigger: tear 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(?<mobname>.*) is DEAD!!

-- Script Code:
local TearExclusions = {
"chimerical griffon",
"gith lookout",
"rock wyrm mother",
"inferno dragon",
"ancient mindflayer"
}

if StatTable.TearExhaust then
  return
end

if StatTable.HandOfGod and GroupLeader() then
  return
end

if GlobalVar.GroupMates[matches.mobname] then
  return -- groupmate died
end

-- Make sure we have enough weight to loot corpse in case it wasn't looted
if (StatTable.MaxWeight - StatTable.Weight) < 100 then
  return
end


if not ArrayHasSubstring(TearExclusions, string.lower(matches.mobname)) then
  if StatTable.Level == 125 and StatTable.ArmorClass < -2000 then
  -- hack: if AC less than -2000, we are most likely not using our claws, can't tear
    TryAction("get all corpse" .. getCommandSeparator() .. "actear", 30)
  else
    TryAction("get all corpse" ..  getCommandSeparator() .. "tear corpse", 30)
  end
end


