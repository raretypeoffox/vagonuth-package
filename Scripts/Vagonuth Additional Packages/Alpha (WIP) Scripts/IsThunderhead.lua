-- Script: IsThunderhead
-- Attribute: isActive

-- Script Code:
local ThunderheadLastState = false

local function itemIsThunderhead(item)
  return type(item) == "table" and item.name == "a thunderhead"
end

function UpdateThunderheadFromAdd()
  local items = gmcp and gmcp.Char and gmcp.Char.Items
  if type(items) ~= "table" then return ThunderheadLastState end

  local add = items.Add
  if type(add) == "table" and add.location == "room" and itemIsThunderhead(add.item) then
    ThunderheadLastState = true
  end

  return ThunderheadLastState
end

function UpdateThunderheadFromList()
  local items = gmcp and gmcp.Char and gmcp.Char.Items
  if type(items) ~= "table" then return ThunderheadLastState end

  local list = items.List
  if type(list) ~= "table" or list.location ~= "room" then return ThunderheadLastState end

  ThunderheadLastState = false

  if type(list.items) == "table" then
    for _, item in pairs(list.items) do
      if itemIsThunderhead(item) then
        ThunderheadLastState = true
        break
      end
    end
  end

  return ThunderheadLastState
end

function UpdateThunderheadFromRemove()
  local items = gmcp and gmcp.Char and gmcp.Char.Items
  if type(items) ~= "table" then return ThunderheadLastState end

  local remove = items.Remove
  if type(remove) == "table" and remove.location == "room" and itemIsThunderhead(remove.item) then
    ThunderheadLastState = false
  end

  return ThunderheadLastState
end

function IsThunderhead()
  return ThunderheadLastState
end

safeEventHandler("IsThunderheadFromAdd", "gmcp.Char.Items.Add", "UpdateThunderheadFromAdd", false)
safeEventHandler("IsThunderheadFromList", "gmcp.Char.Items.List", "UpdateThunderheadFromList", false)
safeEventHandler("IsThunderheadFromRemove", "gmcp.Char.Items.Remove", "UpdateThunderheadFromRemove", false)
