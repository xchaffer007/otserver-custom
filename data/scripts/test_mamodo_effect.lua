local OWNER_EFFECT = 1      -- aura dourada

local DURATION = 3000       -- 3 segundos
local INTERVAL = 300        -- intervalo entre efeitos

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
    local player = Player(creature)
    if not player then
        return false
    end

    local summons = player:getSummons()
    if #summons == 0 then
        player:sendCancelMessage("Voce precisa ter um summon ativo.")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        return false
    end

    local summon = summons[1]
    local loops = math.floor(DURATION / INTERVAL)

    for i = 0, loops - 1 do
        addEvent(function(playerId, summonId)
            local p = Player(playerId)
            if not p then
                return
            end

            local s = Creature(summonId)
            if not s then
                return
            end

            p:getPosition():sendMagicEffect(OWNER_EFFECT)
            s:getPosition():sendMagicEffect(SUMMON_EFFECT)
        end, i * INTERVAL, player:getId(), summon:getId())
    end

    return true
end

spell:name("Mamodo Test Effect")
spell:words("mamodo test")
spell:group("support")
spell:vocation("none")
spell:id(200)
spell:cooldown(2 * 1000)
spell:groupCooldown(2 * 1000)
spell:level(1)
spell:mana(0)
spell:isSelfTarget(true)
spell:isAggressive(false)
spell:needLearn(false)
spell:register()