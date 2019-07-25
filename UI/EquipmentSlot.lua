local ADDON_NAME, ADDON = ...

local originalParent

function ADDON:ApplyMoveEquipmentSlot(flag)
    ADDON.settings.moveEquipmentSlot = flag

    local button = MountJournal.SlotButton

    if (flag) then
        -- backup frame settings
        ADDON.UI:SavePoint(button)
        ADDON.UI:SavePoint(MountJournal.LeftInset, "BOTTOMLEFT")
        ADDON.UI:SavePoint(MountJournal.RightInset, "BOTTOMLEFT")
        originalParent = button:GetParent()

        -- move button
        button:SetParent(MountJournal.MountDisplay)
        button:ClearAllPoints()
        button:SetPoint("BOTTOMLEFT", MountJournal.MountDisplay, 15, 15)

        -- Hide and fix surrounding insets
        MountJournal.BottomLeftInset:Hide()
        MountJournal.LeftInset:SetPoint("BOTTOMLEFT", 4, 26)
        MountJournal.RightInset:SetPoint("BOTTOMLEFT", MountJournal.LeftInset, "BOTTOMRIGHT", 20, 0)
    else
        if (originalParent) then
            button:SetParent(originalParent)
        end
        ADDON.UI:RestorePoint(button)
        ADDON.UI:RestorePoint(MountJournal.LeftInset, "BOTTOMLEFT")
        ADDON.UI:RestorePoint(MountJournal.RightInset, "BOTTOMLEFT")
        MountJournal.BottomLeftInset:Show()
    end
end

local doInit = true
local function init()
    if (doInit) then
        doInit = false
        ADDON:ApplyMoveEquipmentSlot(ADDON.settings.moveEquipmentSlot)
    end
end

ADDON:RegisterLoadUICallback(init)
-- UI Pack fix  (eg. ElvUI, TukUI)
ADDON.UI:RegisterUIOverhaulCallback(init)