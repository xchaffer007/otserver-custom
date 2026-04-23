local function forceLight()
  if not g_game.isOnline() then
    return
  end

  g_game.setDayTime(12)
  g_game.setLight(100)
end

connect(g_game, {
  onGameStart = function()
    scheduleEvent(forceLight, 100)
    scheduleEvent(forceLight, 500)
    scheduleEvent(forceLight, 1000)
  end,
  onAmbientLightChange = forceLight
})