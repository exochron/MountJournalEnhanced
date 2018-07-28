local ADDON_NAME, ADDON = ...

MountJournalEnhancedSettings = MountJournalEnhancedSettings or {}
local defaultFilterStates

local function PrepareDefaults()
    local defaultSettings = {
        debugMode = false,
        showShopButton = false,
        favoritePerCharacter = true,
        favoredMounts = { },
        hiddenMounts = { },
        filter = {
            collected = true,
            notCollected = true,
            onlyFavorites = false,
            onlyUsable = false,
            source = { },
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
            family = { },
            expansion = { },
            hidden = false,
        },
    }
    for categoryName, _ in pairs(ADDON.MountJournalEnhancedSource) do
        defaultSettings.filter.source[categoryName] = true
    end
    for categoryName, _ in pairs(ADDON.MountJournalEnhancedFamily) do
        defaultSettings.filter.family[categoryName] = true
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
        elseif (type(settings[key]) == "table" and type(value) == "table") then
            CombineSettings(settings[key], value);
        end
    end
end

function ADDON:LoadSettings()
    local defaultSettings = PrepareDefaults()
    defaultFilterStates = CopyTable(defaultSettings.filter)
    CombineSettings(MountJournalEnhancedSettings, defaultSettings)
    self.settings = MountJournalEnhancedSettings

    return MountJournalEnhancedSettings
end

function ADDON:ResetFilterSettings()
    MountJournalEnhancedSettings.filter = CopyTable(defaultFilterStates)
end