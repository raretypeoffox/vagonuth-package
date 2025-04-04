-- Trigger: Epic Wizardry 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (exact): You have mastered epic wizardry!
-- 1 (exact): You have already mastered epic wizardry!

-- Script Code:
GlobalVar.SurgeLevel = 5
GlobalVar.AutoCaster = "signature spell"
GlobalVar.AutoCasterSingle = "signature spell"
GlobalVar.AutoCasterAOE = "inferno"
GlobalVar.QuickenStatus = false
cecho("\n")
AutoCastON()


