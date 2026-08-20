if (GlobalVar.PrayerName ~= "") then
  OnMobDeathQueue("cast prayer '" .. GlobalVar.PrayerName .. "'")
end