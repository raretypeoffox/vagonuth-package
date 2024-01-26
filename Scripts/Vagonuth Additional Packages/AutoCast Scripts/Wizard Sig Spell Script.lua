-- Script: Wizard Sig Spell Script
-- Attribute: isActive

-- Script Code:
-- Example of insigs
--    Signature Spell
--     Signature spell target: area. Damage type: cold.
--    Signature Spell
--     Signature spell target: single. Damage type: arcane.

function LookUpSignatureSpell()
  if not StatTable.CharName or StatTable.Class ~= "Wizard" or StatTable.Level < 125 or StatTable.SubLevel < 300 then return nil end
  
  for k,v in ipairs(AltList.Chars[StatTable.CharName].Insigs) do
    if v == "Signature Spell" then
      local target, damageType = AltList.Chars[StatTable.CharName].Insigs[k+1]:match("Signature spell target: (%a+). Damage type: (%a+).")
      return target, damageType
    end
  end

  send("insig", false)
  return nil
end

function WizardSigSpellInit()
  local target, damageType = LookUpSignatureSpell()
  
  if not target then return; end
  
  if target == "single" then
    GlobalVar.AutoCasterSingle = "signature spell"
    AutoCastSetSpell(GlobalVar.AutoCasterSingle)
  elseif target == "area" then
    GlobalVar.AutoCasterAOE = "signature spell"
  end
end



safeEventHandler("WizardSigSpellInit", "CustomProfileInit", "WizardSigSpellInit", false)


-- misc wizard (wzd) notes

-- ether link down
-- You no are no longer linked to others through the Ether.
-- ether warp down
-- You no longer warp the Ether around you.