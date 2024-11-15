-- Trigger: Connecting to AVATAR 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): Existing Character.

-- Script Code:
local function set_save_spell(wait)
  local wait = wait or 8
  if not gmcp.Char or gmcp.Char.Status or not gmcp.Char.Status.level then return end
  if (tonumber(gmcp.Char.Status.level) == 125) then
    safeTempTimer("ConfigSavespellOnLogin", wait,[[send("config -savespell")]])
  else
    safeTempTimer("ConfigSavespellOnLogin", wait,[[send("config +savespell")]])
  end
  
  --safeTempTrigger("SetSaveSpell", "Ok, your savespell is now set to", function() safeKillTimer("ConfigSavespellOnLogin") end, "begin", 1) -- kills the timer if we manually set our savespell 
  safeEventHandler("KillSafeSpellIfRelog", "sysDisconnectionEvent", function() safeKillTimer("ConfigSavespellOnLogin") end, true)
end

-- on very first login, gmcp.Char won't be set, wait 5 seconds before trying
if not gmcp.Char or not gmcp.Char.Status then 
  safeTempTimer("SetSaveSpellDelayed", 5, set_save_spell())
else
  set_save_spell()
end

safeTempTrigger("SetSaveSpell", "Ok, your savespell is now set to", function() safeKillTimer("ConfigSavespellOnLogin"); safeKillTimer("SetSaveSpellDelayed"); end, "begin", 1) -- kills the timer if we manually set our savespell 
  
  



 