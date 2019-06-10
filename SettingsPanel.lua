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
    frame.compactListCheck = BuildCheckBox(frame, L.SETTING_COMPACT_LIST)
    if (ADDON.settings.moveEquipmentSlot ~= nil) then
        frame.moveEquipmentCheck = BuildCheckBox(frame, L.SETTING_MOVE_EQUIPMENT)
    end
    frame.unlockCameraCheck = BuildCheckBox(frame, L.SETTING_YCAMERA)
    frame.enableCursorKeysCheck = BuildCheckBox(frame, L.SETTING_CURSOR_KEYS)
    frame.favoritesPerCharCheck = BuildCheckBox(frame, L.SETTING_FAVORITE_PER_CHAR)
    frame.shopButtonCheck = BuildCheckBox(frame, L.SETTING_SHOP_BUTTON)

    return frame
end

local function OKHandler(frame)
    local reload
    ADDON.settings.enableCursorKeys = frame.enableCursorKeysCheck:GetValue()

    if (ADDON.settings.favoritePerChar ~= frame.favoritesPerCharCheck:GetValue()) then
        ADDON.settings.favoritePerChar = frame.favoritesPerCharCheck:GetValue()
        if ADDON.settings.favoritePerChar then
            ADDON:CollectFavoredMounts()
        end
    end
    if (frame.moveEquipmentCheck and ADDON.settings.moveEquipmentSlot ~= frame.moveEquipmentCheck:GetValue()) then
        ADDON.settings.moveEquipmentSlot = frame.moveEquipmentCheck:GetValue()
        reload = true
    end
    if (ADDON.settings.compactMountList ~= frame.compactListCheck:GetValue()) then
        ADDON.settings.compactMountList = frame.compactListCheck:GetValue()
        reload = true
    end
    if (ADDON.settings.unlockDisplayCamera ~= frame.unlockCameraCheck:GetValue()) then
        ADDON.settings.unlockDisplayCamera = frame.unlockCameraCheck:GetValue()
        reload = true
    end
    if (ADDON.settings.showShopButton ~= frame.shopButtonCheck:GetValue()) then
        ADDON.settings.showShopButton = frame.shopButtonCheck:GetValue()
    end
    if reload and ADDON.initialized then
        ReloadUI()
    end
end

ADDON:RegisterLoginCallback(function()
    local group = BuildFrame()
    group:SetCallback("refresh", function(frame)
        frame.compactListCheck:SetValue(ADDON.settings.compactMountList)
        if (frame.moveEquipmentCheck) then
            frame.moveEquipmentCheck:SetValue(ADDON.settings.moveEquipmentSlot)
        end
        frame.unlockCameraCheck:SetValue(ADDON.settings.unlockDisplayCamera)
        frame.enableCursorKeysCheck:SetValue(ADDON.settings.enableCursorKeys)
        frame.favoritesPerCharCheck:SetValue(ADDON.settings.favoritePerChar)
        frame.shopButtonCheck:SetValue(ADDON.settings.showShopButton)
    end)
    group:SetCallback("okay", OKHandler)
    group:SetCallback("default", ADDON.ResetUISettings)
    InterfaceOptions_AddCategory(group.frame)
end)