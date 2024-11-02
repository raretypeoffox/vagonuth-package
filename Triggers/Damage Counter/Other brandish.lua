-- Trigger: Other brandish 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(\w+) brandishes
-- 1 (regex): ^(\w+)'s .* brandishes itself all of its own!

-- Script Code:
local CharName = GMCP_name(matches[2])

if GlobalVar.GroupMates[CharName] then
  DamageCounter.AddBrandish(CharName)
end