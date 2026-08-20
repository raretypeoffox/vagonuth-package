StatTable.Frenzy = nil

if GlobalVar.AutoFrenzy == false or SafeArea() then return end

if not (gmcp.Char.Status.area_name == "{ ALL  } AVATAR  Sanctum") then
  if StatTable.Class == "Berserker" and not GlobalVar.Silent then
    send("gtell frenzy")
  end
  if not GlobalVar.Silent then send("emote is no longer |BR|Enraged|N|.") end
end

