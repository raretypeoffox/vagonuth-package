-- Script: GMCP_OnlinePlayers
-- Attribute: isActive

-- Script Code:
GlobalVar = GlobalVar or {}
GlobalVar.OnlinePlayers = GlobalVar.OnlinePlayers or nil

function getOnlinePlayers()
    if not Connected() then return end
    if IsMDAY() then return end -- requesting Comm.Channel.Players doesn't work on mday, likely too many players online
    gmcp.Comm = gmcp.Comm or {}
    gmcp.Comm.Channel = gmcp.Comm.Channel or {}
    gmcp.Comm.Channel.Players = nil
    GlobalVar.OnlinePlayers = {}
    sendGMCP("Comm.Channel.Players")
    
    coroutine.wrap(function()
      local timeout = 0
      
      wait(1)
      
      while gmcp.Comm.Channel.Players == nil and timeout < 10 do
        sendGMCP("Comm.Channel.Players")
        wait(2)
        timeout = timeout + 1
      end
      
      if timeout >= 10 then
        pdebug("getOnlinePlayers() timed out")
        return
      end
           
      for i, player in ipairs(gmcp.Comm.Channel.Players) do
          GlobalVar.OnlinePlayers[player.name] = true
      end

    end)()
end