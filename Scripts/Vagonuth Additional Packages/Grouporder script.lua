-- Script: Grouporder script
-- Attribute: isActive

-- Script Code:
-- Class priorities
local priorityGroups = {
    { classes = { "War", "Bod", "Bzk", "Rip", "Mon", "Bld", "Shf" }, sortBy = "maxhp" },
    { classes = { "Rog", "Asn", "Bci", "Arc", "Sld", "Fus" }, sortBy = "maxhp" },
    { classes = { "Mag", "Wzd", "Stm", "Sor", "Psi", "Mnd" }, sortBy = "maxmp" },
}

-- table.indexof function to find an index of a value in a table
function table.indexof(t, value)
    for k, v in ipairs(t) do
        if v == value then return k end
    end
    return nil
end

local function sortGroupMembers(a, b)
    local aPriority, bPriority = nil, nil
    local aSortBy, bSortBy = nil, nil

    for idx, group in ipairs(priorityGroups) do
        if table.indexof(group.classes, a.class) then
            aPriority = idx
            aSortBy = group.sortBy
        end

        if table.indexof(group.classes, b.class) then
            bPriority = idx
            bSortBy = group.sortBy
        end
    end

    if aPriority and bPriority then
        if aPriority == bPriority then
            return tonumber(a[aSortBy]) > tonumber(b[bSortBy])
        else
            return aPriority < bPriority
        end
    elseif aPriority then
        return true
    elseif bPriority then
        return false
    else
        return tonumber(a.maxmp) > tonumber(b.maxmp)
    end
end

function GroupOrder()
  if not Grouped() or not GroupLeader() then return end
  if not gmcp or not gmcp.Char or not gmcp.Char.Group or not gmcp.Char.Group.List then error("GroupOrder(): no data in gmcp.Char.Group.List") end
  
  local sortedMembers = {}
  local finalcmd = ""
  
  for i, member in ipairs(gmcp.Char.Group.List) do
      table.insert(sortedMembers, member)
  end
  
  table.sort(sortedMembers, sortGroupMembers)
  
  for i = #sortedMembers, 1, -1 do
      local member = sortedMembers[i]
      if GMCP_name(member.name) == StatTable.CharName then
        if #sortedMembers == i then 
          finalcmd = "grouporder " .. StatTable.CharName .. " front"
        else
          finalcmd = "grouporder " .. StatTable.CharName .. " after " .. sortedMembers[i+1].name
        end
      else 
        send("grouporder " .. member.name .. " front")
      end
  end
  send(finalcmd)
end