-- Trigger: Please hit enter to continue 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (start of line): Please hit enter to continue
-- 1 (start of line): Please press <enter> to continue
-- 2 (start of line): When you have read this, please press <RETURN> to continue ---->
-- 3 (exact): ************************************************************************
-- 4 (start of line): |()()()()()()()()()()( Press <enter> to continue. )()()()()()()()()()()|
-- 5 (start of line): |()()()()()()()()()( Press <enter> to continue. )()()()()()()()()()()()|
-- 6 (start of line):  |()()()()()()()()()( Press <enter> to continue. )()()()()()()()()()()()|

-- Script Code:
send("look")
tempTimer(1,[[send("look")]])