local ADDON_NAME, ADDON = ...

MJEPersonalSettings = MJEPersonalSettings or {}
MJEGlobalSettings = MJEGlobalSettings or {}
local defaultFilterStates

function ADDON:ResetFilterSettings()
    ADDON.settings.filter = CopyTable(defaultFilterStates)
end

function ADDON:ResetSettings()
    ADDON:ApplyPersonalUI(false)
    ADDON:ApplyFavoritePerCharacter(false)
    ADDON:ApplyPersonalHiddenMounts(false)
    ADDON:ApplyPersonalFilter(false)

    ADDON:ApplyShowAchievementPoints(true)
    ADDON:ApplyCompactMountList(true)
    ADDON:ApplyUnlockDisplayCamera(true)
    ADDON:ApplyMoveEquipmentSlot(true)
    ADDON:ApplyPreviewButton(true)
    ADDON:ApplyShowPersonalCount(true)
    ADDON.settings.ui.enableCursorKeys = true
    ADDON.settings.ui.showShopButton = false
end

function ADDON:ApplyPersonalUI(flag)
    ADDON.settings.personalUi = flag
    MJEPersonalSettings.personalUi = flag
    if flag == true then
        ADDON.settings.ui = MJEPersonalSettings.ui
    else
        ADDON.settings.ui = MJEGlobalSettings.ui
    end
end
function ADDON:ApplyPersonalHiddenMounts(flag)
    MJEPersonalSettings.personalHiddenMounts = flag
    ADDON.settings.personalHiddenMounts = flag
    if flag == true then
        ADDON.settings.hiddenMounts = MJEPersonalSettings.hiddenMounts
    else
        ADDON.settings.hiddenMounts = MJEGlobalSettings.hiddenMounts
    end

    if ADDON.initialized then
        ADDON:UpdateIndexMap()
    end
end
function ADDON:ApplyPersonalFilter(flag)
    MJEPersonalSettings.personalFilter = flag
    ADDON.settings.personalFilter = flag
    if flag == true then
        ADDON.settings.filter = MJEPersonalSettings.filter
    else
        ADDON.settings.filter = MJEGlobalSettings.filter
    end

    if ADDON.initialized then
        ADDON:UpdateIndexMap()
    end
end

local function PrepareDefaults()
    local defaultSettings = {

        personalUi = false,
        ui = {
            debugMode = false,
            showAchievementPoints = true,
            showShopButton = false,
            compactMountList = true,
            unlockDisplayCamera = true,
            enableCursorKeys = true,
            moveEquipmentSlot = true,
            previewButton = true,
            showPersonalCount = true,
        },

        favoritePerChar = false,
        favoredMounts = {},

        hiddenMounts = {},
        personalHiddenMounts = false,

        personalFilter = false,
        filter = {
            collected = true,
            notCollected = true,
            onlyFavorites = false,
            onlyUsable = false,
            onlyTradable = false,
            source = {},
            faction = {
                alliance = true,
                horde = true,
                noFaction = true,
            },
            mountType = {
                ground = true,
                flying = true,
                underwater = true,
                transform = true,
                repair = true,
                passenger = true,
            },
            family = {},
            expansion = {},
            hidden = false,
        },
    }
    for categoryName, _ in pairs(ADDON.MountJournalEnhancedSource) do
        defaultSettings.filter.source[categoryName] = true
    end
    for categoryName, categoryConfig in pairs(ADDON.MountJournalEnhancedFamily) do
        for subCategory, subConfig in pairs(categoryConfig) do
            if type(subConfig) == "table" then
                if not defaultSettings.filter.family[categoryName] then
                    defaultSettings.filter.family[categoryName] = {}
                end
                defaultSettings.filter.family[categoryName][subCategory] = true
            else
                defaultSettings.filter.family[categoryName] = true
                break
            end
        end
    end
    for expansionName, _ in pairs(ADDON.MountJournalEnhancedExpansion) do
        defaultSettings.filter.expansion[expansionName] = true
    end

    return defaultSettings
end

local function CombineSettings(settings, defaultSettings)
    for key, value in pairs(defaultSettings) do
        if (settings[key] == nil) then
            settings[key] = value;
        elseif (type(value) == "table") and next(value) ~= nil then
            if type(settings[key]) ~= "table" then
                settings[key] = {}
            end
            CombineSettings(settings[key], value);
        end
    end

    -- cleanup old still existing settings
    for key, _ in pairs(settings) do
        if (defaultSettings[key] == nil) then
            settings[key] = nil;
        end
    end
end

-- Settings have to be loaded during PLAYER_LOGIN
ADDON:RegisterLoginCallback(function()
    local defaultSettings = PrepareDefaults()
    defaultFilterStates = CopyTable(defaultSettings.filter)
    CombineSettings(MJEGlobalSettings, defaultSettings)
    CombineSettings(MJEPersonalSettings, defaultSettings)

    ADDON.settings = {}

    ADDON:ApplyPersonalUI(MJEPersonalSettings.personalUi)
    ADDON:ApplyPersonalHiddenMounts(MJEPersonalSettings.personalHiddenMounts)
    ADDON:ApplyPersonalFilter(MJEPersonalSettings.personalFilter)

    ADDON.settings.favoritePerChar = MJEPersonalSettings.favoritePerChar
    ADDON.settings.favoredMounts = MJEPersonalSettings.favoredMounts
end)