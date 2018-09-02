local ADDON_NAME, ADDON = ...

-- WARNING: Also look into ResetUISettings() on new elements

local function BuildCheckBox(parentFrame, text, relativeTo, yOffset)

    local button = CreateFrame("CheckButton", nil, parentFrame, "ChatConfigCheckButtonTemplate")
    button:SetPoint("LEFT", relativeTo, "LEFT", 0, -20 - (yOffset or 0))
    button.Text:SetText("  " .. text)

    return button
end

local function BuildFrame()
    local frame = CreateFrame("Frame")
    local L = ADDON.L

    local titleFont = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    titleFont:SetPoint("TOPLEFT", 22, -22)
    titleFont:SetText(GetAddOnMetadata(ADDON_NAME, "Title"))

    frame.compactListCheck = BuildCheckBox(frame, L.SETTING_COMPACT_LIST, titleFont, 10)
    frame.unlockCameraCheck = BuildCheckBox(frame, L.SETTING_YCAMERA, frame.compactListCheck)
    frame.enableCursorKeysCheck = BuildCheckBox(frame, L.SETTING_CURSOR_KEYS, frame.unlockCameraCheck)
    frame.favoritesPerCharCheck = BuildCheckBox(frame, L.SETTING_FAVORITE_PER_CHAR, frame.enableCursorKeysCheck)
    frame.shopButtonCheck = BuildCheckBox(frame, L.SETTING_SHOP_BUTTON, frame.favoritesPerCharCheck)

    return frame
end

local function OKHandler(frame)
    local reload
    ADDON.settings.enableCursorKeys = frame.enableCursorKeysCheck:GetChecked()

    if (ADDON.settings.favoritePerChar ~= frame.favoritesPerCharCheck:GetChecked()) then
        ADDON.settings.favoritePerChar = frame.favoritesPerCharCheck:GetChecked()
        if ADDON.settings.favoritePerChar then
            ADDON:CollectFavoredMounts()
        end
    end
    if (ADDON.settings.compactMountList ~= frame.compactListCheck:GetChecked()) then
        ADDON.settings.compactMountList = frame.compactListCheck:GetChecked()
        reload = true
    end
    if (ADDON.settings.unlockDisplayCamera ~= frame.unlockCameraCheck:GetChecked()) then
        ADDON.settings.unlockDisplayCamera = frame.unlockCameraCheck:GetChecked()
        reload = true
    end
    if (ADDON.settings.showShopButton ~= frame.shopButtonCheck:GetChecked()) then
        ADDON.settings.showShopButton = frame.shopButtonCheck:GetChecked()
        reload = true
    end
    if reload and ADDON.initialized then
        ReloadUI()
    end
end

hooksecurefunc(ADDON, "OnLogin", function()
    local frame = BuildFrame()
    frame.name = GetAddOnMetadata(ADDON_NAME, "Title")
    frame.refresh = function(frame)
        frame.compactListCheck:SetChecked(ADDON.settings.compactMountList)
        frame.unlockCameraCheck:SetChecked(ADDON.settings.unlockDisplayCamera)
        frame.enableCursorKeysCheck:SetChecked(ADDON.settings.enableCursorKeys)
        frame.favoritesPerCharCheck:SetChecked(ADDON.settings.favoritePerChar)
        frame.shopButtonCheck:SetChecked(ADDON.settings.showShopButton)
    end
    frame.okay = OKHandler
    frame.default = ADDON.ResetUISettings
    InterfaceOptions_AddCategory(frame)
end)