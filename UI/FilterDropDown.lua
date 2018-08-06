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

local function GetSourceOrder()
    return { "Drop", "Quest", "Vendor", "Profession", "Instance", "Reputation", "Achievement", "Island Expedition", "Garrison", "PVP", "Class", "World Event", "Black Market", "Shop", "Promotion" }
end

local function CreateFilterInfo(text, filterKey, subfilterKey, callback)
    local info = MSA_DropDownMenu_CreateInfo()
    info.keepShownOnClick = true
    info.isNotRadio = true
    info.hasArrow = false
    info.text = text

    if filterKey then
        info.notCheckable = false
        if subfilterKey then
            info.checked = function() return ADDON.settings.filter[filterKey][subfilterKey] end
        else
            info.checked = function() return ADDON.settings.filter[filterKey] end
        end
        info.func = function(_, _, _, value)
            if subfilterKey then
                ADDON.settings.filter[filterKey][subfilterKey] = value
            else
                ADDON.settings.filter[filterKey] = value
            end
            ADDON:UpdateIndexMap()
            MountJournal_UpdateMountList()
            MSA_DropDownMenu_Refresh(_G[ADDON_NAME .. "FilterMenu"], nil, 1)

            if callback then
                callback(value)
            end
        end
    else
        info.notCheckable = true
    end

    return info
end

local function CheckSetting(filterKey)
    local hasTrue, hasFalse = false, false
    for _, v in pairs(ADDON.settings.filter[filterKey]) do
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

local function SetAllSubFilters(filterKey, switch, dropdownLevel)
    for key, _ in pairs(ADDON.settings.filter[filterKey]) do
        ADDON.settings.filter[filterKey][key] = switch
    end

    MSA_DropDownMenu_Refresh(_G[ADDON_NAME .. "FilterMenu"], dropdownLevel, 2)
    MSA_DropDownMenu_Refresh(_G[ADDON_NAME .. "FilterMenu"], nil, 1)
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

local function CreateInfoWithMenu(text, filterKey, dropdownLevel)
    local info = MSA_DropDownMenu_CreateInfo()
    info.text = text
    info.value = filterKey
    info.keepShownOnClick = true
    info.notCheckable = false
    info.hasArrow = true

    local hasTrue, hasFalse = CheckSetting(filterKey)
    info.isNotRadio = not hasTrue or not hasFalse

    info.checked = function(button)
        local hasTrue, hasFalse = CheckSetting(filterKey)
        RefreshCategoryButton(button, not hasTrue or not hasFalse)
        return hasTrue
    end
    info.func = function(button, _,_, value)
        if button.isNotRadio == value then
            SetAllSubFilters(filterKey, true, dropdownLevel)
        elseif true == button.isNotRadio and false == value then
            SetAllSubFilters(filterKey, false, dropdownLevel)
        end
    end

    return info
end

local function AddCheckAllAndNoneInfo(filterKey, level, dropdownLevel)
    local info = CreateFilterInfo(CHECK_ALL)
    info.func = function()
        SetAllSubFilters(filterKey, true, dropdownLevel)
    end
    MSA_DropDownMenu_AddButton(info, level)

    info = CreateFilterInfo(UNCHECK_ALL)
    info.func = function()
        SetAllSubFilters(filterKey, false, dropdownLevel)
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

        MSA_DropDownMenu_AddButton(CreateInfoWithMenu(SOURCES, SETTING_SOURCE, 1), level)
        MSA_DropDownMenu_AddButton(CreateInfoWithMenu(TYPE, SETTING_MOUNT_TYPE, 2), level)
        MSA_DropDownMenu_AddButton(CreateInfoWithMenu(FACTION, SETTING_FACTION, 3), level)
        MSA_DropDownMenu_AddButton(CreateInfoWithMenu(L["Family"], SETTING_FAMILY, 4), level)
        MSA_DropDownMenu_AddButton(CreateInfoWithMenu(EXPANSION_FILTER_TEXT, SETTING_EXPANSION, 5), level)

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
        AddCheckAllAndNoneInfo(SETTING_SOURCE, level, 1)
        for _, categoryName in pairs(GetSourceOrder()) do
            MSA_DropDownMenu_AddButton(CreateFilterInfo(L[categoryName] or categoryName, SETTING_SOURCE, categoryName), level)
        end
    elseif (MSA_DROPDOWNMENU_MENU_VALUE == SETTING_MOUNT_TYPE) then
        AddCheckAllAndNoneInfo(SETTING_MOUNT_TYPE, level, 2)
        MSA_DropDownMenu_AddButton(CreateFilterInfo(L["Ground"], SETTING_MOUNT_TYPE, "ground"), level)
        MSA_DropDownMenu_AddButton(CreateFilterInfo(L["Flying"], SETTING_MOUNT_TYPE, "flying"), level)
        MSA_DropDownMenu_AddButton(CreateFilterInfo(L["Water Walking"], SETTING_MOUNT_TYPE, "waterWalking"), level)
        MSA_DropDownMenu_AddButton(CreateFilterInfo(L["Underwater"], SETTING_MOUNT_TYPE, "underwater"), level)
        MSA_DropDownMenu_AddButton(CreateFilterInfo(L["Transform"], SETTING_MOUNT_TYPE, "transform"), level)
        MSA_DropDownMenu_AddButton(CreateFilterInfo(L["Repair"], SETTING_MOUNT_TYPE, "repair"), level)
        MSA_DropDownMenu_AddButton(CreateFilterInfo(L["Passenger"], SETTING_MOUNT_TYPE, "passenger"), level)
    elseif (MSA_DROPDOWNMENU_MENU_VALUE == SETTING_FACTION) then
        MSA_DropDownMenu_AddButton(CreateFilterInfo(FACTION_ALLIANCE, SETTING_FACTION, "alliance"), level)
        MSA_DropDownMenu_AddButton(CreateFilterInfo(FACTION_HORDE, SETTING_FACTION, "horde"), level)
        MSA_DropDownMenu_AddButton(CreateFilterInfo(NPC_NAMES_DROPDOWN_NONE, SETTING_FACTION, "noFaction"), level)
    elseif (MSA_DROPDOWNMENU_MENU_VALUE == SETTING_FAMILY) then
        AddCheckAllAndNoneInfo(SETTING_FAMILY, level, 4)
        local sortedFamilies = {}
        for family, _ in pairs(ADDON.MountJournalEnhancedFamily) do
            table.insert(sortedFamilies, family)
        end
        table.sort(sortedFamilies, function(a, b) return (L[a] or a) < (L[b] or b) end)

        for _, family in pairs(sortedFamilies) do
            MSA_DropDownMenu_AddButton(CreateFilterInfo(L[family] or family, SETTING_FAMILY, family), level)
        end

        MakeMultiColumnMenu(level, 21)
    elseif (MSA_DROPDOWNMENU_MENU_VALUE == SETTING_EXPANSION) then
        AddCheckAllAndNoneInfo(SETTING_EXPANSION, level, 5)
        for i=0, 7 do
            MSA_DropDownMenu_AddButton(CreateFilterInfo(_G["EXPANSION_NAME"..i], SETTING_EXPANSION, i), level)
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