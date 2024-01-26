-- Trigger: Final Rites Off 
-- Attribute: isActive
-- Attribute: isColorizerTrigger

-- mFgColor: #ffff00
-- mBgColour: #000000

-- Trigger Patterns:
-- 0 (regex): ^(.*) has been marked with final rites.

-- Script Code:
disableTrigger("Final Rites")
GlobalVar.VizFinalRites = true