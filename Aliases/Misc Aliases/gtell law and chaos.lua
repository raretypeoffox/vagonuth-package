-- Alias: gtell law and chaos
-- Attribute: isActive

-- Pattern: ^gt-(law|chaos)$

-- Script Code:
if matches[2] == "law" then
  send("gtell (Law) |BY|a orderly dragon scale (x2)|N|: |BW|5 QP|N|, turn into gnome at thorngate")
  send("gtell (Law) |BY|yet another dragon scale|N|: give to alleg for credit towards |BW|alleg insignia|N|")
else
  send("gtell (Chaos) |BY|bound chaos|N|: |BW|manifest base reroll|N| ie give this to gnome on thorn + your lord manifest to reroll the base")
  send("gtell (Chaos) |BY|an exceptionally useless trinket|N|: |BW|+1 to all 5 stats|N| insignia - turn into Alleg then kneel")
  send("gtell (Chaos) |BY|ever changing junk|N|: fulfills Alleg's request for the day")
  send("gtell (Chaos, not every run) |BW|living bow|N|: 10/100 negate failure to divine, 5/100 halve divine spell, 40 hr m15x")
  send("gtell (Chaos, not every run) |BW|chaos club|N|: 20/100 negated failure to all spells")
  send("gtell (Chaos, not every run) |BW|chaos wand|N|: 5/100 reduce lag all spells")
end
