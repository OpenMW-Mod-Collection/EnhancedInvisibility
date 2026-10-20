---@omw-context player
local ambient = require('openmw.ambient')
local postprocessing = require('openmw.postprocessing')
local types = require('openmw.types')
local core = require('openmw.core')
local self = require('openmw.self')
local nearby = require('openmw.nearby')

local oldVersion = core.API_REVISION < 147
local shader = postprocessing.load('EnhancedInvisibility')
local selfActiveEffects = types.Player.activeEffects(self)
local selfActiveSpells = types.Player.activeSpells(self)

local function invisActive()
    return selfActiveEffects:getEffect("invisibility").magnitude > 0
        -- support for:
        -- https://www.nexusmods.com/morrowind/mods/42267
        -- https://www.nexusmods.com/morrowind/mods/43291
        -- https://www.nexusmods.com/morrowind/mods/42270
        -- big thanks to lelimule
        and not selfActiveSpells:isSpellActive("ab01ssMountAbility")
        and not selfActiveSpells:isSpellActive("ab01boSailAbility")
        and not selfActiveSpells:isSpellActive("ab01goWaterTravelAbility")
end

local wasActive = false
local isActive = invisActive()

local function sendEventToNearbyCreatures(event)
    for _, actor in pairs(nearby.actors) do
        if types.Creature.objectIsInstance(actor) then
            actor:sendEvent(event)
        end
    end
end

local function onUpdate()
    if oldVersion then
        isActive = invisActive()
    end

    if not wasActive and isActive then
        wasActive = true

        shader:enable()
        ambient.streamMusic("music/EnhancedInvisibility/invisibility.mp3", { fadeOut = 0.2 })
        sendEventToNearbyCreatures("EnhancedInvisibility_Enable")
        core.sendGlobalEvent("EnhancedInvisibility_StatusUpdated", true)
    elseif wasActive and not invisActive() then
        wasActive = false
        isActive = false

        shader:disable()
        ambient.streamMusic("music/EnhancedInvisibility/nothing.mp3", { fadeOut = 1.0 })
        sendEventToNearbyCreatures("EnhancedInvisibility_Disable")
        core.sendGlobalEvent("EnhancedInvisibility_StatusUpdated", false)
    end
end


return {
    engineHandlers = {
        onUpdate = onUpdate,
    },
    eventHandlers = {
        ApplyMagicEffects = function()
            self:sendEvent("EnhancedInvisibility_DelayedCheckEffects")
        end,
        EnhancedInvisibility_DelayedCheckEffects = function()
            isActive = invisActive()
        end,
    },
}
