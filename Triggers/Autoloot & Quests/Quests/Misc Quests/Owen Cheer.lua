GlobalVar.OwenCheer = GlobalVar.OwenCheer or 0
GlobalVar.OwenCheer = GlobalVar.OwenCheer + 1

cecho (string.rep (" ",55-tonumber(string.len(line))) .."<white>[ " .. GlobalVar.OwenCheer .. " ]")



safeEventHandler("ResetOwenCounterID", "CustomProfileInit", function() GlobalVar.OwenCheer = 0 end, true)
