-- Trigger: Lightning strike 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): a length of chain and an anchor
-- 1 (substring): a long, crystal shaft
-- 2 (substring): (White Aura) Clawing at his own flesh, this gnome craves blood.
-- 3 (substring): (White Aura) Snarling like a wild animal, this gnome comes right for you.

-- Script Code:
cecho (string.rep (" ",65-tonumber(string.len(line))) .."<yellow> [Lightning Strike]")