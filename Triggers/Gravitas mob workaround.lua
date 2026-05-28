-- Trigger: Gravitas mob workaround 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(.*) surrounds \w+ with a telekinetic sink.$

-- Script Code:
--if IsGroupMate(matches[2]) or gmcp.Room.Players(GMCP_name(matches[2])) then return; end -- just a group mate casting gravitas

if IsGroupMate(matches[2]) then return; end -- just a group mate casting gravitas
if SafeArea() then return end

PSITrigger.GravitasMobs = PSITrigger.GravitasMobs or {}
PSITrigger.GravitasMobs[matches[2]] = true

-- Mob has casted gravitas, alert user and swap to mind wipe
printGameMessage("Psi", "Telekinetic sink alert! " .. matches[2] .. " (swapped to mindwipe)", "red", "white")

if GlobalVar.AutoCaster ~= "mindwipe" then
  AutoCastSetSpell("mindwipe")
end


safeEventHandler("GravistasMobClearOnPreachup", "OnPreachUp", function() PSITrigger.GravitasMobs = {} end, true)
safeEventHandler("GravistasMobClearOnMyDeath", "OnMyDeath", function () PSITrigger.GravitasMobs = {} end, true)

