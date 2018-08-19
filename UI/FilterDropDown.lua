local ADDON_NAME, ADDON = ...
local L = ADDON.L

local SETTING_COLLECTED = "collected"
local SETTING_ONLY_FAVORITES = "onlyFavorites"
local SETTING_NOT_COLLECTED = "notCollected"
local SETTING_ONLY_USEABLE = "onlyUsable"
local SETTING_SOURCE = "source"
local SETTING_MOUNT_TYPE = "mountType"
local SETTING_FACTION = "faction"
local SETTING_FAMILY = "family"
local SETTING_EXPANSION = "expansion"
local SETTING_HIDDEN = "hidden"

local function CreateFilterInfo(text, filterKey, filterSettings, callback)
    local info = MSA_DropDownMenu_CreateInfo()
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
        info.checked = function(self) return self.arg1[filterKey] end
        info.func = function(_, arg1, _, value)
            arg1[filterKey] = value
            ADDON:UpdateIndexMap()
            MountJournal_UpdateMountList()
            if (MSA_DROPDOWNMENU_MENU_LEVEL > 1) then
                for i=1, MSA_DROPDOWNMENU_MENU_LEVEL do
                    MSA_DropDownMenu_Refresh(_G[ADDON_NAME .. "FilterMenu"], nil, i)
                end
            end

            if callback then
                callback(value)
            end
        end
    else
        info.notCheckable = true
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

    if (MSA_DROPDOWNMENU_MENU_LEVEL ~= 2) then
        MSA_DropDownMenu_Refresh(_G[ADDON_NAME .. "FilterMenu"], nil, 2)
    end
    MSA_DropDownMenu_Refresh(_G[ADDON_NAME .. "FilterMenu"])
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

local function CreateInfoWithMenu(text, filterKey, settings, dropdownLevel)
    local info = MSA_DropDownMenu_CreateInfo()
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
    MSA_DropDownMenu_AddButton(info, level)

    info = CreateFilterInfo(UNCHECK_ALL)
    info.func = function()
        SetAllSubFilters(settings, false)
    end
    MSA_DropDownMenu_AddButton(info, level)
end

local function MakeMultiColumnMenu(level, entriesPerColumn)
    local listFrame = _G["MSA_DropDownList" .. level]
    local columnWidth = listFrame.maxWidth + 25

    local listFrameName = listFrame:GetName()
    local columnIndex = 0
    for index = entriesPerColumn + 1, listFrame.numButtons do
        columnIndex = math.ceil(index / entriesPerColumn)
        local button = _G[listFrameName .. "Button" .. index]
        local yPos = -((button:GetID() - 1 - entriesPerColumn * (columnIndex - 1)) * MSA_DROPDOWNMENU_BUTTON_HEIGHT) - MSA_DROPDOWNMENU_BORDER_HEIGHT

        button:ClearAllPoints()
        button:SetPoint("TOPLEFT", button:GetParent(), "TOPLEFT", columnWidth * (columnIndex - 1), yPos)
        button:SetWidth(columnWidth)
    end

    listFrame:SetHeight((min(listFrame.numButtons, entriesPerColumn) * MSA_DROPDOWNMENU_BUTTON_HEIGHT) + (MSA_DROPDOWNMENU_BORDER_HEIGHT * 2))
    listFrame:SetWidth(columnWidth * columnIndex)

    ADDON:Hook(nil, "MSA_DropDownMenu_OnHide", function(sender)
        ADDON:Unhook(listFrame, "SetWidth")
        ADDON:Unhook(nil, "MSA_DropDownMenu_OnHide")
        MSA_DropDownMenu_OnHide(sender)
    end)
    ADDON:Hook(listFrame, "SetWidth", function() end)
end

local function InitializeFilterDropDown(filterMenu, level)
    local info

    if (level == 1) then
        info = CreateFilterInfo(COLLECTED, SETTING_COLLECTED, nil, function(value)
            if (value) then
                MSA_DropDownMenu_EnableButton(1, 2)
            else
                MSA_DropDownMenu_DisableButton(1, 2)
            end
        end)
        MSA_DropDownMenu_AddButton(info, level)

        info = CreateFilterInfo(FAVORITES_FILTER, SETTING_ONLY_FAVORITES)
        info.leftPadding = 16
        info.disabled = not ADDON.settings.filter.collected
        MSA_DropDownMenu_AddButton(info, level)
        MSA_DropDownMenu_AddButton(CreateFilterInfo(NOT_COLLECTED, SETTING_NOT_COLLECTED), level)
        MSA_DropDownMenu_AddButton(CreateFilterInfo(L["Only usable"], SETTING_ONLY_USEABLE), level)

        MSA_DropDownMenu_AddButton(CreateFilterCategory(SOURCES, SETTING_SOURCE), level)
        MSA_DropDownMenu_AddButton(CreateFilterCategory(TYPE, SETTING_MOUNT_TYPE), level)
        MSA_DropDownMenu_AddButton(CreateFilterCategory(FACTION, SETTING_FACTION), level)
        MSA_DropDownMenu_AddButton(CreateFilterCategory(L["Family"], SETTING_FAMILY), level)
        MSA_DropDownMenu_AddButton(CreateFilterCategory(EXPANSION_FILTER_TEXT, SETTING_EXPANSION), level)

        MSA_DropDownMenu_AddButton(CreateFilterInfo(L["Hidden"], SETTING_HIDDEN), level)
        info = CreateFilterInfo(L["Reset filters"])
        info.keepShownOnClick = false
        info.func = function(_, _, _, value)
            ADDON:ResetFilterSettings();
            ADDON:UpdateIndexMap()
            MountJournal_UpdateMountList()
        end
        MSA_DropDownMenu_AddButton(info, level)
    elseif (MSA_DROPDOWNMENU_MENU_VALUE == SETTING_SOURCE) then
        local settings = ADDON.settings.filter[SETTING_SOURCE]
        AddCheckAllAndNoneInfo(settings, level)
        MSA_DropDownMenu_AddButton(CreateFilterInfo(BATTLE_PET_SOURCE_1, "Drop", settings), level)
        MSA_DropDownMenu_AddButton(CreateFilterInfo(BATTLE_PET_SOURCE_2, "Quest", settings), level)
        MSA_DropDownMenu_AddButton(CreateFilterInfo(BATTLE_PET_SOURCE_3, "Vendor", settings), level)
        MSA_DropDownMenu_AddButton(CreateFilterInfo(BATTLE_PET_SOURCE_4, "Profession", settings), level)
        MSA_DropDownMenu_AddButton(CreateFilterInfo(INSTANCE, "Instance", settings), level)
        MSA_DropDownMenu_AddButton(CreateFilterInfo(REPUTATION, "Reputation", settings), level)
        MSA_DropDownMenu_AddButton(CreateFilterInfo(BATTLE_PET_SOURCE_6, "Achievement", settings), level)
        MSA_DropDownMenu_AddButton(CreateFilterInfo(ISLANDS_HEADER, "Island Expedition", settings), level)
        MSA_DropDownMenu_AddButton(CreateFilterInfo(GARRISON_LOCATION_TOOLTIP, "Garrison", settings), level)
        MSA_DropDownMenu_AddButton(CreateFilterInfo(PVP, "PVP", settings), level)
        MSA_DropDownMenu_AddButton(CreateFilterInfo(CLASS, "Class", settings), level)
        MSA_DropDownMenu_AddButton(CreateFilterInfo(BATTLE_PET_SOURCE_7, "World Event", settings), level)
        MSA_DropDownMenu_AddButton(CreateFilterInfo(L["Black Market"], "Black Market", settings), level)
        MSA_DropDownMenu_AddButton(CreateFilterInfo(BATTLE_PET_SOURCE_10, "Shop", settings), level)
        MSA_DropDownMenu_AddButton(CreateFilterInfo(BATTLE_PET_SOURCE_8, "Promotion", settings), level)
    elseif (MSA_DROPDOWNMENU_MENU_VALUE == SETTING_MOUNT_TYPE) then
        local settings = ADDON.settings.filter[SETTING_MOUNT_TYPE]
        AddCheckAllAndNoneInfo(settings, level)
        MSA_DropDownMenu_AddButton(CreateFilterInfo(L["Ground"], "ground", settings), level)
        MSA_DropDownMenu_AddButton(CreateFilterInfo(L["Flying"], "flying", settings), level)
        MSA_DropDownMenu_AddButton(CreateFilterInfo(L["Water Walking"], "waterWalking", settings), level)
        MSA_DropDownMenu_AddButton(CreateFilterInfo(L["Underwater"], "underwater", settings), level)
        MSA_DropDownMenu_AddButton(CreateFilterInfo(L["Transform"], "transform", settings), level)
        MSA_DropDownMenu_AddButton(CreateFilterInfo(MINIMAP_TRACKING_REPAIR, "repair", settings), level)
        MSA_DropDownMenu_AddButton(CreateFilterInfo(L["Passenger"], "passenger", settings), level)
    elseif (MSA_DROPDOWNMENU_MENU_VALUE == SETTING_FACTION) then
        local settings = ADDON.settings.filter[SETTING_FACTION]
        MSA_DropDownMenu_AddButton(CreateFilterInfo(FACTION_ALLIANCE, "alliance", settings), level)
        MSA_DropDownMenu_AddButton(CreateFilterInfo(FACTION_HORDE, "horde", settings), level)
        MSA_DropDownMenu_AddButton(CreateFilterInfo(NPC_NAMES_DROPDOWN_NONE, "noFaction", settings), level)
    elseif (MSA_DROPDOWNMENU_MENU_VALUE == SETTING_FAMILY) then
        local settings = ADDON.settings.filter[SETTING_FAMILY]
        local sortedFamilies, hasSubFamilies = {}, {}
        AddCheckAllAndNoneInfo(settings, level)

        for family, mainConfig in pairs(ADDON.MountJournalEnhancedFamily) do
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
        table.sort(sortedFamilies, function(a, b) return (L[a] or a) < (L[b] or b) end)

        for _, family in pairs(sortedFamilies) do
            if hasSubFamilies[family] then
                MSA_DropDownMenu_AddButton(CreateInfoWithMenu(L[family] or family, family, settings[family]), level)
            else
                MSA_DropDownMenu_AddButton(CreateFilterInfo(L[family] or family, family, settings), level)
            end
        end
    elseif (MSA_DROPDOWNMENU_MENU_VALUE == SETTING_EXPANSION) then
        local settings = ADDON.settings.filter[SETTING_EXPANSION]
        AddCheckAllAndNoneInfo(settings, level)
        for i = 0, 7 do
            MSA_DropDownMenu_AddButton(CreateFilterInfo(_G["EXPANSION_NAME" .. i], i, settings), level)
        end
    elseif (level == 3 and ADDON.MountJournalEnhancedFamily[MSA_DROPDOWNMENU_MENU_VALUE]) then
        local settings = ADDON.settings.filter[SETTING_FAMILY][MSA_DROPDOWNMENU_MENU_VALUE]
        local sortedFamilies = {}
        for family, _ in pairs(ADDON.MountJournalEnhancedFamily[MSA_DROPDOWNMENU_MENU_VALUE]) do
            table.insert(sortedFamilies, family)
        end
        table.sort(sortedFamilies, function(a, b) return (L[a] or a) < (L[b] or b) end)
        for _, family in pairs(sortedFamilies) do
            local info = CreateFilterInfo(L[family] or family, family, settings)
            MSA_DropDownMenu_AddButton(info, level)
        end
    end
end

hooksecurefunc(ADDON, "LoadUI", function()
    local menu = CreateFrame("Button", ADDON_NAME .. "FilterMenu", MountJournalFilterButton, "MSA_DropDownMenuTemplate")
    MSA_DropDownMenu_Initialize(menu, InitializeFilterDropDown, "MENU")
    MountJournalFilterButton:SetScript("OnClick", function(sender)
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        MSA_ToggleDropDownMenu(1, nil, menu, sender, 74, 15)
    end)
end)