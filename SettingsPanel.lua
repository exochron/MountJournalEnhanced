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
    if (ADDON.settings.showShopButton ~= nil) then
        frame.shopButtonCheck = BuildCheckBox(frame, L.SETTING_SHOP_BUTTON)
    end

    return frame
end

local function OKHandler(frame)
    if (frame.enableCursorKeysCheck) then
        ADDON.settings.enableCursorKeys = frame.enableCursorKeysCheck:GetValue()
    end

    if (frame.favoritesPerCharCheck and frame.favoritesPerCharCheck:GetValue() ~= ADDON.settings.favoritePerChar) then
        ADDON.settings.favoritePerChar = frame.favoritesPerCharCheck:GetValue()
        if ADDON.settings.favoritePerChar then
            ADDON:CollectFavoredMounts()
        end
    end
    if (frame.moveEquipmentCheck) then
        ADDON:ApplyMoveEquipmentSlot(frame.moveEquipmentCheck:GetValue())
    end
    if (frame.compactListCheck and frame.compactListCheck:GetValue() ~= ADDON.settings.compactMountList) then
        ADDON:ApplyCompactMountList(frame.compactListCheck:GetValue())
    end
    if (frame.unlockCameraCheck) then
        ADDON:ApplyUnlockDisplayCamera(frame.unlockCameraCheck:GetValue())
    end
    if (frame.shopButtonCheck and frame.shopButtonCheck:GetValue() ~= ADDON.settings.showShopButton) then
        ADDON.settings.showShopButton = frame.shopButtonCheck:GetValue()
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
    end)
    group:SetCallback("okay", OKHandler)
    group:SetCallback("default", ADDON.ResetUISettings)
    InterfaceOptions_AddCategory(group.frame)
end)