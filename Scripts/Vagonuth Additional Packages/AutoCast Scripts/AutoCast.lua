-- Script: AutoCast
-- Attribute: isActive

-- Script Code:
function AutoCastON()
  GlobalVar.AutoCast = true
  AutoCastStatus()
  AutoCastSetGUI()
end

function AutoCastOFF()
  GlobalVar.AutoCast = false
  AutoCastStatus()
  AutoCastSetGUI()
end

function AutoCastSetSpell(spell)
  GlobalVar.AutoCaster = spell
  AutoCastStatus()
  AutoCastSetGUI()
end

function AutoCastStatus()
  --traceback()
  printMessage("AutoCast", "Currently " .. (GlobalVar.AutoCast and "<green>ON" or "<red>OFF"))
  if GlobalVar.AutoCaster and GlobalVar.AutoCaster ~= "" then printMessage("AutoCast", "Spell set to <yellow>" .. GlobalVar.AutoCaster) end
  printMessage("AutoCast", "Surge level set to " .. (GlobalVar.SurgeLevel == 1 and "<red>OFF" or "<yellow>" .. GlobalVar.SurgeLevel))
end



