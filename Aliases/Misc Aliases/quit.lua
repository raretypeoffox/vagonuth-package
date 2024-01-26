-- Alias: quit
-- Attribute: isActive

-- Pattern: ^quit$

-- Script Code:
--if GlobalVar.WelcomeTimer then
--  killTimer(GlobalVar.WelcomeTimer)
--  GlobalVar.WelcomeTimer = nil
--end

--AltList.LoginName = nil
--InventoryList.LoginName = nil


raiseEvent("OnQuit")
send("quit",false)