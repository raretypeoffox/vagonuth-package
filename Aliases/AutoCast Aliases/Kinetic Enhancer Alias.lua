-- Alias: Kinetic Enhancer Alias
-- Attribute: isActive

-- Pattern: ^(?i)kin(?: (.*))?$

-- Script Code:
local args = (matches[2] or ""):lower()

if args == "" then
    showCmdSyntax("Kinetic Enhancers\n\tSyntax: kin <spell> <spell>", {
    {"kin <spell> <spell>", "Sets the Psi kinetic enhancer spells to autocast"},
    {"kin clear", "Clears the kinetic enhancer spells previously set"},
    })
    if GlobalVar.KineticEnhancerOne then
      printMessage("Kinetic Enhancer One", "Spell currently set to: <yellow>" .. GlobalVar.KineticEnhancerOne)
    end
        if GlobalVar.KineticEnhancerTwo then
      printMessage("Kinetic Enhancer Two", "Spell currently set to: <yellow>" .. GlobalVar.KineticEnhancerTwo)
    end
elseif StatTable.Class ~= "Psionicist" then
  printMessage("Kinetic Enhancer", "Only Psionicists can cast kinetic enhancers")
elseif args == "clear" then
  printMessage("Kinetic Enhancers", "Spells cleared")
  GlobalVar.KineticEnhancerOne = nil
  GlobalVar.KineticEnhancerTwo = nil
else
  local arg1, arg2 = splitArgumentIntoTwo(args)
  if arg1 == nil then
    printMessage("Kinetic Enhancer error", "Please specify one or two spells")
    return
  end
  GlobalVar.KineticEnhancerOne = arg1
  GlobalVar.KineticEnhancerTwo = arg2
  
  if GlobalVar.KineticEnhancerOne then
    printMessage("Kinetic Enhancer One", "Spell set to: <yellow>" .. GlobalVar.KineticEnhancerOne)
  end
  
  if GlobalVar.KineticEnhancerTwo then
    printMessage("Kinetic Enhancer Two", "Spell set to: <yellow>" .. GlobalVar.KineticEnhancerTwo)
  end
end

--^(?i)(kinetic|kin) ?(.*)?$
