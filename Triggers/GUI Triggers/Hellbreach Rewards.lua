-- Trigger: Hellbreach Rewards 
-- Attribute: isActive
-- Attribute: isMultiline


-- Trigger Patterns:
-- 0 (regex): ^The amulet evaporates (.*)$
-- 1 (regex): ^You have received:? (.*)$

-- Script Code:

--cecho("GroupChat","<yellow><b>" .. multimatches[2][1] .. "\n")

printGameMessage("AutoLotto!", "You received " .. multimatches[2][2], "yellow", "white")

--
--The amulet evaporates in a marvelous puff of smoke!$You have received an award of 5 quest points!
--The amulet evaporates in a marvelous puff of smoke!$You have received: a perfect ruby! 