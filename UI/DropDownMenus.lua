local ADDON_NAME, ADDON = ...
local L = ADDON.L

local function GetSourceOrder()
    return { "Drop", "Quest", "Vendor", "Profession", "Instance", "Reputation", "Achievement", "Island Expedition", "Garrison", "PVP", "Class", "World Event", "Black Market", "Shop", "Promotion"}
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
    local listFrame = _G["MSA_DropDownList"..level]
    local columnWidth = listFrame.maxWidth + 25

    local listFrameName = listFrame:GetName()
    local columnIndex = 0
    for index = entriesPerColumn + 1, listFrame.numButtons do
        columnIndex = math.ceil(index / entriesPerColumn)
        local button = _G[listFrameName.."Button"..index]
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
        info = CreateFilterInfo(COLLECTED, "collected", nil,  function(value)
            if (value) then
                MSA_DropDownMenu_EnableButton(1,2)
            else
                MSA_DropDownMenu_DisableButton(1,2)
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
        for _,categoryName in pairs(GetSourceOrder()) do
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

local function InitializeMountOptionsMenu(sender, level)
    if not MountJournal.menuMountIndex then
        return
    end

    local info = MSA_DropDownMenu_CreateInfo()
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

    MSA_DropDownMenu_AddButton(info, level)

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

        MSA_DropDownMenu_AddButton(info, level)
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
        MSA_DropDownMenu_AddButton(info, level)
    end

    info.disabled = nil
    info.text = CANCEL
    info.func = nil
    MSA_DropDownMenu_AddButton(info, level)
end

local function MountListItem_OnClick(menu, sender, anchor, button)
    if (button ~= "LeftButton") then
        local _, _, _, _, _, _, _, _, _, _, isCollected = C_MountJournal.GetDisplayedMountInfo(sender.index)
        if not isCollected then
            MountJournal_ShowMountDropdown(sender.index, anchor, 0, 0)
        end
        MountJournal_HideMountDropdown()

        MSA_ToggleDropDownMenu(1, nil, menu, anchor, 0, 0)
    end
end

hooksecurefunc(ADDON, "LoadUI", function ()
    local menu = CreateFrame("Button", ADDON_NAME.."MountOptionsMenu", MountJournal, "MSA_DropDownMenuTemplate")
    MSA_DropDownMenu_Initialize(menu, InitializeMountOptionsMenu, "MENU")

    local buttons = MountJournal.ListScrollFrame.buttons
    for buttonIndex = 1, #buttons do
        local button = buttons[buttonIndex]
        button:HookScript("OnClick", function(sender, mouseButton)
            MountListItem_OnClick(menu, sender, sender, mouseButton)
        end)
        button.DragButton:HookScript("OnClick", function(sender, mouseButton)
            MountListItem_OnClick(menu, sender:GetParent(), sender, mouseButton)
        end)
    end

    local menu = CreateFrame("Button", ADDON_NAME.."FilterMenu", MountJournal, "MSA_DropDownMenuTemplate")
    MSA_DropDownMenu_Initialize(menu, InitializeFilterDropDown, "MENU")

    MountJournalFilterButton:HookScript("OnClick", function(sender)
        MountJournalFilterDropDown:Hide()
        MSA_ToggleDropDownMenu(1, nil, menu, sender, 74, 15);
    end)
end)