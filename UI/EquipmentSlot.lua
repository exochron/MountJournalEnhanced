local _, ADDON = ...

local originalParent

ADDON:RegisterUISetting('slotPosition', "top", ADDON.L.SETTING_MOVE_EQUIPMENT_SLOT, function(flag)
    if ADDON.initialized then
        local button = MountJournal.SlotButton

        if flag == "original" then
            if originalParent then
                button:SetParent(originalParent)
            end
            button:SetScale(1.0)
            ADDON.UI:RestoreSize(button)
            ADDON.UI:RestorePoint(button)
            ADDON.UI:RestorePoint(MountJournal.LeftInset, "BOTTOMLEFT")
            ADDON.UI:RestorePoint(MountJournal.RightInset, "BOTTOMLEFT")
            MountJournal.BottomLeftInset:Show()
        else
            -- backup frame settings
            if nil == originalParent then
                ADDON.UI:SaveSize(button)
                ADDON.UI:SavePoint(button)
                ADDON.UI:SavePoint(MountJournal.LeftInset, "BOTTOMLEFT")
                ADDON.UI:SavePoint(MountJournal.RightInset, "BOTTOMLEFT")
                originalParent = button:GetParent()
            end

            -- move button
            button:SetParent(MountJournal.MountDisplay)
            button:ClearAllPoints()
            if flag == "top" then
                button:SetScale(0.75)
                button:SetPoint("RIGHT", MountJournal.SummonRandomFavoriteButton.spellname, "LEFT")
            else
                button:SetScale(1.0)
                button:SetPoint("BOTTOMLEFT", MountJournal.MountDisplay, 15, 15)
            end

            -- Hide and fix surrounding insets
            MountJournal.BottomLeftInset:Hide()
            MountJournal.LeftInset:SetPoint("BOTTOMLEFT", 4, 26)
            MountJournal.RightInset:SetPoint("BOTTOMLEFT", MountJournal.LeftInset, "BOTTOMRIGHT", 20, 0)
        end
    end
end,
    {
        ["original"] = CHAT_DEFAULT,
        ["top"] = ADDON.L.SETTING_MOVE_EQUIPMENT_SLOT_OPTION_TOP,
        ["display"] = ADDON.L.SETTING_MOVE_EQUIPMENT_SLOT_OPTION_DISPLAY,
    }
)

ADDON.Events:RegisterCallback("loadUI", function()
    ADDON:ApplySetting('slotPosition', ADDON.settings.ui.slotPosition)
end, "equipment slot")