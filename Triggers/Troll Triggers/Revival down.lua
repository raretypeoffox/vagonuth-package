-- Trigger: Revival down 
-- Attribute: isActive
-- Attribute: isMultiline


-- Trigger Patterns:
-- 0 (start of line): The revival of your body slows down.

-- Script Code:
if not GlobalVar.Silent then send("gtell |BW|Revival|N| is |BY|DOWN|N|") end