-- private variables
local background
local clientVersionLabel
local bgEffectEvent = nil
local toggleState = true
local timeLoopBackgroundEffect = 5000

function init()
    background = g_ui.displayUI('background')
    background:lower()

    clientVersionLabel = background:getChildById('clientVersionLabel')

    -- 🔥 REMOVE TEXTO DE VERSÃO
    if clientVersionLabel then
        clientVersionLabel:hide()
    end

    connect(g_game, {
        onGameStart = hide
    })
    connect(g_game, {
        onGameEnd = show
    })

    startBackgroundEffectLoop()
end

function terminate()
    disconnect(g_game, {
        onGameStart = hide
    })
    disconnect(g_game, {
        onGameEnd = show
    })

    if bgEffectEvent then
        removeEvent(bgEffectEvent)
        bgEffectEvent = nil
    end

    background:destroy()
    background = nil
end

function hide()
    background:hide()
    if bgEffectEvent then
        removeEvent(bgEffectEvent)
        bgEffectEvent = nil
    end
end

function show()
    background:show()
    startBackgroundEffectLoop()
end

function startBackgroundEffectLoop()
    if bgEffectEvent then
        removeEvent(bgEffectEvent)
        bgEffectEvent = nil
    end

    local function switchEffect()
        if not background then return end

        local particlesWidget = background:getChildById('particles')
        if not particlesWidget then return end

        if toggleState then
            particlesWidget:setEffect('background-effect')
        else
            particlesWidget:setEffect('background2-effect')
        end

        toggleState = not toggleState
        bgEffectEvent = scheduleEvent(switchEffect, timeLoopBackgroundEffect)
    end

    switchEffect()
end