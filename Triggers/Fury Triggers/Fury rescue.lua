-- Provides for an alternative method of rescue healing
-- Benefit: when multiple mobs are fighting group, this trigger is able to detect if the mob we specifically are fighting (ie gmcp.Char.Status.opponent_name)
--          is only attacking one groupmate and if so, to rescue the groupmate when the mob is low
-- Con:     works less reliably when using skills with lag as it goes off of the look command

local my_curr_hp = tonumber(StatTable.current_health) or 0
    local my_max_hp = tonumber(StatTable.max_health) or 0

    -- Lord (Level 125) HP gates depending on mob health status
    if StatTable.Level == 125 then
      if matches[1] == "has some big nasty wounds and scratches." and my_curr_hp < 40000 then return end
      if matches[1] == "looks pretty hurt." and my_curr_hp < 20000 then return end
    end

    if not GlobalVar.FuryRescue then return end
    if not StatTable.Wildmind then return end
    if my_max_hp <= 0 then return end

    -- Set rescue hp % levels for rescuing with sanc vs without
    local my_hp_pct = my_curr_hp / my_max_hp
    if StatTable.Sanctuary then
      if my_hp_pct < 0.50 then return end
    else
      if my_hp_pct < 0.75 then return end
    end

    local opponent = gmcp and gmcp.Char and gmcp.Char.Status and gmcp.Char.Status.opponent_name
    if not opponent or opponent == "" then return end
    local target = string.lower(opponent)

    if not Battle or not Battle.EnemiesAttacking or not Battle.GroupiesUnderAttack then return end

    local count = 0
    local index = nil
    for i, j in pairs(Battle.EnemiesAttacking) do
      if j and j[1] and string.lower(j[1]) == target then
        count = count + 1
        index = i
      end
    end

    -- Only one mob of this name so we can accurately determine who it is attacking (Lowmort, Hero, or Lord)
    if count == 1 and StatTable.Level <= 125 and index then
      local rescuetarget = Battle.EnemiesAttacking[index][2]
      if not rescuetarget then return end

      local rescue_key = GMCP_name(rescuetarget)
      local my_name = GMCP_name(StatTable.CharName)

      -- Is this the only mob attacking our rescue target? Also make sure we're not the rescue target
      if Battle.GroupiesUnderAttack[rescuetarget] == 1 and rescue_key ~= my_name then
        local my_lag = tonumber(gmcp and gmcp.Char and gmcp.Char.Vitals and gmcp.Char.Vitals.lag) or 99
        local my_attackers = tonumber(Battle.GroupiesUnderAttack[StatTable.CharName]) or 0

        -- Are we in a position to rescue?
        if my_lag <= 2 and my_attackers == 0 then
          local groupmate = GlobalVar.GroupMates and GlobalVar.GroupMates[rescue_key]
          if not groupmate then return end

          local groupmate_hp = tonumber(groupmate.hp)
          local groupmate_maxhp = tonumber(groupmate.maxhp)
          local berserker_ready = groupmate.class ~= "Bzk" or
            (groupmate_hp and groupmate_maxhp and groupmate_maxhp > 0 and (groupmate_hp / groupmate_maxhp) >= 0.95)

          if groupmate.class ~= "Pal" and groupmate.class ~= "Fyr" and berserker_ready then
            TryAction("r " .. rescuetarget, 2)
            TryFunction("printFuryRescue", printMessage, {"Fury Rescue!", "Trying to rescue " .. rescuetarget}, 2)
          end
        end
      end
    end