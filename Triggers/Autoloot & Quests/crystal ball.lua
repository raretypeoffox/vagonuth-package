-- Trigger: crystal ball 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): A clear ball of crystal stands here glowing softly.

-- Script Code:
if SafeArea() then return end

send("get crystal")

safeTempTrigger("GetCrystalBallID", "You get crystal ball.", function()
  if IsMDAY() then
    send("put 'crystal ball' " .. StaticVars.AllegBagName)
  else
    if GlobalVar.GroupLeader ~= StatTable.CharName then 
      send("give 'crystal ball' " .. GlobalVar.GroupLeader)
    end
  end
end, "begin", 1)

safeTempTrigger("GetCrystalBallMissedID", "I see no crystal here", function()
  safeKillTrigger("GetCrystalBallID")
  end, "begin", 1)


