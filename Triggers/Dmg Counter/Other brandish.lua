-- Trigger: Other brandish 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(\w+) brandishes

-- Script Code:
local CharName = GMCP_name(matches[2])

if GlobalVar.GroupMates[CharName] then
  DamageCounter.AddBrandish(CharName)
end