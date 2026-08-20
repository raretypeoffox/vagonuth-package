if StatTable.RacialRevivalFatigue then
  send("gtell |BW|Revival |BY|EXHAUSTED: |BW|" .. StatTable.RacialRevivalFatigue .. " |N|ticks")
else
  send("gtell |BW|Revival |BY|Avaiable")
end
  