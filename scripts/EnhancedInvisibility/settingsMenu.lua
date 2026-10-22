---@omw-context menu
local I = require('openmw.interfaces')

I.Settings.registerPage {
    key = "EnhancedInvisibility",
    l10n = "EnhancedInvisibility",
    name = "page_name",
    description = "page_desc",
}

I.Settings.registerGroup {
    key = 'SettingsEnhancedInvisibility',
    page = 'EnhancedInvisibility',
    l10n = "EnhancedInvisibility",
    name = "settings_groupName",
    order = 1,
    permanentStorage = true,
    settings = {
        {
            key = 'enable',
            name = 'enable_name',
            renderer = 'multiCheckbox',
            default = {
                invisibility = true,
                chameleon = true,
            },
            argument = {
                l10n = 'EnhancedInvisibility',
                keys = {
                    'invisibility',
                    'chameleon',
                },
            },
        },
        {
            key = "chameleonThreshold",
            name = "chameleonThreshold_name",
            description = "chameleonThreshold_desc",
            renderer = "SuperSlider6",
            default = 75,
            argument = {
                stepAffectsTextInput = true,
                default = 75,
            },
        },
    },
}
