-- Trigger: Larval Elemental 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): Fuming steadily, this sizzling elemental devours more rock.
-- 1 (substring): This shard of ice clings to the wall, ready to lacerate someone.
-- 2 (substring): This bonfire dashes about, lapping at the stones hungrily.
-- 3 (substring): This boulder shudders and shakes. It's alive!
-- 4 (substring): An arc of energy crackles, happily absorbing smaller sparks.
-- 5 (substring): Gusting here and there, this air this air elemental grows slowly.
-- 6 (substring): This jet of water splashes to and fro gleefully.

-- Script Code:
cecho (string.rep (" ",85-tonumber(string.len(line))) .."<yellow> Larval")