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


-- Long-term Todo
-- customizable variables
-- keep custom variables outside of main package so not overwritten when updated
-- have a script create a script outside of main package on first installation
-- python script to convert between .lua and .xml
-- make scan while move client side alias

-- BUGS:
-- 

