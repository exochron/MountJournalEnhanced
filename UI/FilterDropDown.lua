local ADDON_NAME, ADDON = ...
local L = ADDON.L
local EDDM = LibStub("ElioteDropDownMenu-1.0")

local SETTING_COLLECTED = "collected"
local SETTING_ONLY_FAVORITES = "onlyFavorites"
local SETTING_NOT_COLLECTED = "notCollected"
local SETTING_ONLY_USEABLE = "onlyUsable"
local SETTING_ONLY_TRADABLE = "onlyTradable"
local SETTING_SOURCE = "source"
local SETTING_MOUNT_TYPE = "mountType"
local SETTING_FACTION = "faction"
local SETTING_FAMILY = "family"
local SETTING_EXPANSION = "expansion"
local SETTING_HIDDEN = "hidden"
local SETTING_SORT = "sort"

local function CreateFilterInfo(text, filterKey, filterSettings, callback)
    local info = EDDM.UIDropDownMenu_CreateInfo()
    info.keepShownOnClick = true
    info.isNotRadio = true
    info.hasArrow = false
    info.text = text

    if filterKey then
        if not filterSettings then
            filterSettings = ADDON.settings.filter
        end
        info.arg1 = filterSettings
        info.notCheckable = false
        info.checked = function(self)
            return self.arg1[filterKey]
        end
        info.func = function(_, arg1, arg2, value)
            arg1[filterKey] = arg2 or value
            ADDON:UpdateIndexMap()
            MountJournal_UpdateMountList()
            EDDM.UIDropDownMenu_RefreshAll(_G[ADDON_NAME .. "FilterMenu"])

            if callback then
                callback(value)
            end
        end
    else
        info.notCheckable = true
    end

    return info
end

local function CreateFilterRadio(text, filterKey, filterSettings, filterValue)
    local info = CreateFilterInfo(text, filterKey, filterSettings)
    info.isNotRadio = false
    info.arg2 = filterValue
    info.checked = function(self)
        return self.arg1[filterKey] == filterValue
    end

    return info
end

local function CreateFilterCategory(text, value)
    local info = CreateFilterInfo(text)
    info.hasArrow = true
    info.value = value

    return info
end

local function CheckSetting(settings)
    local hasTrue, hasFalse = false, false
    for _, v in pairs(settings) do
        if (v == true) then
            hasTrue = true
        elseif v == false then
            hasFalse = true
        end
        if hasTrue and hasFalse then
            break
        end
    end

    return hasTrue, hasFalse
end

local function SetAllSubFilters(settings, switch)
    for key, value in pairs(settings) do
        if type(value) == "table" then
            for subKey, _ in pairs(value) do
                settings[key][subKey] = switch
            end
        else
            settings[key] = switch
        end
    end

    EDDM.UIDropDownMenu_RefreshAll(_G[ADDON_NAME .. "FilterMenu"])
    ADDON:UpdateIndexMap()
    MountJournal_UpdateMountList()
end

local function RefreshCategoryButton(button, isNotRadio)
    local buttonName = button:GetName()
    local buttonCheck = _G[buttonName .. "Check"]

    if isNotRadio then
        buttonCheck:SetTexCoord(0.0, 0.5, 0.0, 0.5);
    else
        buttonCheck:SetTexCoord(0.0, 0.5, 0.5, 1.0);
    end

    button.isNotRadio = isNotRadio
end

local function CreateInfoWithMenu(text, filterKey, settings)
    local info = EDDM.UIDropDownMenu_CreateInfo()
    info.text = text
    info.value = filterKey
    info.keepShownOnClick = true
    info.notCheckable = false
    info.hasArrow = true

    local hasTrue, hasFalse = CheckSetting(settings)
    info.isNotRadio = not hasTrue or not hasFalse

    info.checked = function(button)
        local hasTrue, hasFalse = CheckSetting(settings)
        RefreshCategoryButton(button, not hasTrue or not hasFalse)
        return hasTrue
    end
    info.func = function(button, _, _, value)
        if button.isNotRadio == value then
            SetAllSubFilters(settings, true)
        elseif true == button.isNotRadio and false == value then
            SetAllSubFilters(settings, false)
        end
    end

    return info
end

local function AddCheckAllAndNoneInfo(settings, level)
    local info = CreateFilterInfo(CHECK_ALL)
    info.func = function()
        SetAllSubFilters(settings, true)
    end
    EDDM.UIDropDownMenu_AddButton(info, level)

    info = CreateFilterInfo(UNCHECK_ALL)
    info.func = function()
        SetAllSubFilters(settings, false)
    end
    EDDM.UIDropDownMenu_AddButton(info, level)
end

local function ShouldDisplayFamily(spellIds)
    if #spellIds > 5 then
        return true
    end

    for spellId, _ in pairs(spellIds) do
        local mountId = C_MountJournal.GetMountFromSpell(spellId)
        local shouldHideOnChar = select(10, C_MountJournal.GetMountInfoByID(mountId))
        if shouldHideOnChar == false then
            return true
        end
    end

    return false
end

local function InitializeFilterDropDown(filterMenu, level)
    local info

    if (level == 1) then
        info = CreateFilterInfo(COLLECTED, SETTING_COLLECTED, nil, function(value)
            if (value) then
                EDDM.UIDropDownMenu_EnableButton(1, 2)
                EDDM.UIDropDownMenu_EnableButton(1, 3)
            else
                EDDM.UIDropDownMenu_DisableButton(1, 2)
                EDDM.UIDropDownMenu_DisableButton(1, 3)
            end
        end)
        EDDM.UIDropDownMenu_AddButton(info, level)

        info = CreateFilterInfo(FAVORITES_FILTER, SETTING_ONLY_FAVORITES)
        info.leftPadding = 16
        info.disabled = not ADDON.settings.filter.collected
        EDDM.UIDropDownMenu_AddButton(info, level)
        info = CreateFilterInfo(L["Only usable"], SETTING_ONLY_USEABLE)
        info.leftPadding = 16
        info.disabled = not ADDON.settings.filter.collected
        EDDM.UIDropDownMenu_AddButton(info, level)

        EDDM.UIDropDownMenu_AddButton(CreateFilterInfo(NOT_COLLECTED, SETTING_NOT_COLLECTED), level)
        EDDM.UIDropDownMenu_AddButton(CreateFilterInfo(L["Only tradable"], SETTING_ONLY_TRADABLE), level)
        EDDM.UIDropDownMenu_AddButton(CreateFilterInfo(L["Hidden"], SETTING_HIDDEN), level)
        EDDM.UIDropDownMenu_AddSpace(level)

        EDDM.UIDropDownMenu_AddButton(CreateFilterCategory(SOURCES, SETTING_SOURCE), level)
        EDDM.UIDropDownMenu_AddButton(CreateFilterCategory(TYPE, SETTING_MOUNT_TYPE), level)
        EDDM.UIDropDownMenu_AddButton(CreateFilterCategory(FACTION, SETTING_FACTION), level)
        EDDM.UIDropDownMenu_AddButton(CreateFilterCategory(L["Family"], SETTING_FAMILY), level)
        EDDM.UIDropDownMenu_AddButton(CreateFilterCategory(EXPANSION_FILTER_TEXT, SETTING_EXPANSION), level)
        EDDM.UIDropDownMenu_AddSpace(level)

        info = CreateFilterInfo(L["Reset filters"])
        info.keepShownOnClick = false
        info.func = function(_, _, _, value)
            ADDON:ResetFilterSettings()
            ADDON:UpdateIndexMap()
            MountJournal_UpdateMountList()
        end
        EDDM.UIDropDownMenu_AddButton(info, level)
        EDDM.UIDropDownMenu_AddSpace(level)

        EDDM.UIDropDownMenu_AddButton(CreateFilterCategory(CLUB_FINDER_SORT_BY, SETTING_SORT), level)
    elseif (EDDM.UIDROPDOWNMENU_MENU_VALUE == SETTING_SOURCE) then
        local settings = ADDON.settings.filter[SETTING_SOURCE]
        AddCheckAllAndNoneInfo(settings, level)
        EDDM.UIDropDownMenu_AddButton(CreateFilterInfo(BATTLE_PET_SOURCE_1, "Drop", settings), level)
        EDDM.UIDropDownMenu_AddButton(CreateFilterInfo(BATTLE_PET_SOURCE_2, "Quest", settings), level)
        EDDM.UIDropDownMenu_AddButton(CreateFilterInfo(BATTLE_PET_SOURCE_3, "Vendor", settings), level)
        EDDM.UIDropDownMenu_AddButton(CreateFilterInfo(BATTLE_PET_SOURCE_4, "Profession", settings), level)
        EDDM.UIDropDownMenu_AddButton(CreateFilterInfo(INSTANCE, "Instance", settings), level)
        EDDM.UIDropDownMenu_AddButton(CreateFilterInfo(REPUTATION, "Reputation", settings), level)
        EDDM.UIDropDownMenu_AddButton(CreateFilterInfo(BATTLE_PET_SOURCE_6, "Achievement", settings), level)
        EDDM.UIDropDownMenu_AddButton(CreateFilterInfo(ISLANDS_HEADER, "Island Expedition", settings), level)
        EDDM.UIDropDownMenu_AddButton(CreateFilterInfo(GARRISON_LOCATION_TOOLTIP, "Garrison", settings), level)
        EDDM.UIDropDownMenu_AddButton(CreateFilterInfo(PVP, "PVP", settings), level)
        EDDM.UIDropDownMenu_AddButton(CreateFilterInfo(CLASS, "Class", settings), level)
        EDDM.UIDropDownMenu_AddButton(CreateFilterInfo(BATTLE_PET_SOURCE_7, "World Event", settings), level)
        EDDM.UIDropDownMenu_AddButton(CreateFilterInfo(L["Black Market"], "Black Market", settings), level)
        EDDM.UIDropDownMenu_AddButton(CreateFilterInfo(BATTLE_PET_SOURCE_10, "Shop", settings), level)
        EDDM.UIDropDownMenu_AddButton(CreateFilterInfo(BATTLE_PET_SOURCE_8, "Promotion", settings), level)
    elseif (EDDM.UIDROPDOWNMENU_MENU_VALUE == SETTING_MOUNT_TYPE) then
        local settings = ADDON.settings.filter[SETTING_MOUNT_TYPE]
        AddCheckAllAndNoneInfo(settings, level)
        EDDM.UIDropDownMenu_AddButton(CreateFilterInfo(L["Flying"], "flying", settings), level)
        EDDM.UIDropDownMenu_AddButton(CreateFilterInfo(L["Ground"], "ground", settings), level)
        EDDM.UIDropDownMenu_AddButton(CreateFilterInfo(L["Underwater"], "underwater", settings), level)
        EDDM.UIDropDownMenu_AddButton(CreateFilterInfo(L["Transform"], "transform", settings), level)
        EDDM.UIDropDownMenu_AddButton(CreateFilterInfo(MINIMAP_TRACKING_REPAIR, "repair", settings), level)
        EDDM.UIDropDownMenu_AddButton(CreateFilterInfo(L["Passenger"], "passenger", settings), level)
    elseif (EDDM.UIDROPDOWNMENU_MENU_VALUE == SETTING_FACTION) then
        local settings = ADDON.settings.filter[SETTING_FACTION]
        EDDM.UIDropDownMenu_AddButton(CreateFilterInfo(FACTION_ALLIANCE, "alliance", settings), level)
        EDDM.UIDropDownMenu_AddButton(CreateFilterInfo(FACTION_HORDE, "horde", settings), level)
        EDDM.UIDropDownMenu_AddButton(CreateFilterInfo(NPC_NAMES_DROPDOWN_NONE, "noFaction", settings), level)
    elseif (EDDM.UIDROPDOWNMENU_MENU_VALUE == SETTING_FAMILY) then
        local settings = ADDON.settings.filter[SETTING_FAMILY]
        local sortedFamilies, hasSubFamilies = {}, {}
        AddCheckAllAndNoneInfo(settings, level)

        for family, mainConfig in pairs(ADDON.DB.Family) do
            hasSubFamilies[family] = false
            for _, subConfig in pairs(mainConfig) do
                if type(subConfig) == "table" then
                    hasSubFamilies[family] = true
                else
                    break
                end
            end
            table.insert(sortedFamilies, family)
        end
        table.sort(sortedFamilies, function(a, b)
            return (L[a] or a) < (L[b] or b)
        end)

        for _, family in pairs(sortedFamilies) do
            if hasSubFamilies[family] then
                EDDM.UIDropDownMenu_AddButton(CreateInfoWithMenu(L[family] or family, family, settings[family]), level)
            else
                EDDM.UIDropDownMenu_AddButton(CreateFilterInfo(L[family] or family, family, settings), level)
            end
        end
    elseif (EDDM.UIDROPDOWNMENU_MENU_VALUE == SETTING_EXPANSION) then
        local settings = ADDON.settings.filter[SETTING_EXPANSION]
        AddCheckAllAndNoneInfo(settings, level)
        for i = 0, #ADDON.DB.Expansion do
            EDDM.UIDropDownMenu_AddButton(CreateFilterInfo(_G["EXPANSION_NAME" .. i], i, settings), level)
        end
    elseif (level == 3 and ADDON.DB.Family[EDDM.UIDROPDOWNMENU_MENU_VALUE]) then
        local settings = ADDON.settings.filter[SETTING_FAMILY][EDDM.UIDROPDOWNMENU_MENU_VALUE]
        local sortedFamilies = {}
        for family, _ in pairs(ADDON.DB.Family[EDDM.UIDROPDOWNMENU_MENU_VALUE]) do
            table.insert(sortedFamilies, family)
        end
        table.sort(sortedFamilies, function(a, b)
            return (L[a] or a) < (L[b] or b)
        end)
        for _, family in pairs(sortedFamilies) do
            if ShouldDisplayFamily(ADDON.DB.Family[EDDM.UIDROPDOWNMENU_MENU_VALUE][family]) then
                EDDM.UIDropDownMenu_AddButton(CreateFilterInfo(L[family] or family, family, settings), level)
            end
        end
    elseif EDDM.UIDROPDOWNMENU_MENU_VALUE == SETTING_SORT then
        local settings = ADDON.settings[SETTING_SORT]
        EDDM.UIDropDownMenu_AddButton(CreateFilterRadio(NAME, "by", settings, 'name'), level)
        EDDM.UIDropDownMenu_AddButton(CreateFilterRadio(TYPE, "by", settings, 'type'), level)
        EDDM.UIDropDownMenu_AddButton(CreateFilterRadio(EXPANSION_FILTER_TEXT, "by", settings, 'expansion'), level)
        EDDM.UIDropDownMenu_AddSpace(level)
        EDDM.UIDropDownMenu_AddButton(CreateFilterInfo(L.SORT_REVERSE, 'descending', settings), level)
        EDDM.UIDropDownMenu_AddButton(CreateFilterInfo(L.SORT_FAVORITES_FIRST, 'favoritesOnTop', settings), level)
        EDDM.UIDropDownMenu_AddButton(CreateFilterInfo(L.SORT_UNOWNED_BOTTOM, 'unownedOnBottom', settings), level)
        EDDM.UIDropDownMenu_AddSpace(level)

        info = CreateFilterInfo(NEWBIE_TOOLTIP_STOPWATCH_RESETBUTTON)
        info.keepShownOnClick = false
        info.func = function(_, _, _, value)
            ADDON:ResetSortSettings()
            ADDON:UpdateIndexMap()
            MountJournal_UpdateMountList()
        end
        EDDM.UIDropDownMenu_AddButton(info, level)
    end
end

ADDON:RegisterLoadUICallback(function()
    local menu = EDDM.UIDropDownMenu_Create(ADDON_NAME .. "FilterMenu", MountJournalFilterButton)
    EDDM.UIDropDownMenu_Initialize(menu, InitializeFilterDropDown, "MENU")

    MountJournalFilterButton:SetScript("OnMouseDown", function(sender, button)
        UIMenuButtonStretchMixin.OnMouseDown(sender, button);
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        EDDM.ToggleDropDownMenu(1, nil, menu, sender, 74, 15)
    end)
end)