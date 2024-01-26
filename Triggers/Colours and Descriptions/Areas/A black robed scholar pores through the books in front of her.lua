-- Trigger: A black robed scholar pores through the books in front of her. 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): A black robed scholar pores through the books in front of her.

-- Script Code:
cecho (string.rep (" ",85-tonumber(string.len(line))) .."<red> [FLASH] Scholar")