-- Script: CHANGELOG
-- Attribute: isActive

-- Script Code:
-- Vagonuth AVATAR Package Change Log


-- v1.0.0
-- initial release

-- v1.0.1
-- added: repinsig, repinv

-- v1.0.2
-- added: AutoLotto
-- added: ShapeSorting descriptions
-- added: special ammo rotation fletching (alpha)
-- updated: "runstats" cmd now shows all character's level gains during the session
-- bug fixes: wizsig spell
-- fixed autocastspellswap for hero

-- v1.0.3
-- added: add pantheon spells to be autocasted (eg panth glorious)
-- added: kin for kinetic enhancer spells
-- added: autoviolate for sorcerers (eg autoviolate cross)
-- added: explaination of code to README
-- added: glares and snarls trigger
-- added: autofrenzy on/off (overwrites the default)
-- added: palrescue on/off (default on)
-- updated: pantheon now has a grimharvest counter
-- updated: skillstyle moved to autoskill (eg autoskill smash)
-- updated: Psi Triggers now updated from github with option to add local triggers
-- updated: alleg descriptions now represent rarity (how often they appear in lotto)
-- Fixed bug: Battle.AutoCast etc, when getting spell cost reduction, check to see if AltList exists first
-- Fixed bug: Groups now support more than 32 players (however only StaticVars.MaxGroupLabels (default: 32) players will appear in grouplist)
-- Fixed bug: auto pass / bag alleg now checks to see if Alleg Script exists first
-- WIP: improved lord psi triggers (eg preventing enemy gravitas)

-- v1.1.0
-- significant improvement to lord monks (qi, preachup, gameloop)
-- improvements to mnd (psyphon, expanded decept list)
-- added: drider autopoison/expunge
-- added: verbose (on|off) - turns on/off extra messages to GameMessage
-- update: monitor no longer switches on preachup if you're already monitoring someone
-- update: classes that can self spell certain spells (bark, steel) now do so on mday
-- update: pantheon, unholy rampage now works like grim harvest
-- minor update: minor optimization to gmcp updates
-- minor update: autoheal ON/OFF now shows where "Qi" label used to be (for healer types)
-- minor update: added gulch keys
-- minor update: psi's now try to shatter forcefields
-- minor update: alleg/junk now passed/dropped on rc
-- minor update: alleg now picked up when decept causes mob to drop it
-- minor update: added hive mind to layout/preachup
-- minor update: tweaked autofrenzy logic
-- minor update: additional game messages
-- bug fix: alias formatting when there's args
-- bug fix: mnd was over surging
-- bug fix: hellbreach tokens are now touched again

-- v1.1.1 hotfix
-- fixed monk not kicking before flow up
-- fixed psi trigger download
-- fixed overoptimization of gmcp updates
-- fixed rapture bug for low hero psi's
-- removed healing outside of combat (prs test feature)

-- v1.2.0
-- full rewrite of bladedancer dance patterns, users can build custom dance patterns now
-- added: dancepattern and nextstance
-- added "dropjunk" (or "dj") command to quickly clean inventory
-- added mday leader gtell commands "get X Y", "drop X Y", "ablut", "wear all" etc. (only work on mday)
-- added GlobalVar.PlaneName
-- added gt track <x>, if char as autotrack echo on, will track X on leaders command
-- added auto spell switching when lords swap between mid and lord plane
-- improved soldier gameloop (stance shifting at hero and lord)
-- improved immo (moved to gmcp for better keyword targetting / consistency)
-- added auto devour for dragons (based on immo list)
-- bug fix: autolotto wasn't handing out last item
-- bug fix: improved migraine trigger for when dealing with multiple migraines
-- minor fix: changed beckon trigger to not autofollow outside of mday
-- minor fix: added bzk to be included in "ar auto"
-- minor fix: wrt "ar auto" at hero, bld's and small warrior types (< 2500hp) are now auto added to AR
-- minor fix: repvault and repthief now report # of complete sets you have

-- v1.3.0
-- rewrite of black circle initiate (lord 75+ still needs work)
-- added highmagic
-- added sidereal
-- added additional racials and auras to layout (incl racial heraldry)
-- added GUI echomain, see "gui"
-- added fail counter
-- added affect info to powerstate show (legend)
-- update to Battle.Act - caster's now cast faster after a lag proc
-- minor update: changes autobash button to autotarget, disabled autobash cmd for now
-- minor update: AutoLotto - added "can't carry" message
-- bug fix: gt surge up was not working correctly.



-- Long-term Todo
-- BCI: Lord 75+ (swap bwtn mindstrike & ass)
-- add max surge check for surging with classes that can't surge 5
-- autoskill scatter doesn't work because its not 5 seconds of lag but rather the next round that it resets
-- customizable variables
-- keep custom variables outside of main package so not overwritten when updated
-- have a script create a script outside of main package on first installation
-- python script to convert between .lua and .xml
-- make scan while move client side alias
-- mob death queue, use expandalias?
-- inprogress: make list of mobs with weapon for decept / shatter (mnk)

-- BUGS:
-- IsMDAY() is built throughout VagoPack but is a function from inventory pack (fix or make inv pack mandatory?)

