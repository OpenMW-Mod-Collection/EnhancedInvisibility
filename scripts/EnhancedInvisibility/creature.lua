---@omw-context local
local self = require('openmw.self')
local anim = require('openmw.animation')
local types = require('openmw.types')

local creatureType = types.Creature.records[self.recordId].type
local isDaedra = creatureType == types.Creature.TYPE.Daedra
local isUndead = creatureType == types.Creature.TYPE.Undead

local enabled = false

return {
    engineHandlers = {
        onInactive = function()
            if not enabled then return end
            if isDaedra or isUndead then
                anim.removeVfx(self, "ei_fx")
                enabled = false
            end
        end,
    },
    eventHandlers = {
        EnhancedInvisibility_Enable = function()
            if enabled then return end
            if isDaedra then
                local vfx = "meshes/oj/ei/ei_daedravfx.nif"
                anim.addVfx(self, vfx, { loop = true, vfxId = "ei_fx" })
                enabled = true
            elseif isUndead then
                local vfx = "meshes/oj/ei/ei_undeadvfx.nif"
                anim.addVfx(self, vfx, { loop = true, vfxId = "ei_fx" })
                enabled = true
            end
        end,
        EnhancedInvisibility_Disable = function()
            if not enabled then return end
            if isDaedra or isUndead then
                anim.removeVfx(self, "ei_fx")
                enabled = false
            end
        end
    }
}
