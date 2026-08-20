if not StatTable.Fortitude then return end

TryAction("cast 'ether link'",5)

OnMobDeathQueue("cast 'ether link'")