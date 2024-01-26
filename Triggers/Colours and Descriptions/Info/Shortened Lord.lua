-- Trigger: Shortened Lord 
-- Attribute: isActive
-- Attribute: isColorizerTrigger

-- mFgColor: #ff5500
-- mBgColour: #000000

-- Trigger Patterns:
-- 0 (regex): ^The shadow of Lord
-- 1 (regex): ^The shadow of Lady

-- Script Code:
selectString("The shadow of ", 1)
setBgColor(getBgColor())
setFgColor(getFgColor())
replace()