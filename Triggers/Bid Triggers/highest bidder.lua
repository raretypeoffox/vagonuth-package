-- Trigger: highest bidder 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^ \s?\s?\s?(?<bid_id>\d+) \| .* \*You are the highest bidder\*

-- Script Code:
--print(matches.bid_id)