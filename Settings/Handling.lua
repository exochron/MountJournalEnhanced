local _, ADDON = ...
local L = ADDON.L

--region setting handler
local callbacks, defaults, uiLabels, behaviourLabels = {}, {}, {}, {}
function ADDON:RegisterUISetting(key, default, label, func, options)
    callbacks[key] = function(flag)
        ADDON.settings.ui[key] = flag
        if func then
            func(flag)
        end
    end
    defaults[key] = default
    table.insert(uiLabels, { key, label, options })
end
function ADDON:RegisterBehaviourSetting(key, default, label, func)
    callbacks[key] = function(flag)
        ADDON.settings[key] = flag
        MJEPersonalSettings[key] = flag
        if func then
            func(flag)
        end
    end
    defaults[key] = default
    table.insert(behaviourLabels, { key, label })
end
function ADDON:ApplySetting(key, value)
    if callbacks[key] then
        callbacks[key](value)
    end
end
function ADDON:ResetSettings()
    for setting, default in pairs(defaults) do
        ADDON:ApplySetting(setting, default)
    end
end
function ADDON:GetSettingLabels()
    return uiLabels, behaviourLabels
end
--endregion

--region setup some behaviour settings
ADDON:RegisterBehaviourSetting('personalUi', false, L.SETTING_PERSONAL_UI, function(flag)
    if flag == true then
        ADDON.settings.ui = MJEPersonalSettings.ui
    else
        ADDON.settings.ui = MJEGlobalSettings.ui
    end
end)

ADDON:RegisterBehaviourSetting('personalHiddenMounts', false, L.SETTING_PERSONAL_HIDDEN_MOUNTS, function(flag)
    if flag == true then
        ADDON.settings.hiddenMounts = MJEPersonalSettings.hiddenMounts
    else
        ADDON.settings.hiddenMounts = MJEGlobalSettings.hiddenMounts
    end

    if ADDON.initialized then
        ADDON:FilterMounts()
    end
end)

ADDON:RegisterBehaviourSetting('personalFilter', false, L.SETTING_PERSONAL_FILTER, function(flag)
    if flag == true then
        ADDON.settings.filter = MJEPersonalSettings.filter
        ADDON.settings.sort = MJEPersonalSettings.sort
    else
        ADDON.settings.filter = MJEGlobalSettings.filter
        ADDON.settings.sort = MJEGlobalSettings.sort
    end

    if ADDON.initialized then
        ADDON:FilterMounts()
    end
end)

if WOW_PROJECT_ID ~= WOW_PROJECT_WRATH_CLASSIC then
    ADDON:RegisterBehaviourSetting('searchInDescription', true, L.SETTING_SEARCH_MORE)
end
ADDON:RegisterBehaviourSetting('searchInNotes', true, L.SETTING_SEARCH_NOTES)
--endregion
