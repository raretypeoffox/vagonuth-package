-- Trigger: feared 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^You consider rescuing (w+), but chicken out!

-- Script Code:
local rescue_target_feared = matches[2]
if not GlobalVar.Silent then TryAction("gtell |BW|Feared!|N| couldn't rescue " .. rescue_target_feared .. "!", 30) end