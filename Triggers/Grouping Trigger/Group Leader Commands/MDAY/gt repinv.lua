local freeItems = tonumber(string.sub(gmcp.Char.Vitals.string, -3)) - tonumber(gmcp.Char.Vitals.items)
local freeWeight = tonumber(gmcp.Char.Vitals.maxwgt) - tonumber(gmcp.Char.Vitals.wgt)

if freeWeight < 100 then
  send("gtell Only " .. freeWeight .. " lbs left!")
end

if freeItems < 10 then
  send("gtell Only " .. freeItems .. " items left!")
end

