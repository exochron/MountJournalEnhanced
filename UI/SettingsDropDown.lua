local ADDON_NAME, ADDON = ...
local L = ADDON.L

local function CreateTitle()
    local title = GetAddOnMetadata(ADDON_NAME, "Title")
    local info = MSA_DropDownMenu_CreateInfo()
    info.isTitle = 1
    info.text = title
    info.notCheckable = 1

    return info
end

local function CreateCheck(text, settingKey, applyFunc)
    local info = MSA_DropDownMenu_CreateInfo()
    info.keepShownOnClick = true
    info.isNotRadio = true
    info.hasArrow = false
    info.text = text
    info.notCheckable = false
    info.checked = ADDON.settings.ui[settingKey]
    info.func = function(_, _, _, value)
        if (applyFunc) then
            applyFunc(ADDON, value)
        else
            ADDON.settings.ui[settingKey] = value
        end
    end

    return info
end

local function InitializeDropDown(filterMenu, level)

    MSA_DropDownMenu_AddButton(CreateTitle(), level)

    if (ADDON.settings.ui.showAchievementPoints ~= nil) then
        MSA_DropDownMenu_AddButton(CreateCheck(L.SETTING_ACHIEVEMENT_POINTS, 'showAchievementPoints', ADDON.ApplyShowAchievementPoints), level)
    end
    if (ADDON.settings.ui.showAchievementPoints ~= nil) then
        MSA_DropDownMenu_AddButton(CreateCheck(L.SETTING_MOUNT_COUNT, 'showPersonalCount', ADDON.ApplyShowPersonalCount), level)
    end
    if (ADDON.settings.ui.compactMountList ~= nil) then
        MSA_DropDownMenu_AddButton(CreateCheck(L.SETTING_COMPACT_LIST, 'compactMountList', ADDON.ApplyCompactMountList), level)
    end
    if (ADDON.settings.ui.moveEquipmentSlot ~= nil) then
        MSA_DropDownMenu_AddButton(CreateCheck(L.SETTING_MOVE_EQUIPMENT, 'moveEquipmentSlot', ADDON.ApplyMoveEquipmentSlot), level)
    end
    if (ADDON.settings.ui.unlockDisplayCamera ~= nil) then
        MSA_DropDownMenu_AddButton(CreateCheck(L.SETTING_YCAMERA, 'unlockDisplayCamera', ADDON.ApplyUnlockDisplayCamera), level)
    end
    if (ADDON.settings.ui.enableCursorKeys ~= nil) then
        MSA_DropDownMenu_AddButton(CreateCheck(L.SETTING_CURSOR_KEYS, 'enableCursorKeys'), level)
    end
    if (ADDON.settings.ui.previewButton ~= nil) then
        MSA_DropDownMenu_AddButton(CreateCheck(L.SETTING_PREVIEW_LINK, 'previewButton', ADDON.ApplyPreviewButton), level)
    end
    if (ADDON.settings.ui.showShopButton ~= nil) then
        MSA_DropDownMenu_AddButton(CreateCheck(L.SETTING_SHOP_BUTTON, 'showShopButton'), level)
    end
end

local function BuildWheelButton()
    local AceGUI = LibStub("AceGUI-3.0")

    local button = AceGUI:Create("Icon")
    button:SetParent({ content = MountJournal })
    button:SetWidth(18)
    button:SetHeight(18)

    if (CollectionsJournalPortrait:IsShown() and CollectionsJournalPortrait:GetAlpha() > 0.0) then
        button:SetPoint("TOPLEFT", MountJournal, "TOPLEFT", 60, -1)
    else
        button:SetPoint("TOPLEFT", MountJournal, "TOPLEFT", 3, -1)
    end

    button.image:SetAtlas("mechagon-projects")
    button.image:SetWidth(20)
    button.image:SetHeight(20)
    button.image:SetPoint("TOP", 0, 0)

    button.frame:Show()

    return button
end

ADDON:RegisterLoadUICallback(function()
    local button = BuildWheelButton()

    local menu = MSA_DropDownMenu_Create(ADDON_NAME .. "SettingsMenu", MountJournal)
    MSA_DropDownMenu_Initialize(menu, InitializeDropDown, "MENU")
    button:SetCallback("OnClick", function(sender)
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        MSA_ToggleDropDownMenu(1, nil, menu, button.frame, 0, 0)
    end)
end)
