-- Trigger: Dance Check 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^\*\w+\* tells the group '(d|st)ance check'$

-- Script Code:
local msg = ""

if StatTable.VeilTimer then
  msg = msg .. "Veil of Blades: |BW|" .. StatTable.VeilTimer .. "|N|"
elseif StatTable.InspireTimer then
  msg = msg .. "Inspiring Dance: |BW|" .. StatTable.InspireTimer .. "|N|"
elseif StatTable.UnendTimer then
  msg = msg .. "Undending Dance: |BW|" .. StatTable.UnendTimer .. "|N|"
elseif StatTable.BladedanceTimer then
  msg = msg .. "Bladedance: |BW|" .. StatTable.BladedanceTimer .. "|N|"
elseif StatTable.DervishTimer then
  msg = msg .. "Dervish Dance: |BW|" .. StatTable.DervishTimer .. "|N|"
end

if msg ~= "" and StatTable.Bladetrance then
  msg = msg .. " (Bladetrance: |BW|" .. StatTable.BladetranceLevel .. "|N|)"
elseif msg ~= "" and StatTable.BladetranceExhaust then
  msg = msg .. " (Bladetrance Exhausted: |BR|" .. StatTable.BladetranceExhaust .. "|N|)"
end

send("gtell " .. msg, false)

local exmsg = "|R|Exhausted: |N|"
local exmsg_status = false

if StatTable.VeilExhaust then
  exmsg = exmsg .. "Veil of Blades: |BW|" .. StatTable.VeilExhaust .. "|N| "
  exmsg_status = true
end
if StatTable.InspireExhaust then
  exmsg = exmsg .. "Inspiring Dance: |BW|" .. StatTable.InspireExhaust .. "|N| "
  exmsg_status = true
end
if StatTable.UnendExhaust then
  exmsg = exmsg .. "Undending Dance: |BW|" .. StatTable.UnendExhaust .. "|N| "
  exmsg_status = true
end
if StatTable.BladedanceExhaust then
  exmsg = exmsg .. "Bladedance: |BW|" .. StatTable.BladedanceExhaust .. "|N| "
  exmsg_status = true
end
if StatTable.DervishExhaust then
  exmsg = exmsg .. "Dervish Dance: |BW|" .. StatTable.DervishExhaust .. "|N| "
  exmsg_status = true
end

if exmsg_status then send("gtell " .. exmsg, false) end

