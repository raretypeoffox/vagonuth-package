if (StatTable.Position == "Sleep") then send("stand") end
if (StatTable.Level == 125 and not SafeArea()) then
    OnMobDeathWake()
end