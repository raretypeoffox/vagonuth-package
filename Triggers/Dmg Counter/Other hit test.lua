-- Trigger: Other hit test 


-- Trigger Patterns:
-- 0 (regex): ^(?<attacker>.*)'s attacks? strikes? (?<victim>.*) (\d+) times?, with (?<dmgdesc>.*) \w+(!|.)
-- 1 (regex): ^(?<attacker>.*)'s attacks haven't hurt (?<victim>\w+)!

-- Script Code:
-- config setup:
--[-battleother] You will see others' hits condensed to one line.
--[-battleself ] You will see your hits condensed to one line.
--[-battlenone ] You will see other players' hits.


print("\n" .. matches.attacker .. " hits " .. matches.victim)
