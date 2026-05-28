-- Trigger: AutoRescue - Fyr rescues groupmate 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(\w+) rescues \w+!

-- Script Code:
local groupmate = GlobalVar and GlobalVar.GroupMates and GlobalVar.GroupMates[GMCP_name(matches[2])]

if groupmate and groupmate.class == "Fyr" then
  AR.FyrRescue(matches[2])
end