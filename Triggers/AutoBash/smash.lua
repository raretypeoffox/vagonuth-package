-- Trigger: smash 


-- Trigger Patterns:
-- 0 (regex): ^Your attack
-- 1 (regex): ^Your attacks

-- Script Code:
if ( tonumber(gmcp.Char.Vitals.lag) <= 4
  and StatTable.Bash == "Down"
  and GlobalVar.AutoBash == true
  and StatTable.Level >= 25
  and StatTable.current_health >= StatTable.max_health * 0.5) then
    send("smash")
end