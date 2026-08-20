--if not IsMDAY() then return end

if (IsGroupLeader(matches[2])) then
  tempTimer(1, function() send("enter portal") end)
end