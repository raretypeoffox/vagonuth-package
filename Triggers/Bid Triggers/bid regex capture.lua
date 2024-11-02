-- Trigger: bid regex capture 
-- Attribute: isActive
-- Attribute: isMultiline


-- Trigger Patterns:
-- 0 (regex): ^ \s?\s?\s?(?<bid_id>\d+) \| \s*(?<bid_current>[0-9,]*) \| \s?\s?\s?(?<bid_time>\d+) \| \s?\s?\s?\s?(?<bid_level>\d+) \| \s*(?<bid_min>[0-9,]*)\s?\|?\s?(?<bid_highest>\*You are the highest bidder\*)?(?<bid_posted>\*You are auctioning this item\*)?$
-- 1 (regex): ^     > (?<bid_itemname>.*)

-- Script Code:
--print()

moveCursor(0,getLineCount()-1)
deleteLine()
moveCursor(0,getLineCount())
deleteLine()

--print(multimatches[1].bid_id)
--print(multimatches[1].bid_current .. " / " .. string.gsub(multimatches[1].bid_current, ",", ""))
--print(tonumber(multimatches[1].bid_current))
--print(multimatches[1].bid_time)
--print(multimatches[1].bid_level)
--print(multimatches[1].bid_min)
--print(tonumber(multimatches[1].bid_min))
--if (multimatches[1].bid_highest~="") then print(multimatches[1].bid_highest) end
--print(multimatches[2].bid_itemname)

local bid_cur = string.gsub(multimatches[1].bid_current, ",", "")
local bid_min = string.gsub(multimatches[1].bid_min, ",", "")
bid_cur = tonumber(bid_cur)
bid_min = tonumber(bid_min)

local item_name = multimatches[2].bid_itemname

--print("bid_cur: " .. bid_cur .. " / bid_min: " .. bid_min)
--print(multimatches[1].bid_min .. " / " .. string.gsub(multimatches[1].bid_min, ",", "") .. "\n---\n")
--print(multimatches[1].bid_min .. " / " .. bid_min .. "\n---\n")
--print(string.gsub(multimatches[1].bid_min, ",", ""))


local time_desc = ""
local bid_time = math.floor(tonumber(multimatches[1].bid_time)*(118/125))
local time_mins = bid_time%60
if (bid_time > 60) then
  if time_mins < 10 then
    time_desc = math.floor(bid_time/60) .. ":0" .. time_mins
  else
    time_desc = math.floor(bid_time/60) .. ":" .. time_mins
  end
  if (bid_time < 60*10) then time_desc = " " .. time_desc end
else
  if time_mins < 10 then
    time_desc = "<hot_pink>00:0" .. time_mins
  else
    time_desc = "<hot_pink>00:" .. time_mins
  end
end


if (tonumber(multimatches[1].bid_level) >= 100) then
  item_name = "<light_slate_blue>" .. multimatches[2].bid_itemname
else
  item_name = "<white>" .. multimatches[2].bid_itemname
end 

if (multimatches[1].bid_highest~="") then
  item_name = item_name .. "\t<ansi_light_yellow>*HIGHEST BIDDER*"
end

if (multimatches[1].bid_posted~="") then
  item_name = item_name .. "\t<ansi_light_green>*YOU POSTED THIS ITEM*"
end



print("")
cecho("<yellow>(" .. multimatches[1].bid_id .. ")\t<ansiLightGreen>" .. time_desc .. "\t" .. item_name)
print("")

if (bid_cur >= bid_min) then
  cecho("\t\t<ansi_light_yellow>" .. multimatches[1].bid_current)
else
  cecho("\t\t<ansi_yellow>" .. multimatches[1].bid_min)
end
