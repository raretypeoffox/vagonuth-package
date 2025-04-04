-- Script: GMCP_Room
-- Attribute: isActive
-- GMCP_Room() called on the following events:
-- gmcp.Room.Info

-- Script Code:
function GMCP_Room() 
  GlobalVar.PlaneName = GetPlaneName()
  if(GlobalVar.GUI) then
    RoomLabel:echo("<center>" .. RemoveColourCodes(gmcp.Room.Info.name) .. " (" .. GlobalVar.PlaneName .. ")</center>")
    ExitListLabel:echo("<center>" .. table.concat(table.keys(gmcp.Room.Info.exits), " ") .. "</center>")
    
    Victim1Label:hide()
    Victim2Label:hide()
    Victim3Label:hide()
    Victim1Label:setClickCallback("")
    Victim2Label:setClickCallback("")
    Victim3Label:setClickCallback("")
    
    if GlobalVar.RoomBlockedCasting then
      AutoCastON()
      GlobalVar.RoomBlockedCasting = nil
    end
  end
  
  
 
end


safeTempTrigger("RoomBlocksSpellCasting", "This room blocks your mind from spellcasting!", function()
  if GlobalVar.AutoCast then
    AutoCastOFF()
    GlobalVar.RoomBlockedCasting = true
   end
end, "begin")