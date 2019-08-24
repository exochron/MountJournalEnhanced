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

local function BuildFrame()
    local title = GetAddOnMetadata(ADDON_NAME, "Title")
    local frame = AceGUI:Create("BlizOptionsGroup")
    frame:SetName(title)
    frame:SetTitle(title)
    frame:SetLayout("List")

    local L = ADDON.L
    if (ADDON.settings.showAchievementPoints ~= nil) then
        frame.showAchievementPointsCheck = BuildCheckBox(frame, L.SETTING_ACHIEVEMENT_POINTS)
    end
    if (ADDON.settings.showPersonalCount ~= nil) then
        frame.showPersonalCountCheck = BuildCheckBox(frame, L.SETTING_MOUNT_COUNT)
    end
    if (ADDON.settings.compactMountList ~= nil) then
        frame.compactListCheck = BuildCheckBox(frame, L.SETTING_COMPACT_LIST)
    end
    if (ADDON.settings.moveEquipmentSlot ~= nil) then
        frame.moveEquipmentCheck = BuildCheckBox(frame, L.SETTING_MOVE_EQUIPMENT)
    end
    if (ADDON.settings.unlockDisplayCamera ~= nil) then
        frame.unlockCameraCheck = BuildCheckBox(frame, L.SETTING_YCAMERA)
    end
    if (ADDON.settings.enableCursorKeys ~= nil) then
        frame.enableCursorKeysCheck = BuildCheckBox(frame, L.SETTING_CURSOR_KEYS)
    end
    if (ADDON.settings.favoritePerChar ~= nil) then
        frame.favoritesPerCharCheck = BuildCheckBox(frame, L.SETTING_FAVORITE_PER_CHAR)
    end
    if (ADDON.settings.previewButton ~= nil) then
        frame.previewButtonCheck = BuildCheckBox(frame, L.SETTING_PREVIEW_LINK)
    end
    if (ADDON.settings.showShopButton ~= nil) then
        frame.shopButtonCheck = BuildCheckBox(frame, L.SETTING_SHOP_BUTTON)
    end

    return frame
end

local function OKHandler(frame)
    if (frame.enableCursorKeysCheck) then
        ADDON.settings.enableCursorKeys = frame.enableCursorKeysCheck:GetValue()
    end

    if (frame.favoritesPerCharCheck) then
        ADDON:ApplyFavoritePerCharacter(frame.favoritesPerCharCheck:GetValue())
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
        ADDON.settings.showShopButton = frame.shopButtonCheck:GetValue()
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
            frame.compactListCheck:SetValue(ADDON.settings.compactMountList)
        end
        if (frame.moveEquipmentCheck) then
            frame.moveEquipmentCheck:SetValue(ADDON.settings.moveEquipmentSlot)
        end
        if (frame.unlockCameraCheck) then
            frame.unlockCameraCheck:SetValue(ADDON.settings.unlockDisplayCamera)
        end
        if (frame.enableCursorKeysCheck) then
            frame.enableCursorKeysCheck:SetValue(ADDON.settings.enableCursorKeys)
        end
        if (frame.favoritesPerCharCheck) then
            frame.favoritesPerCharCheck:SetValue(ADDON.settings.favoritePerChar)
        end
        if (frame.shopButtonCheck) then
            frame.shopButtonCheck:SetValue(ADDON.settings.showShopButton)
        end
        if (frame.showAchievementPointsCheck) then
            frame.showAchievementPointsCheck:SetValue(ADDON.settings.showAchievementPoints)
        end
        if (frame.previewButtonCheck) then
            frame.previewButtonCheck:SetValue(ADDON.settings.previewButton)
        end
        if (frame.showPersonalCountCheck) then
            frame.showPersonalCountCheck:SetValue(ADDON.settings.showPersonalCount)
        end
    end)
    group:SetCallback("okay", OKHandler)
    group:SetCallback("default", ADDON.ResetUISettings)
    InterfaceOptions_AddCategory(group.frame)
end)