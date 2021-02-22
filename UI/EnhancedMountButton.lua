local ADDON_NAME, ADDON = ...

ADDON.Events:RegisterCallback("preloadUI", function()
    MountJournal.MountButton:SetScript("OnClick", function()
        ADDON.Api:UseMount(ADDON.Api:GetSelected())
    end)

    -- from https://www.townlong-yak.com/framexml/live/Blizzard_Collections/Blizzard_MountCollection.lua#692
    MountJournal.MountButton:HookScript("OnEnter", function(self)
        local selectedMountID = ADDON.Api:GetSelected()

        GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
        GameTooltip:SetText(self:GetText(), HIGHLIGHT_FONT_COLOR:GetRGB());
        local needsFanFare = selectedMountID and C_MountJournal.NeedsFanfare(selectedMountID);
        if needsFanFare then
            GameTooltip_AddNormalLine(GameTooltip, MOUNT_UNWRAP_TOOLTIP, true);
        else
            GameTooltip_AddNormalLine(GameTooltip, MOUNT_SUMMON_TOOLTIP, true);
        end
        if selectedMountID ~= nil then
            local checkIndoors = true;
            local isUsable, errorText = C_MountJournal.GetMountUsabilityByID(selectedMountID, checkIndoors);
            if errorText ~= nil then
                GameTooltip_AddErrorLine(GameTooltip, errorText, true);
            end
        end
        GameTooltip:Show();
    end)
end, "enhanced mount button")