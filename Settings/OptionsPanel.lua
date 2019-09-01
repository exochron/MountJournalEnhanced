local ADDON_NAME, ADDON = ...

-- WARNING: Also look into ResetUISettings() on new elements

local AceGUI = LibStub("AceGUI-3.0")

local function BuildCheckBox(parent, text)
    local button = AceGUI:Create("CheckBox")
    button:SetLabel(text)
    button:SetFullWidth(true)
    parent:AddChild(button)

    return button
end
local function BuildHeading(parent, text)
    local head = AceGUI:Create("Heading")
    head:SetText(text)
    head:SetFullWidth(true)
    parent:AddChild(head)

    return head
end

local function BuildFrame()
    local title = GetAddOnMetadata(ADDON_NAME, "Title")
    local frame = AceGUI:Create("BlizOptionsGroup")
    frame:SetName(title)
    frame:SetTitle(title)
    frame:SetLayout("List")

    BuildHeading(frame, UIOPTIONS_MENU)

    local L = ADDON.L
    if (ADDON.settings.ui.showAchievementPoints ~= nil) then
        frame.showAchievementPointsCheck = BuildCheckBox(frame, L.SETTING_ACHIEVEMENT_POINTS)
    end
    if (ADDON.settings.ui.showPersonalCount ~= nil) then
        frame.showPersonalCountCheck = BuildCheckBox(frame, L.SETTING_MOUNT_COUNT)
    end
    if (ADDON.settings.ui.compactMountList ~= nil) then
        frame.compactListCheck = BuildCheckBox(frame, L.SETTING_COMPACT_LIST)
    end
    if (ADDON.settings.ui.moveEquipmentSlot ~= nil) then
        frame.moveEquipmentCheck = BuildCheckBox(frame, L.SETTING_MOVE_EQUIPMENT)
    end
    if (ADDON.settings.ui.unlockDisplayCamera ~= nil) then
        frame.unlockCameraCheck = BuildCheckBox(frame, L.SETTING_YCAMERA)
    end
    if (ADDON.settings.ui.enableCursorKeys ~= nil) then
        frame.enableCursorKeysCheck = BuildCheckBox(frame, L.SETTING_CURSOR_KEYS)
    end
    if (ADDON.settings.ui.previewButton ~= nil) then
        frame.previewButtonCheck = BuildCheckBox(frame, L.SETTING_PREVIEW_LINK)
    end
    if (ADDON.settings.ui.showShopButton ~= nil) then
        frame.shopButtonCheck = BuildCheckBox(frame, L.SETTING_SHOP_BUTTON)
    end

    BuildHeading(frame, L. SETTING_HEAD_SETTING_BEHAVIOUR)

    if (ADDON.settings.personalUi ~= nil) then
        frame.personalUICheck = BuildCheckBox(frame, 'Apply Interface settings only to this character')
    end
    if (ADDON.settings.personalFilter ~= nil) then
        frame.personalFilterCheck = BuildCheckBox(frame, 'Apply filters only to this character')
    end
    if (ADDON.settings.favoritePerChar ~= nil) then
        frame.favoritesPerCharCheck = BuildCheckBox(frame, L.SETTING_FAVORITE_PER_CHAR)
    end
    if (ADDON.settings.personalHiddenMounts ~= nil) then
        frame.personalHiddenMountsCheck = BuildCheckBox(frame, 'Apply hidden mounts only to this character')
    end

    return frame
end

local function OKHandler(frame)

    if (frame.personalUICheck) then
        ADDON:ApplyPersonalUI(frame.personalUICheck:GetValue())
    end
    if (frame.personalFilterCheck) then
        ADDON:ApplyPersonalFilter(frame.personalFilterCheck:GetValue())
    end
    if (frame.favoritesPerCharCheck) then
        ADDON:ApplyFavoritePerCharacter(frame.favoritesPerCharCheck:GetValue())
    end
    if (frame.personalHiddenMountsCheck) then
        ADDON:ApplyPersonalHiddenMounts(frame.personalHiddenMountsCheck:GetValue())
    end

    if (frame.enableCursorKeysCheck) then
        ADDON.settings.ui.enableCursorKeys = frame.enableCursorKeysCheck:GetValue()
    end
    if (frame.moveEquipmentCheck) then
        ADDON:ApplyMoveEquipmentSlot(frame.moveEquipmentCheck:GetValue())
    end
    if (frame.compactListCheck) then
        ADDON:ApplyCompactMountList(frame.compactListCheck:GetValue())
    end
    if (frame.unlockCameraCheck) then
        ADDON:ApplyUnlockDisplayCamera(frame.unlockCameraCheck:GetValue())
    end
    if (frame.shopButtonCheck) then
        ADDON.settings.ui.showShopButton = frame.shopButtonCheck:GetValue()
    end
    if (frame.showAchievementPointsCheck) then
        ADDON:ApplyShowAchievementPoints(frame.showAchievementPointsCheck:GetValue())
    end
    if (frame.previewButtonCheck) then
        ADDON:ApplyPreviewButton(frame.previewButtonCheck:GetValue())
    end
    if (frame.showPersonalCountCheck) then
        ADDON:ApplyShowPersonalCount(frame.showPersonalCountCheck:GetValue())
    end
end

ADDON:RegisterLoginCallback(function()
    local group = BuildFrame()
    group:SetCallback("refresh", function(frame)
        if (frame.compactListCheck) then
            frame.compactListCheck:SetValue(ADDON.settings.ui.compactMountList)
        end
        if (frame.moveEquipmentCheck) then
            frame.moveEquipmentCheck:SetValue(ADDON.settings.ui.moveEquipmentSlot)
        end
        if (frame.unlockCameraCheck) then
            frame.unlockCameraCheck:SetValue(ADDON.settings.ui.unlockDisplayCamera)
        end
        if (frame.enableCursorKeysCheck) then
            frame.enableCursorKeysCheck:SetValue(ADDON.settings.ui.enableCursorKeys)
        end
        if (frame.shopButtonCheck) then
            frame.shopButtonCheck:SetValue(ADDON.settings.ui.showShopButton)
        end
        if (frame.showAchievementPointsCheck) then
            frame.showAchievementPointsCheck:SetValue(ADDON.settings.ui.showAchievementPoints)
        end
        if (frame.previewButtonCheck) then
            frame.previewButtonCheck:SetValue(ADDON.settings.ui.previewButton)
        end
        if (frame.showPersonalCountCheck) then
            frame.showPersonalCountCheck:SetValue(ADDON.settings.ui.showPersonalCount)
        end

        if (frame.personalUICheck) then
            frame.personalUICheck:SetValue(ADDON.settings.personalUi)
        end
        if (frame.personalFilterCheck) then
            frame.personalFilterCheck:SetValue(ADDON.settings.personalFilter)
        end
        if (frame.favoritesPerCharCheck) then
            frame.favoritesPerCharCheck:SetValue(ADDON.settings.favoritePerChar)
        end
        if (frame.personalHiddenMountsCheck) then
            frame.personalHiddenMountsCheck:SetValue(ADDON.settings.personalHiddenMounts)
        end
    end)
    group:SetCallback("okay", OKHandler)
    group:SetCallback("default", ADDON.ResetSettings)
    InterfaceOptions_AddCategory(group.frame)
end)