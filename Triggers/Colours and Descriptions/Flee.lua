--You flee east! What a COWARD! You lose 146 exps!
if (GlobalVar.GUI) then
  printGameMessage("Flee!", "You fled <yellow>" .. string.upper(matches[2]) .. "<ansi_white>! (XP Loss:<red>" .. matches[3] .. "<ansi_white>)")
end
QuickBeep()
