lag = tonumber(gmcp.Char.Vitals.lag)

echo("\nAutoFletch Fail Detected\n")
echo("\nLast Fletch was: " .. GlobalVar.LastFletch .. "\n")

coroutine.wrap(function()
 
  if (lag > 1) then
    lag = lag - 1
  else
    lag = 1
  end
 
  wait(lag)
  
  if GlobalVar.AutoFletch then
    send(LastFletch)
    send("score") 
  end
end)()
