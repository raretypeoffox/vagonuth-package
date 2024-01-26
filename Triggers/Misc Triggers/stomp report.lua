-- Trigger: stomp report 
-- Attribute: isActive


-- Trigger Patterns:
-- 0 (regex): ^.*'s foot comes down, (.*) vanishes suddenly!$

-- Script Code:
-- As a rampaging mastador's foot comes down, TICKLE FIGHT vanishes suddenly!
-- A rampaging mastador viciously stomps on a military cloak and destroys it!
-- A rampaging mastador viciously stomps on crushed piece of armor until it is no more!

-- ^.* viciously stomps on (.*) and destroys it!$
-- ^.* viciously stomps on (.*) until it is no more!$

-- Produces a lot of spam reporting. Testing out if "vanishes" is for more important items

if not GlobalVar.Silent then
  send("gtell |BW|" .. matches[2] .. "|N| just got |BR|stomped|N|! I hope you have insurance...",false)
end