-- Trigger: gt ablut 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (exact): ablut

-- Script Code:
send("cast ablut")

safeTempTrigger("AblutRetry", "You failed your ablution due to lack of concentration!", [[send("cast ablut")]], "begin")