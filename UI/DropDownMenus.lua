local ADDON_NAME, ADDON = ...
local L = ADDON.L

local function GetSourceOrder()
    return { "Drop", "Quest", "Vendor", "Profession", "Instance", "Reputation", "Achievement", "Island Expedition", "Garrison", "PVP", "Class", "World Event", "Black Market", "Shop", "Promotion"}
end

local function GetExpansionOrder()
    return { "Classic", "The Burning Crusade", "Wrath of the Lich King", "Cataclysm", "Mists of Pandaria", "Warlords of Draenor", "Legion", "Battle for Azeroth" }
end

local function CreateFilterInfo(text, filterKey, subfilterKey, callback)
    local info = UIDropDownMenu_CreateInfo()
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

local function AddCheckAllAndNoneInfo(filterKey, level, dropdownLevel)
    local info = CreateFilterInfo(CHECK_ALL)
    info.hasArrow = false
    info.func = function()
        for key, _ in pairs(ADDON.settings.filter[filterKey]) do
            ADDON.settings.filter[filterKey][key] = true
        end

        UIDropDownMenu_Refresh(MountJournalFilterDropDown, dropdownLevel, 2)
        ADDON:UpdateIndexMap()
        MountJournal_UpdateMountList()
    end
    UIDropDownMenu_AddButton(info, level)

    info = CreateFilterInfo(UNCHECK_ALL)
    info.hasArrow = false
    info.func = function()
        for key, _ in pairs(ADDON.settings.filter[filterKey]) do
            ADDON.settings.filter[filterKey][key] = false
        end

        UIDropDownMenu_Refresh(MountJournalFilterDropDown, dropdownLevel, 2)
        ADDON:UpdateIndexMap()
        MountJournal_UpdateMountList()
    end
    UIDropDownMenu_AddButton(info, level)
end

local function MakeMultiColumnMenu(level, entriesPerColumn)
    local listFrame = _G["DropDownList"..level]
    local columnWidth = listFrame.maxWidth + 25

    local listFrameName = listFrame:GetName()
    local columnIndex = 0
    for index = entriesPerColumn + 1, listFrame.numButtons do
        columnIndex = math.ceil(index / entriesPerColumn)
        local button = _G[listFrameName.."Button"..index]
        local yPos = -((button:GetID() - 1 - entriesPerColumn * (columnIndex - 1)) * UIDROPDOWNMENU_BUTTON_HEIGHT) - UIDROPDOWNMENU_BORDER_HEIGHT

        button:ClearAllPoints()
        button:SetPoint("TOPLEFT", button:GetParent(), "TOPLEFT", columnWidth * (columnIndex - 1), yPos)
        button:SetWidth(columnWidth)
    end

    listFrame:SetHeight((min(listFrame.numButtons, entriesPerColumn) * UIDROPDOWNMENU_BUTTON_HEIGHT) + (UIDROPDOWNMENU_BORDER_HEIGHT * 2))
    listFrame:SetWidth(columnWidth * columnIndex)

    ADDON:Hook(nil, "UIDropDownMenu_OnHide", function(sender)
        ADDON:Unhook(listFrame, "SetWidth")
        ADDON:Unhook(nil, "UIDropDownMenu_OnHide")
        UIDropDownMenu_OnHide(sender)
    end)
    ADDON:Hook(listFrame, "SetWidth", function() end)
end

local function InitializeFilterDropDown(sender, level)
    local info

    if (level == 1) then
        info = CreateFilterInfo(COLLECTED, "collected", nil,  function(value)
            if (value) then
                UIDropDownMenu_EnableButton(1,2)
            else
                UIDropDownMenu_DisableButton(1,2)
            end
        end)
        UIDropDownMenu_AddButton(info, level)

        info = CreateFilterInfo(FAVORITES_FILTER, "onlyFavorites")
        info.leftPadding = 16
        info.disabled = not ADDON.settings.filter.collected
        UIDropDownMenu_AddButton(info, level)

        info = CreateFilterInfo(NOT_COLLECTED, "notCollected")
        UIDropDownMenu_AddButton(info, level)

        info = CreateFilterInfo(L["Only usable"], "onlyUsable")
        UIDropDownMenu_AddButton(info, level)

        info = CreateFilterInfo(SOURCES)
        info.value = 1
        UIDropDownMenu_AddButton(info, level)

        info = CreateFilterInfo(TYPE)
        info.value = 2
        UIDropDownMenu_AddButton(info, level)

        info = CreateFilterInfo(FACTION)
        info.value = 3
        UIDropDownMenu_AddButton(info, level)

        info = CreateFilterInfo(L["Family"])
        info.value = 4
        UIDropDownMenu_AddButton(info, level)

        info = CreateFilterInfo(L["Expansion"])
        info.value = 5
        UIDropDownMenu_AddButton(info, level)

        info = CreateFilterInfo(L["Hidden"], "hidden")
        UIDropDownMenu_AddButton(info, level)

        info = CreateFilterInfo(L["Reset filters"])
        info.keepShownOnClick = false
        info.hasArrow = false
        info.func = function(_, _, _, value)
            ADDON:ResetFilterSettings();
            ADDON:UpdateIndexMap()
            MountJournal_UpdateMountList()
        end
        UIDropDownMenu_AddButton(info, level)
    elseif (UIDROPDOWNMENU_MENU_VALUE == 1) then
        AddCheckAllAndNoneInfo("source", level, 1)
        for _,categoryName in pairs(GetSourceOrder()) do
            info = CreateFilterInfo(L[categoryName] or categoryName, "source", categoryName)
            UIDropDownMenu_AddButton(info, level)
        end
    elseif (UIDROPDOWNMENU_MENU_VALUE == 2) then
        AddCheckAllAndNoneInfo("mountType", level, 2)

        info = CreateFilterInfo(L["Ground"], "mountType", "ground")
        UIDropDownMenu_AddButton(info, level)
        info = CreateFilterInfo(L["Flying"], "mountType", "flying")
        UIDropDownMenu_AddButton(info, level)
        info = CreateFilterInfo(L["Water Walking"], "mountType", "waterWalking")
        UIDropDownMenu_AddButton(info, level)
        info = CreateFilterInfo(L["Underwater"], "mountType", "underwater")
        UIDropDownMenu_AddButton(info, level)
        info = CreateFilterInfo(L["Transform"], "mountType", "transform")
        UIDropDownMenu_AddButton(info, level)
        info = CreateFilterInfo(L["Repair"], "mountType", "repair")
        UIDropDownMenu_AddButton(info, level)
        info = CreateFilterInfo(L["Passenger"], "mountType", "passenger")
        UIDropDownMenu_AddButton(info, level)
    elseif (UIDROPDOWNMENU_MENU_VALUE == 3) then
        info = CreateFilterInfo(FACTION_ALLIANCE, "faction", "alliance")
        UIDropDownMenu_AddButton(info, level)
        info = CreateFilterInfo(FACTION_HORDE, "faction", "horde")
        UIDropDownMenu_AddButton(info, level)
        info = CreateFilterInfo(NPC_NAMES_DROPDOWN_NONE, "faction", "noFaction")
        UIDropDownMenu_AddButton(info, level)
    elseif (UIDROPDOWNMENU_MENU_VALUE == 4) then
        AddCheckAllAndNoneInfo("family", level, 4)

        local sortedFamilies = {}
        for family, _ in pairs(ADDON.MountJournalEnhancedFamily) do
            table.insert(sortedFamilies, family)
        end
        table.sort(sortedFamilies, function(a, b) return (L[a] or a) < (L[b] or b) end)

        for _, family in pairs(sortedFamilies) do
            info = CreateFilterInfo(L[family] or family, "family", family)
            UIDropDownMenu_AddButton(info, level)
        end

        MakeMultiColumnMenu(level, 21)
    elseif (UIDROPDOWNMENU_MENU_VALUE == 5) then
        AddCheckAllAndNoneInfo("expansion", level, 5)

        for _, expansion in pairs(GetExpansionOrder()) do
            info = CreateFilterInfo(L[expansion] or expansion, "expansion", expansion)
            UIDropDownMenu_AddButton(info, level)
        end
    end
end

local function InitializeMountOptionsMenu(sender, level)
    if not MountJournal.menuMountIndex then
        return
    end

    local info = UIDropDownMenu_CreateInfo()
    info.notCheckable = true

    local active = select(4, C_MountJournal.GetMountInfoByID(MountJournal.menuMountID))
    local needsFanfare = C_MountJournal.NeedsFanfare(MountJournal.menuMountID)

    if (needsFanfare) then
        info.text = UNWRAP
    elseif ( active ) then
        info.text = BINDING_NAME_DISMOUNT
    else
        info.text = MOUNT
        info.disabled = not MountJournal.menuIsUsable
    end

    info.func = function()
        if needsFanfare then
            MountJournal_Select(MountJournal.menuMountIndex)
        end
        MountJournalMountButton_UseMount(MountJournal.menuMountID)
    end

    UIDropDownMenu_AddButton(info, level)

    local spellId
    local isCollected = false
    if (MountJournal.menuMountIndex) then
        _, spellId, _, _, _, _, _, _, _, _, isCollected = C_MountJournal.GetDisplayedMountInfo(MountJournal.menuMountIndex)
    end

    if not needsFanfare and isCollected then
        info.disabled = nil

        local canFavorite = false
        local isFavorite = false
        if (MountJournal.menuMountIndex) then
            isFavorite, canFavorite = C_MountJournal.GetIsFavorite(MountJournal.menuMountIndex)
        end

        if (isFavorite) then
            info.text = BATTLE_PET_UNFAVORITE
            info.func = function()
                C_MountJournal.SetIsFavorite(MountJournal.menuMountIndex, false)
                MountJournal_UpdateMountList()
            end
        else
            info.text = BATTLE_PET_FAVORITE
            info.func = function()
                C_MountJournal.SetIsFavorite(MountJournal.menuMountIndex, true)
                MountJournal_UpdateMountList()
            end
        end

        if (canFavorite) then
            info.disabled = false
        else
            info.disabled = true
        end

        UIDropDownMenu_AddButton(info, level)
    end

    if (spellId) then
        info.disabled = nil
        if (ADDON.settings.hiddenMounts[spellId]) then
            info.text = SHOW
            info.func = function()
                ADDON.settings.hiddenMounts[spellId] = false
                ADDON:UpdateIndexMap()
                MountJournal_UpdateMountList()
            end
        else
            info.text = HIDE
            info.func = function()
                ADDON.settings.hiddenMounts[spellId] = true
                ADDON:UpdateIndexMap()
                MountJournal_UpdateMountList()
            end
        end
        UIDropDownMenu_AddButton(info, level)
    end

    info.disabled = nil
    info.text = CANCEL
    info.func = nil
    UIDropDownMenu_AddButton(info, level)
end

hooksecurefunc(ADDON, "LoadUI", function ()
    hooksecurefunc(MountJournal.mountOptionsMenu, "initialize", function(sender, level)
        UIDropDownMenu_InitializeHelper(sender)
        InitializeMountOptionsMenu(sender, level)
    end)
    hooksecurefunc(MountJournalFilterDropDown, "initialize", function(sender, level)
        UIDropDownMenu_InitializeHelper(sender)
        InitializeFilterDropDown(sender, level)
    end)
end)