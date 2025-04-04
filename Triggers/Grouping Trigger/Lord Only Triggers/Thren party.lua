-- Trigger: Thren party 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^\[LORD INFO\]: (\w+) initiates a Threnody dirge for corpse of (\w+) in (.*)\.$

-- Script Code:

if GMCP_name(matches[2]) == StatTable.CharName then return end

if matches[4] == gmcp.Room.Info.name and GlobalVar.GroupMates[GMCP_name(matches[2])] then
  if not GroupLeader() and StatTable.Position == "Stand" and StatTable.Class ~= "Berserker" and StatTable.Class ~= "Vizier" and StatTable.current_mana > 150 and tonumber(gmcp.Char.Vitals.lag) == 0 then
    send("cast thren " .. matches[3])
  end
end


--GetSpellCostMod(type) -- what type is thren?? test later