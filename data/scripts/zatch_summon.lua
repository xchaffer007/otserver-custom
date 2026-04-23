local action = Action()
function action.onUse(player, item, fromPosition, target, toPosition, isHotkey)
if #player:getSummons() > 0 then 
player:sendTextMessage(MESSAGE_STATUS_SMALL,"Voce ja tem um mamodo ativo")
return true
end
local summon = Game.createMonster("Wolf", player:getPosition(), false, true)
if not summon then
player:sendTextMensagge(MESSAGE_STATUS_SMALL, "Nao foi possivel invocar")
return true 
end

summon:setMaster(player)
return true
end
action:id(2650)
action:register()
