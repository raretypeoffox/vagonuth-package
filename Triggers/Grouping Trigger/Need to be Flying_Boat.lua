if StatTable.Class == "Berserker" then
  if not GlobalVar.Silent then send ("gtell I couldn't follow - |BR|flying down!|N|") end
else
  if not not GlobalVar.Silent then send ("gtell I couldn't follow - attempting to cast fly!") end
  local direction = matches[2]
     
  safeTempTrigger("YouFailedFly", "You failed your fly due to lack of concentration!", function() send("cast fly") end, "begin")
  safeTempTrigger("YourFeetRise", "Your feet rise off the ground.", function() safeKillTrigger("YouFailedFly"); send(direction) end, "begin", 1)
  safeTempTrigger("YouFollowedLeader", "You follow ", function() safeKillTrigger("YourFeetRise") end, "begin", 1)
  
  safeEventHandler("NeedToBeFlyingEventID", "OnQuit", function() safeKillTrigger("YouFailedFly"); safeKillTrigger("YourFeetRise") end, true)  
  send("cast fly")
    
    
end