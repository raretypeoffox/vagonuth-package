if GlobalVar.Password then
  send(GlobalVar.Password, false)
  tempTimer(0.5, [[send("\n")]])
  tempTimer(0.7, [[send("look")]])
  
end

