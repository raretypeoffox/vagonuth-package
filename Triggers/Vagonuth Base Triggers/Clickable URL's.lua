for i,v in ipairs(matches) do
  selectString(matches[i], 1)
  setLink([[openUrl("]]..matches[i]..[[")]], matches[i])
end