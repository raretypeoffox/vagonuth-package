-- Trigger: On My Death Trigger 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): You have been KILLED!!
-- 1 (start of line): Black imps appear and kill you!

-- Script Code:
-- TODO check the room name first

OnMobDeathQueueClear()
beep()
safeCall(ClearGurneyTriggers)

local function cloud2sanc()
  send("down")
  send("sanctum")
  send("down")
  send("west")
  AskBotsForHeals()
  send("sleep")
  
  if (StatTable.Class == "Priest") then
    if (gmcp.Room.Players["Martyr"]~=nil) then send("tell martyr full")
    elseif (gmcp.Room.Players["Arby"]~=nil) then send("tell arby full")
    elseif (gmcp.Room.Players["Yorrick"]~=nil) then send("tell yorrick split")
    elseif (gmcp.Room.Players["Idle"]~=nil) then send("tell idle split")
    end
    
    if (gmcp.Room.Players["Neodox"]~=nil) then send("tell neodox steel")
    else send("tell neodox mid" .. getCommandSeparator() .. "tell neodox steel") end  
    
  end

end

local function whereami()
  TryLook()
  display(gmcp.Room.Info)
  
  if (gmcp.Room.Info.name == "On a Cloud" and gmcp.Room.Info.zone == "{ 1   4} Crom    The Meadow") then cloud2sanc() end


end

if (StatTable.Level < 125) then
  send("wake")
  TryLook()
  tempTimer(1, function() whereami() end)

 elseif (StatTable.Level == 125) then
  send("wake")
  
  TryLook()
  display(gmcp.Room.Info)
  
  
  send("down")
  send("east")
  send("east")
  AskBotsForHeals()  
  send("sleep")
  
  
  
 end
 
safeTempTimer("ReqBotRequest", 60 * 10, function() send("tell kano req " .. StatTable.CharName); send("tell alrin req " .. StatTable.CharName); end)
-- using gmcp.Char.Status.character_name incase character logged in with non-standard capitalization
safeTempTrigger("LootedCorpse", "You get (.*) from corpse of " .. gmcp.Char.Status.character_name .. ".", function() safeKillTimer("ReqBotRequest") end, "regex", 1)
safeEventHandler("QuitAfterReq", "OnQuit", function() safeKillTimer("ReqBotRequest") end, true)

raiseEvent("OnMyDeath")