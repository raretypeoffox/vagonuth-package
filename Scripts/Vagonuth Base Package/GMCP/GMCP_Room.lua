-- Script: GMCP_Room
-- Attribute: isActive
-- GMCP_Room() called on the following events:
-- gmcp.Room.Info

-- Script Code:
function GMCP_Room() 
  if(GlobalVar.GUI) then
    RoomLabel:echo("<center>" .. RemoveColourCodes(gmcp.Room.Info.name) .. "</center>")
    ExitListLabel:echo("<center>" .. table.concat(table.keys(gmcp.Room.Info.exits), " ") .. "</center>")
    
    Victim1Label:hide()
    Victim2Label:hide()
    Victim3Label:hide()
    Victim1Label:setClickCallback("")
    Victim2Label:setClickCallback("")
    Victim3Label:setClickCallback("")
  end
 
end