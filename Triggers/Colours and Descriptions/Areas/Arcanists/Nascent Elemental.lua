-- Trigger: Nascent Elemental 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): This small pool of acid licks at the rock hungrily.
-- 1 (substring): Flickering and leaping, these flames look around for more fuel.
-- 2 (substring): This rock moves of its own will, hither and yon.
-- 3 (substring): A tiny spark zaps from one crystal to the next, building its charge.
-- 4 (substring): This breeze twirls about playfully.
-- 5 (substring): This clump of snowflakes drifts silently about.
-- 6 (substring): This rivulet of water trickles across the ground, gathering droplets.

-- Script Code:
cecho (string.rep (" ",85-tonumber(string.len(line))) .."<white> Nascent")