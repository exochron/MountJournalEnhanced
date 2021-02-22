local ADDON_NAME, ADDON = ...

ADDON:RegisterUISetting('showShopButton', true, ADDON.L.SETTING_SHOP_BUTTON, function()
    if ADDON.initialized then
        ADDON.UI:UpdateMountDisplay()
    end
end)

local frame

local function ToggleShopButton()
    if MountJournal then
        if frame then
            if ADDON.settings.ui.showShopButton and ADDON.Api:GetSelected() then
                local _, _, _, _, _, sourceType, _, _, _, _, isCollected = C_MountJournal.GetMountInfoByID(ADDON.Api:GetSelected())
                if not isCollected and sourceType == 10 then
                    frame:Show()
                    return
                end
            end

            frame:Hide()
        end
    end
end

local function CreateShopButton()
    frame = CreateFrame("Button", nil, MountJournal.MountDisplay.InfoButton)

    frame:ClearAllPoints()
    frame:SetPoint("BOTTOMRIGHT", MountJournal.MountDisplay, -15, 15)
    frame:SetSize(28, 36)
    frame:SetNormalAtlas('hud-microbutton-BStore-Up', true)
    frame:SetPushedAtlas('hud-microbutton-BStore-Down', true)
    frame:SetDisabledAtlas('hud-microbutton-BStore-Disabled', true)
    frame:SetHighlightAtlas('hud-microbutton-highlight', true)

    frame:HookScript("OnClick", function()
        SetStoreUIShown(true)
    end)

    ADDON.Events:RegisterCallback("OnUpdateMountDisplay", ToggleShopButton, ADDON_NAME .. 'ShopButton')
end

ADDON.Events:RegisterCallback("loadUI", CreateShopButton, "shop")
