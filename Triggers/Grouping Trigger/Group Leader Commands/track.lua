if GlobalVar.AutoTrack == "echo" then
  TryAction("track " .. matches[2], 1)
  GlobalVar.AutoTrackTarget = matches[2]
end