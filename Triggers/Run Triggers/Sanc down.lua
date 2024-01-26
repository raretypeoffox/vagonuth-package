-- Trigger: Sanc down 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): The protective aura fades from around your body.
-- 1 (start of line): Your Iron Monk style fades.

-- Script Code:
-- Rewrite 28 Aug 2023

AutoCross = AutoCross or false

function KillSancSelfAtLordTimer()
  safeKillTimer("SancSelfAtLord")
end

if AutoCross then send("cross"); return end

-- Function that waits till you're not fighting to cast sanctuary (will cast immediately if out of combat)
local function CastAfterCombat(spell)
  if not Battle.Combat and tonumber(gmcp.Char.Vitals.lag) == 0 and StatTable.Position ~= "Sleep" then
    send("cast " .. spell)
  else
    OnMobDeathQueuePriority("cast " .. spell)
  end
end

-- Function to sanc self at lord only if we don't receive sanc after 30 seconds
function SancSelfAtLord()
  if StatTable.Class == "Berserker" or StatTable.Class == "Sorcerer" then return end

  safeTempTimer("SancSelfAtLord", 30, function()
  safeEventHandler("SancSelfAtLordEventID", "OnQuit", "KillSancSelfAtLordTimer", true)
    if not StatTable.Sanctuary then
      if StatTable.Class == "Monk" or StatTable.Class == "Shadowfist" then
        CastAfterCombat("'iron monk'")
      else
        CastAfterCombat("sanctuary")
      end
    end
  end)

end

if SafeArea() then return end
if not StatTable.Fortitude and StatTable.Level < 125 then return end

if not GlobalVar.Silent then send("emote is no longer in |BW|Sanctuary|N|.",false) end

-- At Lord, if we're a Priest, we'll preach sanc, otherwise we'll let someone us sanc us
if StatTable.Level == 125 then
  -- We'll sanc ourselves if we're at Lord unless we don't receive it after 30 seconds
  if StatTable.Class ~= "Priest" then SancSelfAtLord(); return end

  -- If we're a Priest, we'll preach sanc (though we need to be at least Lord 25 to do so)
  if StatTable.SubLevel < 25 or not Grouped() then return end

  if Battle.Combat and not StatTable.Solitude then
    send("quicken 9" .. getCommandSeparator() .. "cast inno" .. getCommandSeparator() .. "quicken off")
  end
  send("preach sanc")
  return
else -- Hero and Low mort

  -- If we're a Monk or Shadowfist, we'll use iron Monk (though we need to be at least Level 30 to do so)
  if (StatTable.Class == "Monk" or StatTable.Class == "Shadowfist") and StatTable.Level >= 30 then CastAfterCombat("'iron monk'"); return; end

  -- Cleric, Priest, Druid, and Vizier can use sanctuary at low mort
  if (StatTable.Class == "Cleric" or StatTable.Class == "Priest" or StatTable.Class == "Druid" or StatTable.Class == "Vizier") 
     and StatTable.Level >=23 then CastAfterCombat("sanctuary"); return; end
  
  -- Everyone else gets sanc at Hero 45
  if StatTable.Level == 125 or StatTable.SubLevel >= 45 then CastAfterCombat("sanctuary"); return; end

  -- We aren't able to cast sanc on ourselves, ask for sanc
  if not GlobalVar.Silent and Grouped() then send("gtell |BW|Sanctuary|N| is down - please sanc me",false) end
end