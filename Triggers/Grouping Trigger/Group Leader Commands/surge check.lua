-- Trigger: surge check 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (exact): surge check

-- Script Code:
if not GlobalVar.AutoCast then return end
if GlobalVar.Silent then return end

if GlobalVar.SurgeLevel == 1 then
  send("gtell Surge off")
  return
end

local colour_code = "|BW|"

if GlobalVar.SurgeLevel == 3 then
  colour_code = "|BY|"
elseif GlobalVar.SurgeLevel == 4 then
  colour_code = "|BR|"
elseif GlobalVar.SurgeLevel == 5 then
  colour_code = "|BP|"
end

send("gtell Surge level: " .. colour_code .. GlobalVar.SurgeLevel .. "|N|")

