-- Alias: AutoRevive
-- Attribute: isActive

-- Pattern: ^autorevive ?(on|off|\d+)?

-- Script Code:
if (matches[2] == "on") then 
  GlobalVar.AutoRevive = true
  print("AutoRevive ON: will auto revive at " .. math.floor(StatTable.max_health * GlobalVar.AutoReviveHPpct) .. "hp (" .. GlobalVar.AutoReviveHPpct .. "%)")
elseif (matches[2] == "off") then
  GlobalVar.AutoRevive = false
  print("AutoRevive OFF")
elseif (matches[2] ~= nil and tonumber(matches[2]) > 0 and tonumber(matches[2])<100) then
  GlobalVar.AutoReviveHPpct = tonumber(matches[2]) / 100
  print("AutoRevive: will auto revive at " .. math.floor(StatTable.max_health * GlobalVar.AutoReviveHPpct) .. "hp (" .. GlobalVar.AutoReviveHPpct * 100 .. "%)")
else
  print("AutoRevive is " .. (GlobalVar.AutoRevive and "ON" or "OFF"))
  print("AutoRevive will automatically activate 'racial revive' on Trolls if you're spelled and your HP falls below " ..  GlobalVar.AutoReviveHPpct * 100 .. "%")
  print("syntax: autorevive <on|off|#>")
  
end
  
  