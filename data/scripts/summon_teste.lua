local ITEM_SUMMON = 348
local STORAGE_GOT_ITEM = 50000
local SUMMON_NAME = "Wolf"

-- 🎁 Dar item ao logar
local loginEvent = CreatureEvent("GiveSummonItem")

function loginEvent.onLogin(player)
    if player:getStorageValue(STORAGE_GOT_ITEM) ~= 1 then
        player:addItem(ITEM_SUMMON, 1)
        player:setStorageValue(STORAGE_GOT_ITEM, 1)
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Voce recebeu um item de summon (teste).")
    end
    return true
end

loginEvent:register()

-- 🐺 Item que invoca o summon
local action = Action()

function action.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local summons = player:getSummons()

    -- se já tem summon, remove
    if #summons > 0 then
        for i = 1, #summons do
            summons[i]:remove()
        end
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Summon removido.")
        return true
    end

    -- cria summon
    local summon = Game.createMonster(SUMMON_NAME, player:getPosition(), true, false)
    if not summon then
        player:sendCancelMessage("Erro ao invocar.")
        return true
    end

    summon:setMaster(player)
    summon:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)

    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Wolf invocado!")

    return true
end

action:id(ITEM_SUMMON)
action:register()