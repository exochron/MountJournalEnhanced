local ADDON_NAME, ADDON = ...

function ADDON:ApplyMoveEquipmentSlot(flag)
    ADDON.settings.moveEquipmentSlot = flag

    local button = MountJournal.SlotButton
    button:ClearAllPoints()

    if (flag) then
        -- regenerate compact list buttons

        button:SetParent(MountJournal.MountDisplay)
        button:SetPoint("BOTTOMLEFT", MountJournal.MountDisplay, 15, 15)

        -- Hide
        MountJournal.BottomLeftInset:Hide()
        MountJournal.LeftInset:SetPoint("BOTTOMLEFT", 4, 26)
        MountJournal.RightInset:SetPoint("BOTTOMLEFT", MountJournal.LeftInset, "BOTTOMRIGHT", 20, 0)
    else
        button:SetParent(MountJournal.BottomLeftInset)
        button:SetPoint("LEFT", 23, 0)

        -- Show
        MountJournal.BottomLeftInset:Show()
        MountJournal.LeftInset:SetPoint("BOTTOMLEFT", 4, 111)
        MountJournal.RightInset:SetPoint("BOTTOMLEFT", MountJournal.LeftInset, "BOTTOMRIGHT", 20, -85)
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
ADDON:RegisterUIOverhaulCallback(init)