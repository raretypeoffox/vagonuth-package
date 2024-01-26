-- Trigger: Soul Shackle 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (substring): has some big nasty wounds and scratches.
-- 1 (substring): looks pretty hurt.
-- 2 (substring): is in awful condition.

-- Script Code:
if StatTable.StanceSoulExhaust then return end
if not GlobalVar.VizFinalRites then return end

local HP_Percent = StatTable.current_health / StatTable.max_health

local function CastSoulShackle_HPCheck(healthThreshold)
    if HP_Percent > healthThreshold and (StatTable.InjuredCount > 1 or StatTable.CriticalInjured > 0) then
        TryCast("cast 'soul shackle'" .. getCommandSeparator() .. "stance soul",2)
        GlobalVar.VizSoulShackle = true
    end
end

local function AbortSoulStance_OnLowHealth(healthThreshold)
    if HP_Percent < healthThreshold then
        send("stance neutral")
        GlobalVar.VizSoulShackle = false
    end
end

if matches[1] == "has some big nasty wounds and scratches." then
    if not GlobalVar.VizSoulShackle then CastSoulShackle_HPCheck(0.8) else AbortSoulStance_OnLowHealth(0.2) end
elseif matches[1] == "looks pretty hurt." then
    if not GlobalVar.VizSoulShackle then CastSoulShackle_HPCheck(0.7) else AbortSoulStance_OnLowHealth(0.1) end
elseif matches[1] == "is in awful condition." then
    if not GlobalVar.VizSoulShackle then CastSoulShackle_HPCheck(0.6) else AbortSoulStance_OnLowHealth(0.05) end
end



--Old code before refactoring into above, test above then delete below:

-- local HP_percent = StatTable.current_health / StatTable.max_health

-- if GlobalVar.VizFinalRites and not GlobalVar.VizSoulShackle and not StatTable.StanceSoulExhaust and (StatTable.InjuredCount > 1 or StatTable.CriticalInjured > 0) then
--   if matches[1] == "has some big nasty wounds and scratches." then
--     if HP_percent > 0.8 then
--       TryCast("cast 'soul shackle'" .. getCommandSeparator() .. "stance soul",2)
--       GlobalVar.VizSoulShackle = true
--     end
--   elseif matches[2] == "looks pretty hurt." then
--     if HP_percent > 0.7 then
--       TryCast("cast 'soul shackle'" .. getCommandSeparator() .. "stance soul",2)
--       GlobalVar.VizSoulShackle = true
--     end
--   elseif matches[2] == "is in awful condition." then    
--     if HP_percent > 0.6 then
--       TryCast("cast 'soul shackle'" .. getCommandSeparator() .. "stance soul",2)
--       GlobalVar.VizSoulShackle = true
--     end  
--   end


-- elseif GlobalVar.VizSoulShackle and not StatTable.StanceSoulExhaust then
--   -- If we get too low of life, abort!
--   if matches[1] == "has some big nasty wounds and scratches." then
--     if HP_percent < 0.2 then
--       send("stance neutral")
--       GlobalVar.VizSoulShackle = false
--     end
--   elseif matches[2] == "looks pretty hurt." then
--     if HP_percent < 0.1 then
--       send("stance neutral")
--       GlobalVar.VizSoulShackle = false
--     end
--   elseif matches[2] == "is in awful condition." then    
--     if HP_percent < 0.05 then
--       send("stance neutral")
--       GlobalVar.VizSoulShackle = false
--     end   
--   end
-- end

