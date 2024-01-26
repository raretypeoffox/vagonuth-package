-- Script: Battle.Spec
-- Attribute: isActive

-- Script Code:
Battle = Battle or {}

-- Called by Battle.OnLook when a known spec is called
function Battle.Spec(spec)
  assert(spec,"Battle.Spec() error: spec not provided")
  Battle.Stomper = false
  
  if spec == "spec_breath_fire" then
    if StatTable.Race == "Ignatur" then
      if not StatTable.RacialInnervate and not StatTable.RacialInnervateFatigue then
        TryAction("racial innervate", 30)
      end
    end
  elseif spec == "spec_breath_lightning" then
    if StatTable.Race == "Golem" then
      if not StatTable.RacialGalvanize and not StatTable.RacialGalvanizeFatigue then
        TryAction("racial galvanize", 30)
      end
    end
    
  elseif spec == "spec_stomp_em" then
    if Grouped() and not GlobalVar.Silent then TryAction("emote warns the party about |BR|STOMPERS|N| in the room!", 30) end
    if StatTable.Class == "Psionicist" then
      Battle.Stomper = true
    end    
  end -- end spec ifs
end


-- Interesting Specs
-- spec_stomp_em (stomper)
-- spec_breath_fire (ign proc)
-- spec_breath_gas (wind aoe from gale boss in arcanists)
-- spec_breath_frost - arcanists ice boss
-- spec_breath_lightning
-- spec_cast_stormlord (shatterspell the mob)
