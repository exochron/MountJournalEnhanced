local ADDON_NAME, ADDON = ...

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
local SETTING_SORT = "sort"
local SETTING_COLOR = "color"
local SETTING_RARITY = "rarity"

function ADDON.UI.FDD:UpdateResetVisibility()
    if MountJournalFilterButton.ResetButton then
        MountJournalFilterButton.ResetButton:SetShown(not ADDON.IsUsingDefaultFilters())
    end
end;

function ADDON.UI.FDD:CreateFilterInfo(text, filterKey, filterSettings, toggleButtons)
    local info = {
        keepShownOnClick = true,
        isNotRadio = true,
        hasArrow = false,
        text = text,
    }

    if filterKey then
        if not filterSettings then
            filterSettings = ADDON.settings.filter
        end
        info.arg1 = filterSettings
        info.notCheckable = false
        info.checked = function(self)
            return self.arg1[filterKey]
        end
        info.func = function(self, arg1, arg2, value)
            arg1[filterKey] = arg2 or value
            ADDON:FilterMounts()
            UIDropDownMenu_RefreshAll(_G[ADDON_NAME .. "FilterMenu"])
            ADDON.UI.FDD:UpdateResetVisibility()

            if toggleButtons then
                local name = self:GetName()
                local x = tonumber(string.match(name, "%d+"))
                local y = tonumber(string.match(name, "%d+$"))
                for _, toggleNext in ipairs(toggleButtons) do
                    if value then
                        UIDropDownMenu_EnableButton(x, y + toggleNext)
                    else
                        UIDropDownMenu_DisableButton(x, y + toggleNext)
                    end
                end
            end
        end
    else
        info.notCheckable = true
    end

    return info
end
local CreateFilterInfo = function(...)
    return ADDON.UI.FDD.CreateFilterInfo(ADDON.UI.FDD, ...)
end

local function CreateFilterCategory(text, value)
    local info = CreateFilterInfo(text)
    info.hasArrow = true
    info.value = value

    return info
end

function ADDON.UI.FDD:SetAllSubFilters(settings, switch)
    for key, value in pairs(settings) do
        if type(value) == "table" then
            for subKey, _ in pairs(value) do
                settings[key][subKey] = switch
            end
        else
            settings[key] = switch
        end
    end

    UIDropDownMenu_RefreshAll(_G[ADDON_NAME .. "FilterMenu"])
    ADDON:FilterMounts()
    ADDON.UI.FDD:UpdateResetVisibility()
end

local function AddCheckAllAndNoneInfo(settings, level)
    local info = CreateFilterInfo(CHECK_ALL)
    info.func = function()
        ADDON.UI.FDD:SetAllSubFilters(settings, true)
    end
    UIDropDownMenu_AddButton(info, level)

    info = CreateFilterInfo(UNCHECK_ALL)
    info.func = function()
        ADDON.UI.FDD:SetAllSubFilters(settings, false)
    end
    UIDropDownMenu_AddButton(info, level)
end

local function HasUserHiddenMounts()
    for _, value in pairs(ADDON.settings.hiddenMounts) do
        if value == true then
            return true
        end
    end

    return false
end

local function InitializeFilterDropDown(_, level)
    local L = ADDON.L

    if level == 1 then
        local info
        UIDropDownMenu_AddButton(CreateFilterCategory(RAID_FRAME_SORT_LABEL, SETTING_SORT), level)
        UIDropDownMenu_AddSpace(level)

        info = CreateFilterInfo(COLLECTED, SETTING_COLLECTED, nil, { 1, 2 })
        UIDropDownMenu_AddButton(info, level)

        info = CreateFilterInfo(FAVORITES_FILTER, SETTING_ONLY_FAVORITES)
        info.leftPadding = 16
        info.disabled = not ADDON.settings.filter.collected
        UIDropDownMenu_AddButton(info, level)
        info = CreateFilterInfo(PET_JOURNAL_FILTER_USABLE_ONLY, SETTING_ONLY_USEABLE)
        info.leftPadding = 16
        info.disabled = not ADDON.settings.filter.collected
        UIDropDownMenu_AddButton(info, level)

        info = CreateFilterInfo(NOT_COLLECTED, SETTING_NOT_COLLECTED, nil, { 1 })
        UIDropDownMenu_AddButton(info, level)
        info = CreateFilterInfo(L.FILTER_SECRET, SETTING_HIDDEN_INGAME)
        info.leftPadding = 16
        info.disabled = not ADDON.settings.filter.notCollected
        UIDropDownMenu_AddButton(info, level)

        UIDropDownMenu_AddButton(CreateFilterInfo(L.FILTER_ONLY_LATEST, SETTING_ONLY_RECENT), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(L["Only tradable"], SETTING_ONLY_TRADABLE), level)

        if ADDON.settings.filter[SETTING_HIDDEN] or HasUserHiddenMounts() then
            UIDropDownMenu_AddButton(CreateFilterInfo(L["Hidden"], SETTING_HIDDEN), level)
        end

        UIDropDownMenu_AddSpace(level)

        UIDropDownMenu_AddButton(CreateFilterCategory(SOURCES, SETTING_SOURCE), level)
        UIDropDownMenu_AddButton(CreateFilterCategory(MOUNT_JOURNAL_FILTER_TYPE or TYPE, SETTING_MOUNT_TYPE), level)
        UIDropDownMenu_AddButton(CreateFilterCategory(FACTION, SETTING_FACTION), level)
        UIDropDownMenu_AddButton(CreateFilterCategory(L["Family"], SETTING_FAMILY), level)
        UIDropDownMenu_AddButton(CreateFilterCategory(EXPANSION_FILTER_TEXT, SETTING_EXPANSION), level)
        UIDropDownMenu_AddButton(CreateFilterCategory(COLOR, SETTING_COLOR), level)
        if ADDON.DB.Rarities then
            UIDropDownMenu_AddButton(CreateFilterCategory(RARITY, SETTING_RARITY), level)
        end

        UIDropDownMenu_AddSpace(level)

        info = CreateFilterInfo(L["Reset filters"])
        info.justifyH = "CENTER"
        info.keepShownOnClick = false
        info.func = function()
            MountJournalFilterButton.resetFunction()
            ADDON.UI.FDD:UpdateResetVisibility()
        end
        UIDropDownMenu_AddButton(info, level)
    elseif level == 2 and UIDROPDOWNMENU_MENU_VALUE == SETTING_SOURCE then

        local serverExpansion = GetServerExpansionLevel()

        local settings = ADDON.settings.filter[SETTING_SOURCE]
        AddCheckAllAndNoneInfo(settings, level)
        UIDropDownMenu_AddButton(CreateFilterInfo(BATTLE_PET_SOURCE_1, "Drop", settings), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(BATTLE_PET_SOURCE_2, "Quest", settings), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(BATTLE_PET_SOURCE_3, "Vendor", settings), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(BATTLE_PET_SOURCE_4, "Profession", settings), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(INSTANCE, "Instance", settings), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(REPUTATION, "Reputation", settings), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(BATTLE_PET_SOURCE_6, "Achievement", settings), level)
        if serverExpansion >= LE_EXPANSION_SHADOWLANDS then
            UIDropDownMenu_AddButton(CreateFilterInfo(GetCategoryInfo(15441), "Covenants", settings), level)
        end
        if serverExpansion >= LE_EXPANSION_BATTLE_FOR_AZEROTH then
            UIDropDownMenu_AddButton(CreateFilterInfo(ISLANDS_HEADER, "Island Expedition", settings), level)
        end
        if serverExpansion >= LE_EXPANSION_WARLORDS_OF_DRAENOR then
            UIDropDownMenu_AddButton(CreateFilterInfo(GARRISON_LOCATION_TOOLTIP, "Garrison", settings), level)
        end
        UIDropDownMenu_AddButton(CreateFilterInfo(PVP, "PVP", settings), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(CLASS, "Class", settings), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(BATTLE_PET_SOURCE_7, "World Event", settings), level)
        if serverExpansion >= LE_EXPANSION_MISTS_OF_PANDARIA then
            UIDropDownMenu_AddButton(CreateFilterInfo(L["Black Market"], "Black Market", settings), level)
        end
        if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE  then
            UIDropDownMenu_AddButton(CreateFilterInfo(BATTLE_PET_SOURCE_12, "Trading Post", settings), level)
            UIDropDownMenu_AddButton(CreateFilterInfo(BATTLE_PET_SOURCE_10, "Shop", settings), level)
        end
        UIDropDownMenu_AddButton(CreateFilterInfo(BATTLE_PET_SOURCE_8, "Promotion", settings), level)
    elseif level == 2 and UIDROPDOWNMENU_MENU_VALUE == SETTING_MOUNT_TYPE then
        local settings = ADDON.settings.filter[SETTING_MOUNT_TYPE]
        AddCheckAllAndNoneInfo(settings, level)
        UIDropDownMenu_AddButton(CreateFilterInfo(MOUNT_JOURNAL_FILTER_FLYING, "flying", settings), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(MOUNT_JOURNAL_FILTER_GROUND, "ground", settings), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(MOUNT_JOURNAL_FILTER_AQUATIC, "underwater", settings), level)
        if MOUNT_JOURNAL_FILTER_DRAGONRIDING then
            UIDropDownMenu_AddButton(CreateFilterInfo(MOUNT_JOURNAL_FILTER_DRAGONRIDING, "dragonriding", settings), level)
        end
        if GetServerExpansionLevel() >= LE_EXPANSION_CATACLYSM then
            UIDropDownMenu_AddButton(CreateFilterInfo(L["Transform"], "transform", settings), level)
        end
        UIDropDownMenu_AddButton(CreateFilterInfo(MINIMAP_TRACKING_REPAIR, "repair", settings), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(L["Passenger"], "passenger", settings), level)
    elseif level == 2 and UIDROPDOWNMENU_MENU_VALUE == SETTING_FACTION then
        local settings = ADDON.settings.filter[SETTING_FACTION]
        UIDropDownMenu_AddButton(CreateFilterInfo(FACTION_ALLIANCE, "alliance", settings), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(FACTION_HORDE, "horde", settings), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(NPC_NAMES_DROPDOWN_NONE, "noFaction", settings), level)
    elseif level == 2 and UIDROPDOWNMENU_MENU_VALUE == SETTING_FAMILY then
        AddCheckAllAndNoneInfo(ADDON.settings.filter[SETTING_FAMILY], level)
        ADDON.UI.FDD:AddFamilyMenu(level)
    elseif level == 3 and ADDON.DB.Family[UIDROPDOWNMENU_MENU_VALUE] then
        ADDON.UI.FDD:AddFamilySubMenu(level, UIDROPDOWNMENU_MENU_VALUE)
    elseif level == 2 and UIDROPDOWNMENU_MENU_VALUE == SETTING_EXPANSION then
        local settings = ADDON.settings.filter[SETTING_EXPANSION]
        AddCheckAllAndNoneInfo(settings, level)
        for i = GetServerExpansionLevel(), 0,-1 do
            UIDropDownMenu_AddButton(CreateFilterInfo(_G["EXPANSION_NAME" .. i], i, settings), level)
        end
    elseif level == 2 and UIDROPDOWNMENU_MENU_VALUE == SETTING_COLOR then
        ADDON.UI.FDD:AddColorMenu(level)
    elseif level == 2 and UIDROPDOWNMENU_MENU_VALUE == SETTING_RARITY then
        local settings = ADDON.settings.filter[SETTING_RARITY]
        AddCheckAllAndNoneInfo(settings, level)
        local addButton = function(quality, suffix)
            local text = "|c"..select(4, GetItemQualityColor(quality)).._G["ITEM_QUALITY"..quality.."_DESC"].."|r".." ("..suffix..")"
            UIDropDownMenu_AddButton(CreateFilterInfo(text, quality, settings), level)
        end
        addButton(Enum.ItemQuality.Legendary, "<1%")
        addButton(Enum.ItemQuality.Epic, "<10%")
        addButton(Enum.ItemQuality.Rare, "<20%")
        addButton(Enum.ItemQuality.Uncommon, "<50%")
        addButton(Enum.ItemQuality.Common, ">=50%")
    elseif level == 2 and UIDROPDOWNMENU_MENU_VALUE == SETTING_SORT then
        ADDON.UI.FDD:AddSortMenu(level)
    end
end

ADDON.Events:RegisterCallback("loadUI", function()
    local menu

    MountJournalFilterButton:SetScript("OnMouseDown", function(sender, button)
        UIMenuButtonStretchMixin.OnMouseDown(sender, button);
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)

        if menu == nil then
            menu = CreateFrame("Frame", ADDON_NAME .. "FilterMenu", MountJournalFilterButton, "UIDropDownMenuTemplate")
            UIDropDownMenu_Initialize(menu, InitializeFilterDropDown, "MENU")
        end

        ToggleDropDownMenu(1, nil, menu, sender, 74, 15)
    end)
    MountJournalFilterButton.resetFunction = function()
        ADDON:ResetFilterSettings()
        ADDON:FilterMounts()
    end
    ADDON.UI.FDD:UpdateResetVisibility()
end, "filter dropdown")