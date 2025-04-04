-- Trigger: Basic Wizardry 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (exact): You have mastered basic wizardry!
-- 1 (exact): You have already mastered basic wizardry!

-- Script Code:
GlobalVar.SurgeLevel = 5
GlobalVar.AutoCaster = "fireball"
GlobalVar.AutoCasterSingle = "fireball"
GlobalVar.AutoCasterAOE = "acid blast"
GlobalVar.QuickenStatus = false
cecho("\n")
AutoCastON()

send("amplify on" .. cs .. "surge off" .. cs .. "quicken off")
if GlobalVar.Password then
  send("worship bhyss " .. GlobalVar.Password, false)
end
