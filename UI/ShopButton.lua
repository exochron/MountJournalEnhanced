local ADDON_NAME, ADDON = ...

ADDON:RegisterUISetting('showShopButton', true, ADDON.L.SETTING_SHOP_BUTTON, function()
    ADDON.UI:UpdateMountDisplay()
end)

local function ToggleShopButton()
    if MountJournal then
        local frame = MountJournal.MountDisplay.InfoButton.Shop
        if (frame) then
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
    local frame = CreateFrame("Button", nil, MountJournal.MountDisplay.InfoButton)

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

    MountJournal.MountDisplay.InfoButton.Shop = frame

    EventRegistry:RegisterCallback("MountJournal.OnUpdateMountDisplay", ToggleShopButton, ADDON_NAME .. 'ShopButton')
end

ADDON:RegisterLoadUICallback(CreateShopButton)
