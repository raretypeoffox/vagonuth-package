-- Script: GMCP_Vitals
-- Attribute: isActive
-- GMCP_Vitals() called on the following events:
-- gmcp.Char.Vitals
-- gmcp.Char.Status

-- Script Code:
-------------------------------------------------
--         GMCP Update for Status and Vitals   --
-------------------------------------------------

-- AffectsLookup Table
-- Adding new affects to StatTable, e.g, StatTable.Sanctuary, is as easy as adding another entry to AffectsLookup
-- e.g., ["Spell: sanctuary"] = "Sanctuary",
-- you can find the correct spell name by typing "lua gmcp.Char.Status.affects" in game

StatTable = StatTable or {}
StatTable.BladetranceLevel = StatTable.BladetranceLevel or 0

local AffectsLookup = {
  ["Spell: sneak"] = "Sneak",
  ["Spell: shadow form"] = "Sneak",
  ["Spell: move hidden"] = "MoveHidden",
  ["Spell: invis"] = "Invis",
  ["Spell: improved invis"] = "Invis",
  ["Spell: water breathing"] = "WaterBreathing",
  ["Spell: sanctuary"] = "Sanctuary",
  ["Spell: iron monk"] = "Sanctuary",
  ["Spell: fortitudes"] = "Fortitude",
  ["Spell: foci"] = "Foci",
  ["Spell: invincibility"] = "Invincibility",
  ["Spell: barkskin"] = "Barkskin",
  ["Spell: steel skeleton"] = "SteelSkeleton",
  ["Spell: iron skin"] = "IronSkin",
  ["Spell: frenzy"] = "Frenzy",
  ["Spell: awen"] = "Awen",
  ["Spell: aegis"] = "Awen",
  ["Spell: holy aura"] = "HolyAura",
  ["Spell: concentrate"] = "Concentrate",
  ["Spell: werrebocler"] = "Werrebocler",
  ["Spell: endurance"] = "Endurance",
  ["Spell: acumen"] = "Acumen",
  ["Spell: savvy"] = "Savvy",
  ["Spell: mystical barrier"] = "Mystical",
  ["Spell: alertness"] = "Alertness",
  ["Spell: intervention"] = "Intervention",
  ["Spell: blind devotion"] = "BlindDevotion",
  ["Spell: consummation"] = "Consummation",
  ["Spell: solitude"] = "Solitude",
  ["Spell: protection good"] = "ProtectionGood",
  ["Spell: protection evil"] = "ProtectionEvil",
  
  ["Exhausted Spell: solitude"] = "SolitudeTimer",
  ["Exhausted Spell: square"] = "SquareExhaust",
  ["Exhausted Spell: echelon"] = "EchelonExhaust",
  ["Exhausted Spell: phalanx"] = "PhalanxExhaust",
  ["Exhausted Spell: column"] = "ColumnExhaust",
  ["Exhausted Spell: intervention"] = "InterventionExhaust",
  ["Spell: square"] = "StanceSquare",
  ["Spell: echelon"] = "StanceEchelon",
  ["Spell: phalanx"] = "StancePhalanx",
  ["Spell: column"] = "StanceColumn",
  
  ["Spell: ether link"] = "EtherLink",
  ["Spell: ether warp"] = "EtherWarp",
  --["Spell: ether crash"] = "EtherCrash",
  ["Exhausted Spell: ether link"] = "EtherLinkExhaust",
  ["Exhausted Spell: ether warp"] = "EtherWarpExhaust",
  --["Exhausted Spell: ether crash"] = "EtherCrashExhaust",
  
  ["Spell: spring rain"] = "SpringRain",
  ["Spell: dark embrace"] = "DarkEmbrace",
  ["Spell: blizzard"] = "Blizzard",
  ["Spell: gale stratum"] = "GaleStratum",
  ["Exhausted Spell: water breathing"] = "WaterBreathingExhaust",
  ["Exhausted Spell: giant strength"] = "GiantStrengthExhaust",
  ["Exhausted Spell: fly"] = "FlyExhaust",
  
  -- bladedancer
  ["Spell: bladedance"] = "BladedanceTimer",
  ["Spell: dervish dance"] = "DervishTimer",  
  ["Spell: inspiring dance"] = "InspireTimer",
  ["Spell: unending dance"] = "UnendTimer",
  ["Spell: veil of blades"] = "VeilTimer",
  ["Spell: bladetrance"] = "Bladetrance",
  ["Exhausted Spell: bladetrance"] = "BladetranceExhaust",
  ["Exhausted Spell: bladedance"] = "BladedanceExhaust",
  ["Exhausted Spell: dervish dance"] = "DervishExhaust",
  ["Exhausted Spell: inspiring dance"] = "InspireExhaust",
  ["Exhausted Spell: unending dance"] = "UnendExhaust",
  ["Exhausted Spell: veil of blades"] = "VeilExhaust",
  ["Spell: iron veil"] = "IronVeil",
  ["Spell: furious rampage"] = "Rampage",
  
  -- cleric
  ["Spell: artificer blessing"] = "ArtificerBlessing",
  ["Spell: artificer blessing aura"] = "ArtificerBlessingAura", 
  ["Spell: discordia"] = "Discordia",
  ["Spell: divine adjutant"] = "DivineAdjutant",
  ["Spell: divine grace"] = "DivineGrace",
  ["Spell: glorious conquest"] = "GloriousConquest",
  ["Spell: grim harvest"] = "GrimHarvest",
  ["Spell: grim harvest aura"] = "GrimHarvestAura",
  ["Spell: hallowed nimbus"] = "HallowedNimbus",
  ["Spell: protective vigil"] = "ProtectiveVigil",
  ["Spell: sylvan benediction"] = "SylvanBenediction",
  ["Spell: unholy rampage"] = "UnholyRampage",  
  ["Spell: unholy rampage aura"] = "UnholyRampageAura", 
    
  ["Spell: saving grace"] = "SavingGrace",
  ["Spell: death shroud"] = "DeathShroud",
  ["Spell: defiled flesh"]= "DefiledFlesh",
  ["Spell: vile philosophy"] = "VilePhilosophy",
  ["Spell: summon necrit"] = "SummonNecrit",
  ["Spell: immolation"] = "Immolation",
  ["Spell: astral prison"] = "AstralPrison",
  ["Exhausted Spell: tainted genius"] = "TaintedExhaust",
  ["Exhausted Spell: unholy bargain"] = "UnholyBargainExhaust",
  ["Exhausted Spell: brimstone"] = "BrimstoneExhaust",
  ["Exhausted Spell: emotive drain"] = "EmotiveDrainExhaust",
  
  ["Spell: regeneration"]  = "Regeneration",
  ["Spell: protective stance"] = "StanceProtective",
  ["Exhausted Spell: protective stance"] = "StanceProtectiveExhaust",
  ["Spell: surefoot stance"] = "StanceSurefoot",
  ["Exhausted Spell: surefoot stance"] = "StanceSurefootExhaust",  
  ["Spell: relentless stance"] = "StanceRelentless",
  ["Exhausted Spell: relentless stance"] = "StanceRelentlessExhaust",
  ["Exhausted Spell: soul stance"] = "StanceSoulExhaust",
  ["Spell: rally"] = "Rally",
  ["Spell: tear"] = "Tear",
  ["Exhausted Spell: tear"] = "TearExhaust",
  ["Spell: fervor"] = "Fervor",
  ["Spell: prayer"] = "Prayer",
  ["Spell: holy zeal"] = "HolyZeal",
  ["Spell: joined boon"] = "JoinedBoon",
  ["Spell: heroic boon"] = "HeroicBoon",
  ["Spell: shared boon"] = "SharedBoon",
  ["Spell: valorous boon"] = "ValorousBoon",
  ["Spell: final boon"] = "FinalBoon",
  
  -- monk / shf
  ["Spell: bear stance"] = "BearStance",
  ["Spell: emu stance"] = "EmuStance",
  ["Spell: tiger stance"] = "TigerStance",
  ["Exhausted Spell: bear stance"] = "BearStanceExhaust",
  ["Exhausted Spell: emu stance"] = "EmuStanceExhaust",
  ["Exhausted Spell: tiger stance"] = "TigerStanceExhaust",
  ["Exhausted Spell: vampire fang"] = "VampireFangExhaust",
  ["Exhausted Spell: spectral fang"] = "SpectralFangExhaust",
  ["Spell: vampire fang"] = "VampireFang",
  ["Spell: spectral fang"] = "SpectralFang",
  ["Spell: dagger hand"] = "DaggerHand",
  ["Spell: stone fist"] = "StoneFist",
  ["Spell: flow like water"] = "FlowLikeWater",
  ["Exhausted Spell: flow like water"] = "FlowLikeWaterExhaust",
  ["Spell: burning fury"] = "BurningFury",
  ["Exhausted Spell: burning fury"] = "BurningFuryExhaust",

  
  
  
  -- Psi's / Mnd's
  ["Spell: kinetic chain"] = "KineticChain",
  ["Exhausted Spell: kinetic chain"] = "KineticChainExhaust",
  ["Spell: gravitas"] = "Gravitas",
  ["Exhausted Spell: gravitas"] = "GravitasExhaust",
  ["Spell: fury of the mind"] = "FuryOfTheMind",
  ["Spell: minds eye"] = "MindsEye",
  ["Spell: stunning weapon"] = "StunningWeapon",
  ["Spell: distracting weapon"] = "DistractingWeapon",
  ["Spell: disabling weapon"] = "DisablingWeapon",
  ["Spell: restricting weapon"] = "RestrictingWeapon",
  ["Spell: felling weapon"] = "FellingWeapon",
  ["Spell: conscious weapon"] = "ConsciousWeapon",
  ["Spell: intelligent weapon"] = "IntelligentWeapon",
  ["Spell: orbit"] = "Orbit",
  ["Spell: empathic resonance"] = "EmpathicResonance",
  ["Spell: hive mind"] = "HiveMind",
  ["Exhausted Spell: psyphon"] = "PsyphonExhaust",
  
  -- migraine exhausts
  ["Exhausted Spell: water breathing"] = "WaterBreathingExhaust",
  ["Exhausted Spell: giant strength"] = "GiantStrengthExhaust",
  ["Exhausted Spell: fly"] = "FlyExhaust",
  ["Exhausted Spell: cure light"] = "CureLightExhaust",
  
  -- racials
  ["Spell: racial revival"] = "RacialRevival",
  ["Racial revival fatigue"] = "RacialRevivalFatigue",
  ["Spell: racial fire aura"] = "RacialFireaura",
  ["Racial fireaura fatigue"] = "RacialFireauraFatigue",
  ["Racial innervate fatigue"] = "RacialInnervateFatigue",
  ["Spell: racial galvanize"] = "RacialGalvanize",
  ["Racial galvanize fatigue"] = "RacialGalvanizeFatigue",
  ["Racial breath fatigue"] = "RacialBreathFatigue",
  ["Spell: racial frenzy"] = "RacialFrenzy",
  ["Racial frenzy fatigue"] = "RacialFrenzyFatigue",
  ["Racial roar fatigue"] = "RacialRoarFatigue",
  ["Racial expunge fatigue"] = "RacialExpungeFatigue",
  
  -- debuffs
  ["Spell: calm"] = "Calm",
  ["Spell: fear"] = "Fear",
  ["Spell: poison"] = "Poison",
  ["Spell: curse"] = "Curse",
  ["Spell: demonfire"] = "Demonfire",
  ["Spell: virus"] = "Virus",
  ["Spell: biotoxin"] = "Biotoxin",
  ["Spell: venom"] = "Venom",
  ["Spell: toxin"] = "Toxin",
  ["Spell: doom toxin"] = "DoomToxin",
  ["Spell: flash"] = "Flash",
  ["Spell: weaken"] = "Weaken",
  ["Spell: blindness"] = "Blindness",
  ["Spell: overconfidence"] = "Overconfidence",
  ["Spell: scramble"] = "Scramble",
  ["Spell: panic"] = "Panic",
  ["Spell: heartbane"] = "Heartbane",
  ["Spell: unrest"] = "Unrest",
  ["Spell: faerie fire"] = "FaerieFire",
  ["Spell: plague"] = "Plague",
  
  ["Spell: hand of god"] = "HandOfGod",
  
}

function GMCP_Vitals()    
    StatTable.CharName = GMCP_name(gmcp.Char.Status.character_name)
    StatTable.Race, StatTable.Class = gmcp.Char.Status.race, gmcp.Char.Status.class
    StatTable.Level, StatTable.SubLevel = tonumber(gmcp.Char.Status.level), tonumber(gmcp.Char.Status.sublevel)
    StatTable.HitRoll, StatTable.DamRoll = tonumber(gmcp.Char.Status.hitroll) or 0, tonumber(gmcp.Char.Status.damroll) or 0
    StatTable.ArmorClass = tonumber(gmcp.Char.Status.ac) or 0
    StatTable.Items, StatTable.MaxItems = tonumber(gmcp.Char.Vitals.items), tonumber(string.sub(gmcp.Char.Vitals.string, -3))
    StatTable.Weight, StatTable.MaxWeight = tonumber(gmcp.Char.Vitals.wgt), tonumber(gmcp.Char.Vitals.maxwgt)
    StatTable.Alignment = tonumber(gmcp.Char.Status.alignment) or 0
    StatTable.Position = gmcp.Char.Vitals.position
    StatTable.Quicken = tonumber(gmcp.Char.Vitals.quicken) or 0
    StatTable.Augment = tonumber(gmcp.Char.Vitals.augment) or 0
    StatTable.Surge = tonumber(gmcp.Char.Vitals.surge) or 0
     
    StatTable.current_health, StatTable.max_health = tonumber(gmcp.Char.Vitals.hp), tonumber(gmcp.Char.Vitals.maxhp)
    StatTable.current_mana = (gmcp.Char.Vitals.maxmp == nil or gmcp.Char.Vitals.maxmp == "0") and 1 or tonumber(gmcp.Char.Vitals.mp)
    StatTable.max_mana = (gmcp.Char.Vitals.maxmp == nil or gmcp.Char.Vitals.maxmp == "0") and 1 or tonumber(gmcp.Char.Vitals.maxmp)
    StatTable.current_moves, StatTable.max_moves = tonumber(gmcp.Char.Vitals.mv), tonumber(gmcp.Char.Vitals.maxmv)
    StatTable.current_tnl,StatTable.max_tnl = tonumber(gmcp.Char.Vitals.tnl), tonumber(gmcp.Char.Vitals.maxtnl)
    StatTable.current_mon,StatTable.max_mon = 0, 0
    StatTable.current_mon,StatTable.max_mon = tonumber(gmcp.Char.Vitals.monhp), tonumber(gmcp.Char.Vitals.maxmonhp)
    
    StatTable.Enemy = gmcp.Char.Status.opponent_name
    StatTable.EnemyHP, StatTable.EnemyMaxHP = tonumber(gmcp.Char.Status.opponent_health), tonumber(gmcp.Char.Status.opponent_health_max)
    
    StatTable.InnerQi = tonumber(gmcp.Char.Vitals.innerqi) or 0
    StatTable.OuterQi = tonumber(gmcp.Char.Vitals.outerqi) or 0
     
    for _, affect in pairs(AffectsLookup) do
      StatTable[affect] = nil
    end
    
    -- Affects that cannot be looked up with GetDuration(v) should be listed seperately below
    StatTable.Tainted = nil
    StatTable.Oath = nil
    StatTable.EtherCrash = nil
    StatTable.EtherCrashDuration = nil
    StatTable.EtherCrashExhaust = nil
    StatTable.RacialInnervate = nil
    StatTable.RacialInnervateRegen = nil
    
    -- Iterate over gmcp.Char.Status.affects and set StatTable variables using the lookup table
    if StatTable.Level >= 25 and not (gmcp.Char.Status.affects == "" or gmcp.Char.Status.affects == nil) then  
        for k,v in pairs(gmcp.Char.Status.affects) do
        
            -- Check if the affect name exists in the lookup table
            local fieldName = AffectsLookup[k]
            
            if fieldName then
                StatTable[fieldName] = GetDuration(v)
            elseif(k == "Spell: tainted genius") then StatTable.Tainted = 1
            elseif(k == "Spell: oath") then StatTable.Oath = splitstring(v, " ")[2]
            elseif(k == "Spell: ether crash") then
              -- In the affects time, Ether Crash is set to 1 if it's turned on and 2 if its been exhausted
              StatTable.EtherCrash = tonumber(string.match(v, 'by%s*(%d+)'))
              if StatTable.EtherCrash == 1 then
                StatTable.EtherCrashDuration = GetDuration(v)
              else
                StatTable.EtherCrashExhaust = GetDuration(v)
              end
            elseif(k == "Exhausted Spell: ether crash") then
              if not StatTable.EtherCrashExhaust then StatTable.EtherCrashExhaust = GetDuration(v) end
            elseif(k == "Spell: racial innervate") then
                StatTable.RacialInnervate = tonumber(string.match(v, '(%d[,.%d]*)%s*hours'))
                StatTable.RacialInnervateRegen = tonumber(string.match(v, '%d[%d.,]*'))
            end
        end
    end

    if(GlobalVar.GUI) then UpdateGUI() end 

end
    
function GetDuration(affect)
    if(affect == "continuous") then return affect
    elseif (affect == "seems to be wavering") then return "Wavering"
    elseif(affect == "for a very long time") then return "Very Long"
    elseif(affect == "for seemingly forever") then return "Forever"
    elseif(affect == "for a long time") then return "Long Time"
    elseif(affect == "for a while") then return "A While"
    elseif(affect == "for a small amount of time") then return "Small Time"
    elseif(affect == "for a tiny amount of time") then return "Tiny Time"
    elseif(string.sub(affect, -19) == "for an unknown time") then return 1
    --else return tonumber(string.match(affect, "for (%d+) hours")) end
    else return tonumber(string.match(affect,"%d+",string.len(affect) -10)) end
end