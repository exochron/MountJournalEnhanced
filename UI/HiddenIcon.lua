local ADDON_NAME, ADDON = ...

local function UpdateMountList()
    local buttons = MountJournal.ListScrollFrame.buttons
    for i = 1, #buttons do
        if (ADDON.settings.hiddenMounts[buttons[i].spellID]) then
            buttons[i].DragButton.IsHidden:SetShown(true)
        else
            buttons[i].DragButton.IsHidden:SetShown(false)
        end
        buttons[i].DragButton:SetEnabled(true)
    end
end

local function AddHiddenIcons()
    local buttons = MountJournal.ListScrollFrame.buttons
    for buttonIndex = 1, #buttons do
        local button = buttons[buttonIndex]
        button.DragButton.IsHidden = button.DragButton:CreateTexture(nil, "OVERLAY")
        button.DragButton.IsHidden:SetTexture("Interface\\BUTTONS\\UI-GroupLoot-Pass-Up")
        button.DragButton.IsHidden:SetSize(34, 34)
        button.DragButton.IsHidden:SetPoint("CENTER", button.DragButton, "CENTER", 0, 0)
        button.DragButton.IsHidden:SetDrawLayer("OVERLAY", 1)
        button.DragButton.IsHidden:SetShown(false)
    end

    hooksecurefunc("MountJournal_UpdateMountList", UpdateMountList)
    hooksecurefunc(MountJournal.ListScrollFrame, "update", UpdateMountList)
end

ADDON:RegisterLoadUICallback(AddHiddenIcons)