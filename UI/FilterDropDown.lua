local ADDON_NAME, ADDON = ...
local L = ADDON.L

local function GetSourceOrder()
    return { "Drop", "Quest", "Vendor", "Profession", "Instance", "Reputation", "Achievement", "Island Expedition", "Garrison", "PVP", "Class", "World Event", "Black Market", "Shop", "Promotion" }
end

local function GetExpansionOrder()
    return { "Classic", "The Burning Crusade", "Wrath of the Lich King", "Cataclysm", "Mists of Pandaria", "Warlords of Draenor", "Legion", "Battle for Azeroth" }
end

local function CreateFilterInfo(text, filterKey, subfilterKey, callback)
    local info = MSA_DropDownMenu_CreateInfo()
    info.keepShownOnClick = true
    info.isNotRadio = true
    info.text = text

    if filterKey then
        info.hasArrow = false
        info.notCheckable = false
        if subfilterKey then
            info.checked = function() return ADDON.settings.filter[filterKey][subfilterKey] end
        else
            info.checked = ADDON.settings.filter[filterKey]
        end
        info.func = function(_, _, _, value)
            if subfilterKey then
                ADDON.settings.filter[filterKey][subfilterKey] = value
            else
                ADDON.settings.filter[filterKey] = value
            end
            ADDON:UpdateIndexMap()
            MountJournal_UpdateMountList()

            if callback then
                callback(value)
            end
        end
    else
        info.hasArrow = true
        info.notCheckable = true
    end

    return info
end

local function AddCheckAllAndNoneInfo(sender, filterKey, level, dropdownLevel)
    local info = CreateFilterInfo(CHECK_ALL)
    info.hasArrow = false
    info.func = function()
        for key, _ in pairs(ADDON.settings.filter[filterKey]) do
            ADDON.settings.filter[filterKey][key] = true
        end

        MSA_DropDownMenu_Refresh(sender, dropdownLevel, 2)
        ADDON:UpdateIndexMap()
        MountJournal_UpdateMountList()
    end
    MSA_DropDownMenu_AddButton(info, level)

    info = CreateFilterInfo(UNCHECK_ALL)
    info.hasArrow = false
    info.func = function()
        for key, _ in pairs(ADDON.settings.filter[filterKey]) do
            ADDON.settings.filter[filterKey][key] = false
        end

        MSA_DropDownMenu_Refresh(sender, dropdownLevel, 2)
        ADDON:UpdateIndexMap()
        MountJournal_UpdateMountList()
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

local function InitializeFilterDropDown(sender, level)
    local info

    if (level == 1) then
        info = CreateFilterInfo(COLLECTED, "collected", nil, function(value)
            if (value) then
                MSA_DropDownMenu_EnableButton(1, 2)
            else
                MSA_DropDownMenu_DisableButton(1, 2)
            end
        end)
        MSA_DropDownMenu_AddButton(info, level)

        info = CreateFilterInfo(FAVORITES_FILTER, "onlyFavorites")
        info.leftPadding = 16
        info.disabled = not ADDON.settings.filter.collected
        MSA_DropDownMenu_AddButton(info, level)

        info = CreateFilterInfo(NOT_COLLECTED, "notCollected")
        MSA_DropDownMenu_AddButton(info, level)

        info = CreateFilterInfo(L["Only usable"], "onlyUsable")
        MSA_DropDownMenu_AddButton(info, level)

        info = CreateFilterInfo(SOURCES)
        info.value = 1
        MSA_DropDownMenu_AddButton(info, level)

        info = CreateFilterInfo(TYPE)
        info.value = 2
        MSA_DropDownMenu_AddButton(info, level)

        info = CreateFilterInfo(FACTION)
        info.value = 3
        MSA_DropDownMenu_AddButton(info, level)

        info = CreateFilterInfo(L["Family"])
        info.value = 4
        MSA_DropDownMenu_AddButton(info, level)

        info = CreateFilterInfo(L["Expansion"])
        info.value = 5
        MSA_DropDownMenu_AddButton(info, level)

        info = CreateFilterInfo(L["Hidden"], "hidden")
        MSA_DropDownMenu_AddButton(info, level)

        info = CreateFilterInfo(L["Reset filters"])
        info.keepShownOnClick = false
        info.hasArrow = false
        info.func = function(_, _, _, value)
            ADDON:ResetFilterSettings();
            ADDON:UpdateIndexMap()
            MountJournal_UpdateMountList()
        end
        MSA_DropDownMenu_AddButton(info, level)
    elseif (MSA_DROPDOWNMENU_MENU_VALUE == 1) then
        AddCheckAllAndNoneInfo(sender, "source", level, 1)
        for _, categoryName in pairs(GetSourceOrder()) do
            info = CreateFilterInfo(L[categoryName] or categoryName, "source", categoryName)
            MSA_DropDownMenu_AddButton(info, level)
        end
    elseif (MSA_DROPDOWNMENU_MENU_VALUE == 2) then
        AddCheckAllAndNoneInfo(sender, "mountType", level, 2)

        info = CreateFilterInfo(L["Ground"], "mountType", "ground")
        MSA_DropDownMenu_AddButton(info, level)
        info = CreateFilterInfo(L["Flying"], "mountType", "flying")
        MSA_DropDownMenu_AddButton(info, level)
        info = CreateFilterInfo(L["Water Walking"], "mountType", "waterWalking")
        MSA_DropDownMenu_AddButton(info, level)
        info = CreateFilterInfo(L["Underwater"], "mountType", "underwater")
        MSA_DropDownMenu_AddButton(info, level)
        info = CreateFilterInfo(L["Transform"], "mountType", "transform")
        MSA_DropDownMenu_AddButton(info, level)
        info = CreateFilterInfo(L["Repair"], "mountType", "repair")
        MSA_DropDownMenu_AddButton(info, level)
        info = CreateFilterInfo(L["Passenger"], "mountType", "passenger")
        MSA_DropDownMenu_AddButton(info, level)
    elseif (MSA_DROPDOWNMENU_MENU_VALUE == 3) then
        info = CreateFilterInfo(FACTION_ALLIANCE, "faction", "alliance")
        MSA_DropDownMenu_AddButton(info, level)
        info = CreateFilterInfo(FACTION_HORDE, "faction", "horde")
        MSA_DropDownMenu_AddButton(info, level)
        info = CreateFilterInfo(NPC_NAMES_DROPDOWN_NONE, "faction", "noFaction")
        MSA_DropDownMenu_AddButton(info, level)
    elseif (MSA_DROPDOWNMENU_MENU_VALUE == 4) then
        AddCheckAllAndNoneInfo(sender, "family", level, 4)

        local sortedFamilies = {}
        for family, _ in pairs(ADDON.MountJournalEnhancedFamily) do
            table.insert(sortedFamilies, family)
        end
        table.sort(sortedFamilies, function(a, b) return (L[a] or a) < (L[b] or b) end)

        for _, family in pairs(sortedFamilies) do
            info = CreateFilterInfo(L[family] or family, "family", family)
            MSA_DropDownMenu_AddButton(info, level)
        end

        MakeMultiColumnMenu(level, 21)
    elseif (MSA_DROPDOWNMENU_MENU_VALUE == 5) then
        AddCheckAllAndNoneInfo(sender, "expansion", level, 5)

        for _, expansion in pairs(GetExpansionOrder()) do
            info = CreateFilterInfo(L[expansion] or expansion, "expansion", expansion)
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