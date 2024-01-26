-- Trigger: Connecting to AVATAR 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): Existing Character.

-- Script Code:
if (tonumber(gmcp.Char.Status.level) == 125) then
  safeTempTimer("ConfigSavespellOnLogin", 8,[[send("config -savespell")]])
else
  safeTempTimer("ConfigSavespellOnLogin", 8,[[send("config +savespell")]])
end
 
safeTempTrigger("SetSaveSpell", "Ok, your savespell is now set to", function() safeKillTimer("ConfigSavespellOnLogin") end, "begin", 1) -- kills the timer if we manually set our savespell

safeEventHandler("KillSafeSpellIfRelog", "sysDisconnectionEvent", function() safeKillTimer("ConfigSavespellOnLogin") end, true)


 