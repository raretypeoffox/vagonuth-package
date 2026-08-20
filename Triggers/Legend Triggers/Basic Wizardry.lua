GlobalVar.SurgeLevel = 5
GlobalVar.AutoCaster = "fireball"
GlobalVar.AutoCasterSingle = "fireball"
GlobalVar.AutoCasterAOE = "acid blast"
GlobalVar.QuickenStatus = false
cecho("\n")
AutoCastON()

send("amplify on" .. cs .. "surge off" .. cs .. "quicken off")
if GlobalVar.Password then
  send("worship shizaga " .. GlobalVar.Password, false)
end
