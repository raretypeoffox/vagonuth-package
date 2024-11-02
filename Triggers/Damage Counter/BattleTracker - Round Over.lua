-- Trigger: BattleTracker - Round Over 


-- Trigger Patterns:
-- 0 (regex): ^\$?\$?\*?\@?\#?<(\d+)\/(\d+)hp (\d+)\/(\d+)ma (\d+)v (\d+)> (?<lag>\d+) lag (\d+|-) (\d+|-)?%? surge (\d+|off) ?$
-- 1 (regex): ^(.*)<(\d+)\/(\d+)hp (\d+)\/(\d+)ma (\d+)v (\d+)> (?<lag>\d+) lag (\d+|-) (\d+|-)?%? surge (\d+|off) ?$

-- Script Code:
-- Cpatures the prompt, missing some things like [PS] (protective stance, focus fire etc.)


BattleTracker.RoundOver()
BattleTracker.MobHealth = ""

