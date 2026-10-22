---@omw-context global
local types = require("openmw.types")

local enabled = false

return {
    engineHandlers = {
        onActorActive = function(actor)
            if enabled and types.Creature.objectIsInstance(actor) then
                actor:sendEvent("EnhancedInvisibility_Enable")
            end
        end,
    },
    eventHandlers = {
        EnhancedInvisibility_StatusUpdated = function(status)
            enabled = status
        end
    }
}
