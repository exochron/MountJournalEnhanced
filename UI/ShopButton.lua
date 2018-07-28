local ADDON_NAME, ADDON = ...

function ADDON:CreateShopButton()
    local frame = CreateFrame("Button", nil, MountJournal.MountDisplay.InfoButton)

    frame:ClearAllPoints()
    frame:SetPoint("BOTTOMRIGHT", MountJournal.MountDisplay, -14, 14)
    frame:SetSize(28, 36)
    frame:SetNormalAtlas('hud-microbutton-BStore-Up', true)
    frame:SetPushedAtlas('hud-microbutton-BStore-Down', true)
    frame:SetDisabledAtlas('hud-microbutton-BStore-Disabled', true)
    frame:SetHighlightAtlas('hud-microbutton-highlight', true)

    frame:SetScript("OnClick", function()
        SetStoreUIShown(true)
    end)

    MountJournal.MountDisplay.InfoButton.Shop = frame

    hooksecurefunc("MountJournal_UpdateMountDisplay", function(sender, level)
        self:ToggleShopButton()
    end)
end

-- also called from SlashCommand
function ADDON:ToggleShopButton()
    if (MountJournal) then
        local frame = MountJournal.MountDisplay.InfoButton.Shop
        if (frame) then
            if (self.settings.showShopButton and MountJournal.selectedMountID) then
                local _, _, _, _, _, sourceType, _, _, _, _, isCollected = C_MountJournal.GetMountInfoByID(MountJournal.selectedMountID)
                if not isCollected and sourceType == 10 then
                    frame:Show()
                    return
                end
            end

            frame:Hide()
        end
    end
end