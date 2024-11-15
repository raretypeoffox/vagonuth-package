-- Alias: brandish
-- Attribute: isActive

-- Pattern: ^(?i)bra(?: (\w+)? ?(\w+)?)?$

-- Script Code:
GlobalVar = GlobalVar or {}

-- old pattern
-- ^bra ?(\w*)? ?(\w*)?
-- if (matches[1] == "brandish") then send("brandish",false) return end

-- Defaults
GlobalVar.BrandishStaff = GlobalVar.BrandishStaff or "staff"
GlobalVar.BrandishArmor = GlobalVar.BrandishArmor or "seal"
GlobalVar.BrandishCharges = GlobalVar.BrandishCharges or 0


local cmd_name = "Brandish Management System\n\tSyntax: bra (command) (arg)"

local syntax_tbl = {
  {"bra","will equip/unequip staff and brandish, won't brandish past 1 charge"},
  {nil,"Note: use 'brandish' to overide"},
  {nil,nil},
  {"bra staff <staffname>","sets staff you'll brandish"},
  {"bra armor <armorname>","sets held armor slot that you'll wear after brandishing"},
  {"bra charges <#>","set the number of brandish charges"},
  {"bra show", "shows number of charges left"},
}


if (matches[2] == "" or matches[2] == nil) then -- 0 args provided
  if (GlobalVar.BrandishStaff == "") then
    print("Brandish Error: please set staff")
    print("Note: can be overridden by typing brandish")
    print("")
    showCmdSyntax(cmd_name, syntax_tbl)
  elseif (GlobalVar.BrandishArmor == "") then
    print("Brandish Error: please set armor")
    print("Note: can be overridden by typing brandish")
    print("")
    showCmdSyntax(cmd_name, syntax_tbl)
  else
    if (GlobalVar.BrandishCharges <= 1) then
      send("Brandish Error: only 1 charge left, switch staffes")
      print("Note: can be overridden by typing brandish")
      print("")
      showCmdSyntax(cmd_name, syntax_tbl)
    else
      GlobalVar.BrandishCharges = GlobalVar.BrandishCharges - 1
      print("Brandish! Charges left: " .. GlobalVar.BrandishCharges)
      
      
      local brandish_action = "wear " .. GlobalVar.BrandishStaff .. getCommandSeparator() .. "brandish " .. GlobalVar.BrandishStaff .. getCommandSeparator() .. "wear " .. GlobalVar.BrandishArmor
      
      --if (type(Battle.Interupt) == "function") then Battle.Interupt(brandish_action, 10) else send(brandish_action) end
      if (type(Battle.NextAct) == "function") then Battle.NextAct(brandish_action, 10) else send(brandish_action) end

      
    end
  end  
elseif (matches[3] == "" or matches[3] == nil) then -- 1 arg provided
  if (matches[2] == "show") then
    print("Charges left: " .. GlobalVar.BrandishCharges)
  else
    showCmdSyntax(cmd_name, syntax_tbl)
  end 
else -- 2+ args provided
  if (matches[2] == "staff") then
    GlobalVar.BrandishStaff = matches[3]
    print("Brandish: staff set to " .. matches[3])
  elseif (matches[2] == "armor") then
    GlobalVar.BrandishArmor = matches[3]
    print("Brandish: armor set to " .. matches[3])
  elseif (matches[2] == "charges") then
    GlobalVar.BrandishCharges = tonumber(matches[3])
    print("Brandish: charges set to " .. matches[3])
  else
    showCmdSyntax(cmd_name, syntax_tbl)
  end  
  
end