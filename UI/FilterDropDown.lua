local ADDON_NAME, ADDON = ...
local L = ADDON.L

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
local SETTING_HIDDEN_INGAME = "hiddenIngame"
local SETTING_SORT = "sort"

local function CreateFilterInfo(text, filterKey, filterSettings, toggleButtons)
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
            ADDON.Api:UpdateIndex()
            ADDON.UI:UpdateMountList()
            UIDropDownMenu_RefreshAll(_G[ADDON_NAME .. "FilterMenu"])

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

    UIDropDownMenu_RefreshAll(_G[ADDON_NAME .. "FilterMenu"])
    ADDON.Api:UpdateIndex()
    ADDON.UI:UpdateMountList()
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
    local info = {
        text = text,
        value = filterKey,
        keepShownOnClick = true,
        notCheckable = false,
        hasArrow = true,
    }

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
    UIDropDownMenu_AddButton(info, level)

    info = CreateFilterInfo(UNCHECK_ALL)
    info.func = function()
        SetAllSubFilters(settings, false)
    end
    UIDropDownMenu_AddButton(info, level)
end

local function ShouldDisplayFamily(mountIds)
    if ADDON.settings.filter[SETTING_HIDDEN_INGAME] then
        return true
    end

    for mountId, _ in pairs(mountIds) do
        local _, _, _, _, _, _, _, _, _, shouldHideOnChar = C_MountJournal.GetMountInfoByID(mountId)
        if shouldHideOnChar == false then
            return true
        end
    end

    return false
end

local function HasUserHiddenMounts()
    for _, value in pairs(ADDON.settings.hiddenMounts) do
        if value == true then
            return true
        end
    end

    return false
end

local function InitializeFilterDropDown(filterMenu, level)
    local info

    if level == 1 then
        UIDropDownMenu_AddButton(CreateFilterCategory(CLUB_FINDER_SORT_BY, SETTING_SORT), level)
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

        UIDropDownMenu_AddButton(CreateFilterInfo(L["Only tradable"], SETTING_ONLY_TRADABLE), level)

        if ADDON.settings.filter[SETTING_HIDDEN] or HasUserHiddenMounts() then
            UIDropDownMenu_AddButton(CreateFilterInfo(L["Hidden"], SETTING_HIDDEN), level)
        end

        UIDropDownMenu_AddSpace(level)

        UIDropDownMenu_AddButton(CreateFilterCategory(SOURCES, SETTING_SOURCE), level)
        UIDropDownMenu_AddButton(CreateFilterCategory(TYPE, SETTING_MOUNT_TYPE), level)
        UIDropDownMenu_AddButton(CreateFilterCategory(FACTION, SETTING_FACTION), level)
        UIDropDownMenu_AddButton(CreateFilterCategory(L["Family"], SETTING_FAMILY), level)
        UIDropDownMenu_AddButton(CreateFilterCategory(EXPANSION_FILTER_TEXT, SETTING_EXPANSION), level)
        UIDropDownMenu_AddSpace(level)

        info = CreateFilterInfo(L["Reset filters"])
        info.keepShownOnClick = false
        info.func = function(_, _, _, value)
            ADDON:ResetFilterSettings()
            ADDON.Api:UpdateIndex()
            ADDON.UI:UpdateMountList()
        end
        UIDropDownMenu_AddButton(info, level)
    elseif UIDROPDOWNMENU_MENU_VALUE == SETTING_SOURCE then
        local settings = ADDON.settings.filter[SETTING_SOURCE]
        AddCheckAllAndNoneInfo(settings, level)
        UIDropDownMenu_AddButton(CreateFilterInfo(BATTLE_PET_SOURCE_1, "Drop", settings), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(BATTLE_PET_SOURCE_2, "Quest", settings), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(BATTLE_PET_SOURCE_3, "Vendor", settings), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(BATTLE_PET_SOURCE_4, "Profession", settings), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(INSTANCE, "Instance", settings), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(REPUTATION, "Reputation", settings), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(BATTLE_PET_SOURCE_6, "Achievement", settings), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(GetCategoryInfo(15441), "Covenants", settings), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(ISLANDS_HEADER, "Island Expedition", settings), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(GARRISON_LOCATION_TOOLTIP, "Garrison", settings), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(PVP, "PVP", settings), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(CLASS, "Class", settings), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(BATTLE_PET_SOURCE_7, "World Event", settings), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(L["Black Market"], "Black Market", settings), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(BATTLE_PET_SOURCE_10, "Shop", settings), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(BATTLE_PET_SOURCE_8, "Promotion", settings), level)
    elseif (UIDROPDOWNMENU_MENU_VALUE == SETTING_MOUNT_TYPE) then
        local settings = ADDON.settings.filter[SETTING_MOUNT_TYPE]
        AddCheckAllAndNoneInfo(settings, level)
        UIDropDownMenu_AddButton(CreateFilterInfo(L["Flying"], "flying", settings), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(L["Ground"], "ground", settings), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(L["Underwater"], "underwater", settings), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(L["Transform"], "transform", settings), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(MINIMAP_TRACKING_REPAIR, "repair", settings), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(L["Passenger"], "passenger", settings), level)
    elseif (UIDROPDOWNMENU_MENU_VALUE == SETTING_FACTION) then
        local settings = ADDON.settings.filter[SETTING_FACTION]
        UIDropDownMenu_AddButton(CreateFilterInfo(FACTION_ALLIANCE, "alliance", settings), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(FACTION_HORDE, "horde", settings), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(NPC_NAMES_DROPDOWN_NONE, "noFaction", settings), level)
    elseif (UIDROPDOWNMENU_MENU_VALUE == SETTING_FAMILY) then
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
                UIDropDownMenu_AddButton(CreateInfoWithMenu(L[family] or family, family, settings[family]), level)
            else
                UIDropDownMenu_AddButton(CreateFilterInfo(L[family] or family, family, settings), level)
            end
        end
    elseif (UIDROPDOWNMENU_MENU_VALUE == SETTING_EXPANSION) then
        local settings = ADDON.settings.filter[SETTING_EXPANSION]
        AddCheckAllAndNoneInfo(settings, level)
        for i = 0, #ADDON.DB.Expansion do
            UIDropDownMenu_AddButton(CreateFilterInfo(_G["EXPANSION_NAME" .. i], i, settings), level)
        end
    elseif (level == 3 and ADDON.DB.Family[UIDROPDOWNMENU_MENU_VALUE]) then
        local settings = ADDON.settings.filter[SETTING_FAMILY][UIDROPDOWNMENU_MENU_VALUE]
        local sortedFamilies = {}
        for family, familyIds in pairs(ADDON.DB.Family[UIDROPDOWNMENU_MENU_VALUE]) do
            if ShouldDisplayFamily(familyIds) then
                table.insert(sortedFamilies, family)
            end
        end
        table.sort(sortedFamilies, function(a, b)
            return (L[a] or a) < (L[b] or b)
        end)
        for _, family in pairs(sortedFamilies) do
            UIDropDownMenu_AddButton(CreateFilterInfo(L[family] or family, family, settings), level)
        end
    elseif UIDROPDOWNMENU_MENU_VALUE == SETTING_SORT then
        local settings = ADDON.settings[SETTING_SORT]
        UIDropDownMenu_AddButton(CreateFilterRadio(NAME, "by", settings, 'name'), level)
        UIDropDownMenu_AddButton(CreateFilterRadio(TYPE, "by", settings, 'type'), level)
        UIDropDownMenu_AddButton(CreateFilterRadio(EXPANSION_FILTER_TEXT, "by", settings, 'expansion'), level)

        local trackingEnabled = ADDON.settings.trackUsageStats
        info = CreateFilterRadio(L.SORT_BY_USAGE_COUNT, "by", settings, 'usage_count')
        info.disabled = not trackingEnabled
        UIDropDownMenu_AddButton(info, level)
        info = CreateFilterRadio(L.SORT_BY_LAST_USAGE, "by", settings, 'last_usage')
        info.disabled = not trackingEnabled
        UIDropDownMenu_AddButton(info, level)
        info = CreateFilterRadio(L.SORT_BY_LEARNED_DATE, "by", settings, 'learned_date')
        info.disabled = not trackingEnabled
        UIDropDownMenu_AddButton(info, level)
        info = CreateFilterRadio(L.SORT_BY_TRAVEL_DURATION, "by", settings, 'travel_duration')
        info.disabled = not trackingEnabled
        UIDropDownMenu_AddButton(info, level)
        info = CreateFilterRadio(L.SORT_BY_TRAVEL_DISTANCE, "by", settings, 'travel_distance')
        info.disabled = not trackingEnabled
        UIDropDownMenu_AddButton(info, level)

        UIDropDownMenu_AddSpace(level)
        UIDropDownMenu_AddButton(CreateFilterInfo(L.SORT_REVERSE, 'descending', settings), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(L.SORT_FAVORITES_FIRST, 'favoritesOnTop', settings), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(L.SORT_UNUSABLE_BOTTOM, 'unusableToBottom', settings), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(L.SORT_UNOWNED_BOTTOM, 'unownedOnBottom', settings), level)
        UIDropDownMenu_AddSpace(level)

        info = CreateFilterInfo(NEWBIE_TOOLTIP_STOPWATCH_RESETBUTTON)
        info.keepShownOnClick = false
        info.func = function(_, _, _, value)
            ADDON:ResetSortSettings()
            ADDON.Api:UpdateIndex()
            ADDON.UI:UpdateMountList()
        end
        UIDropDownMenu_AddButton(info, level)
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
end, "filter dropdown")