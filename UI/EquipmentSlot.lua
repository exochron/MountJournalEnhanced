local ADDON_NAME, ADDON = ...

local originalParent

ADDON:RegisterUISetting('moveEquipmentSlot', true, ADDON.L.SETTING_MOVE_EQUIPMENT, function(flag)
    if ADDON.initialized then
        local button = MountJournal.SlotButton

        if flag then
            -- backup frame settings
            if nil == originalParent then
                ADDON.UI:SavePoint(button)
                ADDON.UI:SavePoint(MountJournal.LeftInset, "BOTTOMLEFT")
                ADDON.UI:SavePoint(MountJournal.RightInset, "BOTTOMLEFT")
                originalParent = button:GetParent()
            end

            -- move button
            button:SetParent(MountJournal.MountDisplay)
            button:ClearAllPoints()
            button:SetPoint("BOTTOMLEFT", MountJournal.MountDisplay, 15, 15)

            -- Hide and fix surrounding insets
            MountJournal.BottomLeftInset:Hide()
            MountJournal.LeftInset:SetPoint("BOTTOMLEFT", 4, 26)
            MountJournal.RightInset:SetPoint("BOTTOMLEFT", MountJournal.LeftInset, "BOTTOMRIGHT", 20, 0)
        else
            if originalParent then
                button:SetParent(originalParent)
            end
            ADDON.UI:RestorePoint(button)
            ADDON.UI:RestorePoint(MountJournal.LeftInset, "BOTTOMLEFT")
            ADDON.UI:RestorePoint(MountJournal.RightInset, "BOTTOMLEFT")
            MountJournal.BottomLeftInset:Show()
        end
    end
end)

ADDON.Events:RegisterCallback("loadUI", function()
    ADDON:ApplySetting('moveEquipmentSlot', ADDON.settings.ui.moveEquipmentSlot)
end, "equipment slot")