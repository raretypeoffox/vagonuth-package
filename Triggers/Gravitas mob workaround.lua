-- Trigger: Gravitas mob workaround 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^(.*) surrounds \w+ with a telekinetic sink.$

-- Script Code:
if IsGroupMate(matches[2]) then return; end -- just a group mate casting gravitas

PSITrigger.GravitasMobs[matches[2]] = true

-- Mob has casted gravitas, alert user and swap to mind wipe
printGameMessage("Psi", "Telekinetic sink alert! " .. matches[2] .. " (swapped to mindwipe)", "red", "white")

if GlobalVar.AutoCaster ~= "mindwipe" then
  AutoCastSetSpell("mindwipe")
end

safeEventHandler("GravistasMobClearOnPreachup", "OnPreachUp", [[PSITrigger.GravitasMobs = {}]], true)
safeEventHandler("GravistasMobClearOnMyDeath", "OnMyDeath", [[PSITrigger.GravitasMobs = {}]], true)

