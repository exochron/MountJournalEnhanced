local _, ADDON = ...

ADDON.Events:RegisterCallback("loadUI", function()
    local button = MountJournal.SlotButton
    button:SetParent(MountJournal)
    button:ClearAllPoints()
    button:SetScale(0.75)

    -- Hide and fix surrounding insets
    MountJournal.BottomLeftInset:Hide()
    MountJournal.LeftInset:SetPoint("BOTTOMLEFT", 4, 26)
    MountJournal.RightInset:SetPoint("BOTTOMLEFT", MountJournal.LeftInset, "BOTTOMRIGHT", 20, 0)

    ADDON.UI:RegisterToolbarGroup("09-equipment", MountJournal.SlotButton)
end, "equipment slot")