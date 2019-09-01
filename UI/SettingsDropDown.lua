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
    local button = CreateFrame("Button", nil, MountJournal)

    if (CollectionsJournalPortrait:IsShown() and CollectionsJournalPortrait:GetAlpha() > 0.0) then
        button:SetPoint("TOPLEFT", MountJournal, "TOPLEFT", 60, -3)
    else
        button:SetPoint("TOPLEFT", MountJournal, "TOPLEFT", 3, -3)
    end

    button:SetSize(18, 18)
    local tex = button:CreateTexture()
    tex:SetAllPoints(button)
    tex:SetTexture('Interface\\Minimap\\ObjectIconsAtlas')
    tex:SetTexCoord(0.86, 0.89, 0.205, 0.2683)
    button:Show()

    return button
end

ADDON:RegisterLoadUICallback(function()
    local button = BuildWheelButton()

    local menu = MSA_DropDownMenu_Create(ADDON_NAME .. "SettingsMenu", MountJournal)
    MSA_DropDownMenu_Initialize(menu, InitializeDropDown, "MENU")
    button:SetScript("OnClick", function(sender)
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        MSA_ToggleDropDownMenu(1, nil, menu, sender, 0, 0)
    end)
end)
