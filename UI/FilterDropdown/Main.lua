local _, ADDON = ...

if not MenuUtil then -- modern style filter menu does not exist. use legacy UIDropdownMenu instead
    return
end

ADDON.UI.FDD = {}

local SETTING_COLLECTED = "collected"
local SETTING_ONLY_FAVORITES = "onlyFavorites"
local SETTING_NOT_COLLECTED = "notCollected"
local SETTING_ONLY_USEABLE = "onlyUsable"
local SETTING_ONLY_TRADABLE = "onlyTradable"
local SETTING_ONLY_RECENT = "onlyRecent"
local SETTING_SOURCE = "source"
local SETTING_MOUNT_TYPE = "mountType"
local SETTING_FACTION = "faction"
local SETTING_FAMILY = "family"
local SETTING_EXPANSION = "expansion"
local SETTING_HIDDEN = "hidden"
local SETTING_HIDDEN_INGAME = "hiddenIngame"
local SETTING_RARITY = "rarity"

local function setAllSettings(settings, switch)
    for key, value in pairs(settings) do
        if type(value) == "table" then
            for subKey, _ in pairs(value) do
                settings[key][subKey] = switch
            end
        else
            settings[key] = switch
        end
    end
end
function ADDON.UI.FDD:SetAllSubFilters(settings, switch)
    setAllSettings(settings,switch)
    ADDON:FilterMounts()
end

function ADDON.UI.FDD:CreateFilter(root, text, filterKey, filterSettings, withOnly)
    if not filterSettings then
        filterSettings = ADDON.settings.filter
    end

    local button = root:CreateCheckbox(text, function()
        return filterSettings[filterKey]
    end, function(...)
        filterSettings[filterKey] = not filterSettings[filterKey]
        ADDON:FilterMounts()

        return MenuResponse.Refresh
    end)
    if withOnly then
        local onlySettings = true == withOnly and filterSettings or withOnly

        button:AddInitializer(function(button, elementDescription, menu)
            local onlyButton = MenuTemplates.AttachAutoHideButton(button, "")

            onlyButton:SetNormalFontObject("GameFontHighlight")
            onlyButton:SetHighlightFontObject("GameFontHighlight")
            onlyButton:SetText(ADDON.L.FILTER_ONLY)
            onlyButton:SetSize(onlyButton:GetTextWidth(), 20)
            onlyButton:SetPoint("RIGHT")

            onlyButton:SetScript("OnClick", function(self, ...)
                setAllSettings(onlySettings, false)
                filterSettings[filterKey] = true
                ADDON:FilterMounts()
                menu:SendResponse(elementDescription, MenuResponse.Refresh)
            end)

            -- after click menu gets rerendered. by default the auto button is hidden.
            -- since the button itself isn't properly rendered yet, the mouse is also not yet over it.
            -- and so we wait...
            C_Timer.After(0, function()
                if button:IsMouseOver() then
                    onlyButton:Show()
                end
            end)
        end)
    end

    return button
end

--region ALL and None
local function AddAllAndNone(root, settings)
    ADDON.UI:CenterDropdownButton(root:CreateButton(ALL, function()
        ADDON.UI.FDD:SetAllSubFilters(settings, true)
        return MenuResponse.Refresh
    end))
    ADDON.UI:CenterDropdownButton(root:CreateButton(NONE, function()
        ADDON.UI.FDD:SetAllSubFilters(settings, false)
        return MenuResponse.Refresh
    end))

    root:QueueSpacer()
end
local function registerVerticalLayoutHook()
    hooksecurefunc(AnchorUtil, "VerticalLayout", function(frames, initialAnchor, padding)
        if #frames > 3 and MountJournal and MountJournal:IsShown() then
            local first = frames[1]
            local second = frames[2]
            if first.fontString and first.fontString:GetText() == ALL and second.fontString and second.fontString:GetText() == NONE then
                first:SetSize(first:GetWidth() / 2, first:GetHeight())
                second:SetSize(second:GetWidth() / 2, second:GetHeight())

                second:SetPoint("TOPLEFT", first, "TOPRIGHT", padding, 0)
                frames[3]:SetPoint("TOPLEFT", first, "BOTTOMLEFT", 0, -padding)
            end
        end
    end)
end
--endregion

local function setLeftPadding(button)
    button:AddInitializer(function(button)
        local pad = button:AttachTexture();
        pad:SetSize(18, 10);
        pad:SetPoint("LEFT");

        button.leftTexture1:SetPoint("LEFT", pad, "RIGHT");

        local width = pad:GetWidth() + button.leftTexture1:GetWidth() + button.fontString:GetUnboundedStringWidth()
        return width, button.fontString:GetHeight()
    end)
end

local function setupSourceMenu(root)
    local serverExpansion = GetClientDisplayExpansionLevel()
    local settings = ADDON.settings.filter[SETTING_SOURCE]
    local L = ADDON.L

    AddAllAndNone(root, settings)

    ADDON.UI.FDD:CreateFilter(root, BATTLE_PET_SOURCE_1, "Drop", settings, true)
    ADDON.UI.FDD:CreateFilter(root, BATTLE_PET_SOURCE_2, "Quest", settings, true)
    ADDON.UI.FDD:CreateFilter(root, BATTLE_PET_SOURCE_3, "Vendor", settings, true)
    ADDON.UI.FDD:CreateFilter(root, BATTLE_PET_SOURCE_4, "Profession", settings, true)
    ADDON.UI.FDD:CreateFilter(root, INSTANCE, "Instance", settings, true)
    ADDON.UI.FDD:CreateFilter(root, REPUTATION, "Reputation", settings, true)
    ADDON.UI.FDD:CreateFilter(root, BATTLE_PET_SOURCE_6, "Achievement", settings, true)
    if serverExpansion >= LE_EXPANSION_SHADOWLANDS then
        ADDON.UI.FDD:CreateFilter(root, GetCategoryInfo(15441), "Covenants", settings, true)
    end
    if serverExpansion >= LE_EXPANSION_BATTLE_FOR_AZEROTH then
        ADDON.UI.FDD:CreateFilter(root, ISLANDS_HEADER, "Island Expedition", settings, true)
    end
    if serverExpansion >= LE_EXPANSION_WARLORDS_OF_DRAENOR then
        ADDON.UI.FDD:CreateFilter(root, GARRISON_LOCATION_TOOLTIP, "Garrison", settings, true)
    end
    ADDON.UI.FDD:CreateFilter(root, PVP, "PVP", settings, true)
    ADDON.UI.FDD:CreateFilter(root, CLASS, "Class", settings, true)
    ADDON.UI.FDD:CreateFilter(root, BATTLE_PET_SOURCE_7, "World Event", settings, true)
    if serverExpansion >= LE_EXPANSION_MISTS_OF_PANDARIA then
        ADDON.UI.FDD:CreateFilter(root, L["Black Market"], "Black Market", settings, true)
    end
    if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE  then
        ADDON.UI.FDD:CreateFilter(root, BATTLE_PET_SOURCE_12, "Trading Post", settings, true)
    end
    ADDON.UI.FDD:CreateFilter(root, BATTLE_PET_SOURCE_10, "Shop", settings, true)
    ADDON.UI.FDD:CreateFilter(root, BATTLE_PET_SOURCE_8, "Promotion", settings, true)
    ADDON.UI.FDD:CreateFilter(root, L.FILTER_RETIRED, "Unavailable", settings, true)
end

local function setupTypeMenu(root)
    local settings = ADDON.settings.filter[SETTING_MOUNT_TYPE]
    local L = ADDON.L

    AddAllAndNone(root, settings)

    ADDON.UI.FDD:CreateFilter(root, MOUNT_JOURNAL_FILTER_FLYING, "flying", settings, true)
    ADDON.UI.FDD:CreateFilter(root, MOUNT_JOURNAL_FILTER_GROUND, "ground", settings, true)
    ADDON.UI.FDD:CreateFilter(root, MOUNT_JOURNAL_FILTER_AQUATIC, "underwater", settings, true)
    if GetClientDisplayExpansionLevel() >= LE_EXPANSION_CATACLYSM then
        ADDON.UI.FDD:CreateFilter(root, L["Transform"], "transform", settings, true)
    end
    ADDON.UI.FDD:CreateFilter(root, MINIMAP_TRACKING_REPAIR, "repair", settings, true)
    ADDON.UI.FDD:CreateFilter(root, L["Passenger"], "passenger", settings, true)
    if GetClientDisplayExpansionLevel() >= LE_EXPANSION_WAR_WITHIN then
        ADDON.UI.FDD:CreateFilter(root, MOUNT_JOURNAL_FILTER_RIDEALONG, "rideAlong", settings, true)
    end
end

local function setupFactionMenu(root)
    local settings = ADDON.settings.filter[SETTING_FACTION]
    ADDON.UI.FDD:CreateFilter(root, FACTION_ALLIANCE, "alliance", settings)
    ADDON.UI.FDD:CreateFilter(root, FACTION_HORDE, "horde", settings)
    ADDON.UI.FDD:CreateFilter(root, NPC_NAMES_DROPDOWN_NONE, "noFaction", settings)
end

local function setupExpansionMenu(root)
    local settings = ADDON.settings.filter[SETTING_EXPANSION]
    AddAllAndNone(root, settings)

    --todo: use expansion icons/textures
    for i = GetClientDisplayExpansionLevel(), 0,-1 do
        if _G["EXPANSION_NAME" .. i] then
            ADDON.UI.FDD:CreateFilter(root, _G["EXPANSION_NAME" .. i], i, settings, true)
        end
    end
end

local function setupRarityMenu(root)
    local settings = ADDON.settings.filter[SETTING_RARITY]
    AddAllAndNone(root, settings)
    local addButton = function(quality, suffix)
        local text = "|c"..select(4, GetItemQualityColor(quality)).._G["ITEM_QUALITY"..quality.."_DESC"].."|r".." ("..suffix..")"
        ADDON.UI.FDD:CreateFilter(root, text, quality, settings, true)
    end
    addButton(Enum.ItemQuality.Legendary, "<2%")
    addButton(Enum.ItemQuality.Epic, "<10%")
    addButton(Enum.ItemQuality.Rare, "<20%")
    addButton(Enum.ItemQuality.Uncommon, "<50%")
    addButton(Enum.ItemQuality.Common, ">=50%")
end

local function setupFilterMenu(dropdown, root)
    local L = ADDON.L

    root:SetTag("MENU_MOUNT_COLLECTION_FILTER")

    ADDON.UI.FDD:AddSortMenu(root:CreateButton(RAID_FRAME_SORT_LABEL))

    root:CreateSpacer()

    ADDON.UI.FDD:CreateFilter(root, COLLECTED, SETTING_COLLECTED)
    local favorites = ADDON.UI.FDD:CreateFilter(root, FAVORITES_FILTER, SETTING_ONLY_FAVORITES)
    favorites:SetEnabled(function()
        return ADDON.settings.filter.collected
    end)
    setLeftPadding(favorites)
    local onlyUsable = ADDON.UI.FDD:CreateFilter(root, PET_JOURNAL_FILTER_USABLE_ONLY, SETTING_ONLY_USEABLE)
    onlyUsable:SetEnabled(function()
        return ADDON.settings.filter.collected
    end)
    setLeftPadding(onlyUsable)

    ADDON.UI.FDD:CreateFilter(root, NOT_COLLECTED, SETTING_NOT_COLLECTED)
    local hiddenIngame = ADDON.UI.FDD:CreateFilter(root, L.FILTER_SECRET, SETTING_HIDDEN_INGAME)
    hiddenIngame:SetEnabled(function()
        return ADDON.settings.filter.notCollected
    end)
    setLeftPadding(hiddenIngame)

    ADDON.UI.FDD:CreateFilter(root, L.FILTER_ONLY_LATEST, SETTING_ONLY_RECENT)
    ADDON.UI.FDD:CreateFilter(root, L["Only tradable"], SETTING_ONLY_TRADABLE)
    if ADDON.settings.filter[SETTING_HIDDEN] or TableHasAnyEntries(ADDON.settings.hiddenMounts) then
        ADDON.UI.FDD:CreateFilter(root, L["Hidden"], SETTING_HIDDEN)
    end

    root:CreateSpacer()

    setupSourceMenu(root:CreateButton(SOURCES))
    setupTypeMenu(root:CreateButton(MOUNT_JOURNAL_FILTER_TYPE or TYPE))
    setupFactionMenu(root:CreateButton(FACTION))

    local familyRoot = root:CreateButton(L["Family"])
    AddAllAndNone(familyRoot, ADDON.settings.filter[SETTING_FAMILY])
    ADDON.UI.FDD:AddFamilyMenu(familyRoot)

    setupExpansionMenu(root:CreateButton(EXPANSION_FILTER_TEXT))
    ADDON.UI.FDD:AddColorMenu(root:CreateButton(COLOR))
    if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
        setupRarityMenu(root:CreateButton(RARITY))
    end

    root:CreateSpacer()

    ADDON.UI:CenterDropdownButton(root:CreateButton(L["Reset filters"], function()
        ADDON:ResetFilterSettings()
        ADDON:FilterMounts()

        return MenuResponse.CloseAll
    end))
end

ADDON.Events:RegisterCallback("loadUI", function()

    MountJournal.FilterDropdown:SetIsDefaultCallback(function()
        return ADDON.IsUsingDefaultFilters()
    end)
    MountJournal.FilterDropdown:SetDefaultCallback(function()
        ADDON:ResetFilterSettings()
        ADDON:FilterMounts()
    end)
    MountJournal.FilterDropdown:SetupMenu(setupFilterMenu)

    registerVerticalLayoutHook()
end, "filter dropdown")