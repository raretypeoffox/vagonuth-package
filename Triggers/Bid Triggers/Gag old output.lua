-- Trigger: Gag old output 
-- Attribute: isActive
-- Attribute: isMultiline


-- Trigger Patterns:
-- 0 (start of line):  ### |  Current Bid  | Time | Level |  Min Bid
-- 1 (start of line): ---------------------------------------------------------------------

-- Script Code:
moveCursor(0,getLineCount()-1)
deleteLine()
moveCursor(0,getLineCount())
deleteLine()