local args = matches[2] or ""
if StatTable.Class ~= "Necromancer" then
  printMessage("Abom", "This alias is only available to Necromancers.")
  return
end

if args:gsub("%s+", "") == "" then
  NecromancerGameLoop.ShowStatus()
  return
end

if args:lower():match("^off%s*$") then
  NecromancerGameLoop.DisablePlan()
  printMessage("Abom", "Abomination maintenance disabled.")
  return
end

local plan, err = NecromancerGameLoop.ParsePlan(args)
if not plan then
  showCmdSyntax("Abomination Maintenance\n\tSyntax: abom <type> <name> <max_weight> [weapon_keyword]", {
    {"abom skeleton Dizzy 15", "maintains skeletons named Dizzy up to total weight 15"},
    {"abom skeleton Dizzy 15 sword", "also gives sword to each matching weaponless skeleton"},
    {"abom bloated Dizzy 15", "maintains bloated abominations named Dizzy"},
    {"abom off", "disables abomination maintenance"},
  })
  printMessage("Abom", err)
  return
end

local ok, configureError = NecromancerGameLoop.Configure(plan)
if not ok then
  printMessage("Abom", configureError)
  return
end

NecromancerGameLoop.ShowStatus()
