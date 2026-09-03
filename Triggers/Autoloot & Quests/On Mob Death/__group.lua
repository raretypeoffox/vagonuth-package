if GlobalVar.GroupMates[GMCP_name(matches[2])] == nil then -- name not in grouplist, either a mob or a non-groupmate's death

  if not StatTable.Monitor and Grouped() and not GroupLeader() then
    TryAction("monitor " .. GlobalVar.GroupLeader, 30)
  elseif (StatTable.Class == "Vizier" and GlobalVar.VizMonitor ~= "" and string.lower(GlobalVar.VizMonitor) ~= string.lower(StatTable.Monitor)) then
    send("monitor " .. GlobalVar.VizMonitor)
  end

  raiseEvent("OnMobDeath")
  
  if (GlobalVar.GUI) then
    Victim1Label:hide()
    Victim2Label:hide()
    Victim3Label:hide()
    Victim1Label:setClickCallback("")
    Victim2Label:setClickCallback("")
    Victim3Label:setClickCallback("")
  end


end

