local ADDON_NAME, ADDON = ...

MountJournalEnhancedSettings = MountJournalEnhancedSettings or {}
local defaultFilterStates

function ADDON:ResetFilterSettings()
    ADDON.settings.filter = CopyTable(defaultFilterStates)
end

local function PrepareDefaults()
    local defaultSettings = {
        debugMode = false,
        showShopButton = false,
        compactMountList = true,
        favoritePerChar = false,
        favoredMounts = {},
        hiddenMounts = {},
        filter = {
            collected = true,
            notCollected = true,
            onlyFavorites = false,
            onlyUsable = false,
            source = {},
            faction = {
                alliance = true,
                horde = true,
                noFaction = true,
            },
            mountType = {
                ground = true,
                flying = true,
                waterWalking = true,
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
hooksecurefunc(ADDON, "OnLogin", function()
    local defaultSettings = PrepareDefaults()
    defaultFilterStates = CopyTable(defaultSettings.filter)
    CombineSettings(MountJournalEnhancedSettings, defaultSettings)
    ADDON.settings = MountJournalEnhancedSettings
end)