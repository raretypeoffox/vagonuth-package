-- Trigger: Revival available 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): You feel less fatigued. (revival)

-- Script Code:
if not GlobalVar.Silent then send("emote |BW| REVIVAL |W|available|N|") end