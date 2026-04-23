local combatWindow = nil
local pvpModeRadioGroup = nil

local function getUi()
  return combatWindow
end

local function applyCombatOverlayLayout(forcePosition)
  if not combatWindow then return end
  local root = modules.game_interface.getRootPanel and modules.game_interface.getRootPanel()
  if not root then return end

  if combatWindow:getParent() ~= root then
    combatWindow:setParent(root)
  end

  combatWindow:setWidth(286)
  combatWindow:setHeight(78)

  if forcePosition or not combatWindow._overlayPositionInitialized then
    combatWindow:breakAnchors()
    combatWindow:setPosition({
      x = math.max(0, root:getWidth() - combatWindow:getWidth() - 180),
      y = 58
    })
    combatWindow._overlayPositionInitialized = true
  end

  combatWindow:setDraggable(true)
  combatWindow:show()
  combatWindow:raise()
end

local function selectPosture(key, ignoreUpdate)
  local ui = getUi(); if not ui then return end
  if key == 'stand' then
    ui.standPosture:setEnabled(false)
    ui.followPosture:setEnabled(true)
    if not ignoreUpdate then g_game.setChaseMode(DontChase) end
  elseif key == 'follow' then
    ui.standPosture:setEnabled(true)
    ui.followPosture:setEnabled(false)
    if not ignoreUpdate then g_game.setChaseMode(ChaseOpponent) end
  end
end

local function selectCombat(combat, ignoreUpdate)
  local ui = getUi(); if not ui then return end
  if combat == 'attack' then
    ui.attack:setEnabled(false)
    ui.balanced:setEnabled(true)
    ui.defense:setEnabled(true)
    if not ignoreUpdate then g_game.setFightMode(FightOffensive) end
  elseif combat == 'balanced' then
    ui.attack:setEnabled(true)
    ui.balanced:setEnabled(false)
    ui.defense:setEnabled(true)
    if not ignoreUpdate then g_game.setFightMode(FightBalanced) end
  elseif combat == 'defense' then
    ui.attack:setEnabled(true)
    ui.balanced:setEnabled(true)
    ui.defense:setEnabled(false)
    if not ignoreUpdate then g_game.setFightMode(FightDefensive) end
  end
end

local function onSetSafeFight(self, checked)
  g_game.setSafeFight(not checked)
  if not checked then g_game.cancelAttack() end
end

local function expertMode(self, checked)
  local ui = getUi(); if not ui then return end
  local show = checked and g_game.getFeature(GamePVPMode)
  ui.whiteDoveBox:setVisible(show)
  ui.whiteHandBox:setVisible(show)
  ui.yellowHandBox:setVisible(show)
  ui.redFistBox:setVisible(show)
end

local function onSetPVPMode(self, selectedPVPButton)
  if selectedPVPButton == nil then return end
  local buttonId = selectedPVPButton:getId()
  local pvpMode = PVPWhiteDove
  if buttonId == 'whiteHandBox' then pvpMode = PVPWhiteHand
  elseif buttonId == 'yellowHandBox' then pvpMode = PVPYellowHand
  elseif buttonId == 'redFistBox' then pvpMode = PVPRedFist end
  g_game.setPVPMode(pvpMode)
end

local function walkEvent()
  if modules.client_options.getOption('autoChaseOverride') then
    if g_game.isAttacking() and g_game.getChaseMode() == ChaseOpponent then
      selectPosture('stand', false)
    end
  end
end

local function combatEvent()
  if not combatWindow then return end
  if g_game.getChaseMode() == ChaseOpponent then selectPosture('follow', true) else selectPosture('stand', true) end
  if g_game.getFightMode() == FightOffensive then selectCombat('attack', true)
  elseif g_game.getFightMode() == FightBalanced then selectCombat('balanced', true)
  elseif g_game.getFightMode() == FightDefensive then selectCombat('defense', true) end
  combatWindow.pvp:setChecked(g_game.isSafeFight())
end

local function onGameStart()
  addEvent(applyCombatOverlayLayout)
  combatWindow.expert:setVisible(g_game.getFeature(GamePVPMode))
  expertMode(nil, combatWindow.expert:isChecked())
  combatEvent()
end

local function onGameEnd()
end

function init()
  g_ui.importStyle('combatpanel')
  combatWindow = g_ui.displayUI('combatpanel', modules.game_interface.getRootPanel())
  combatWindow:hide()

  connect(combatWindow.pvp, { onCheckChange = onSetSafeFight })
  connect(combatWindow.expert, { onCheckChange = expertMode })
  connect(combatWindow.standPosture, { onClick = function() selectPosture('stand', false) end })
  connect(combatWindow.followPosture, { onClick = function() selectPosture('follow', false) end })
  connect(combatWindow.attack, { onClick = function() selectCombat('attack', false) end })
  connect(combatWindow.balanced, { onClick = function() selectCombat('balanced', false) end })
  connect(combatWindow.defense, { onClick = function() selectCombat('defense', false) end })

  pvpModeRadioGroup = UIRadioGroup.create()
  pvpModeRadioGroup:addWidget(combatWindow.whiteDoveBox)
  pvpModeRadioGroup:addWidget(combatWindow.whiteHandBox)
  pvpModeRadioGroup:addWidget(combatWindow.yellowHandBox)
  pvpModeRadioGroup:addWidget(combatWindow.redFistBox)
  connect(pvpModeRadioGroup, { onSelectionChange = onSetPVPMode })

  connect(g_game, {
    onGameStart = onGameStart,
    onGameEnd = onGameEnd,
    onWalk = walkEvent,
    onAutoWalk = walkEvent,
    onFightModeChange = combatEvent,
    onChaseModeChange = combatEvent,
    onSafeFightChange = combatEvent,
    onPVPModeChange = combatEvent
  })

  if g_game.isOnline() then onGameStart() end
end

function terminate()
  disconnect(g_game, {
    onGameStart = onGameStart,
    onGameEnd = onGameEnd,
    onWalk = walkEvent,
    onAutoWalk = walkEvent,
    onFightModeChange = combatEvent,
    onChaseModeChange = combatEvent,
    onSafeFightChange = combatEvent,
    onPVPModeChange = combatEvent
  })
  if pvpModeRadioGroup then
    disconnect(pvpModeRadioGroup, { onSelectionChange = onSetPVPMode })
    pvpModeRadioGroup:destroy()
    pvpModeRadioGroup = nil
  end
  if combatWindow then combatWindow:destroy(); combatWindow = nil end
end
