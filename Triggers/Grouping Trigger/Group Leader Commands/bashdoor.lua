if StatTable.Level < 250 and IsClass({"Sorcerer", "Soldier", "Priest", "Assassin", "Wizard", "Druid", "Vizier"}) then return end -- these classes don't have bashdoor

TryAction("bashdoor " .. matches[2], 5)