local ADDON_NAME, ADDON = ...

local function MoveSlotButton()
    local button = MountJournal.SlotButton
    button:SetParent(MountJournal.MountDisplay)
    button:ClearAllPoints()
    button:SetPoint("BOTTOMLEFT", MountJournal.MountDisplay, 15, 15)
end

ADDON:RegisterLoadUICallback(function()
    if (ADDON.settings.moveEquipmentSlot) then
        MoveSlotButton()

        MountJournal.BottomLeftInset:Hide()
        MountJournal.LeftInset:SetPoint("BOTTOMLEFT", 4, 26)
        MountJournal.RightInset:SetPoint("BOTTOMLEFT", MountJournal.LeftInset, "BOTTOMRIGHT", 20, 0)
    end
end)