-- Trigger: AutoGurney on Shift 
-- Attribute: isMultiline


-- Trigger Patterns:
-- 0 (lua function): if(GlobalVar.AutoGurney ~= "") then return true end
-- 1 (regex): ^\[LORD INFO\]: (\w+) has just shifted to (.*)!

-- Script Code:
if (string.lower(multimatches[2][2]) == string.lower(GlobalVar.AutoGurney)) then
  send("cast gurney " .. GlobalVar.AutoGurney)
  GlobalVar.AutoGurney = ""  
end
