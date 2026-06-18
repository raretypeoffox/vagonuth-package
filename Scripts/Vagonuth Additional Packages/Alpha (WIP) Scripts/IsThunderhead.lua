-- Script: IsThunderhead
-- Attribute: isActive

-- Script Code:
local ThunderheadLastState = false

local function itemIsThunderhead(item)
  return type(item) == "table" and item.name == "a thunderhead"
end

function IsThunderhead()
  local items = gmcp and gmcp.Char and gmcp.Char.Items
  if type(items) ~= "table" then return ThunderheadLastState end

  local list = items.List
  if type(list) == "table" and list.location == "room" then
    ThunderheadLastState = false

    if type(list.items) == "table" then
      for _, item in pairs(list.items) do
        if itemIsThunderhead(item) then
          ThunderheadLastState = true
          break
        end
      end
    end
  end

  local add = items.Add
  if type(add) == "table" and add.location == "room" and itemIsThunderhead(add.item) then
    ThunderheadLastState = true
  end

  return ThunderheadLastState
end
