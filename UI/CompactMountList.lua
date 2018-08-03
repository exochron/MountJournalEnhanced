local ADDON_NAME, ADDON = ...

--TODO:
-- scrollframe
-- faction icon

local MOUNT_BUTTON_HEIGHT = 30

local function UpdateMountList()
    local numDisplayedMounts = C_MountJournal.GetNumDisplayedMounts()
    local totalHeight = numDisplayedMounts * MOUNT_BUTTON_HEIGHT
    HybridScrollFrame_Update(MountJournal.ListScrollFrame, totalHeight, MountJournal.ListScrollFrame:GetHeight())
end

local function ModifyMountList()
    local scrollFrame = MountJournal.ListScrollFrame
    local buttons = MountJournal.ListScrollFrame.buttons
    scrollFrame.buttons[1]:SetHeight(30)

    HybridScrollFrame_CreateButtons(scrollFrame, "MountListButtonTemplate", 44, 0)

    for buttonIndex = 1, #buttons do
        local button = buttons[buttonIndex]

        button:SetHeight(MOUNT_BUTTON_HEIGHT)
        button.icon:SetHeight(MOUNT_BUTTON_HEIGHT)
        button.DragButton:SetHeight(MOUNT_BUTTON_HEIGHT)

        button.name:SetWidth(200)
        button.name:ClearAllPoints()
        button.name:SetPoint("LEFT", button, "LEFT", 10, 0)

        button.new:ClearAllPoints()
        button.new:SetPoint("CENTER", button.DragButton)

        button.factionIcon:ClearAllPoints()
        button.factionIcon:SetPoint("RIGHT", button, -1, 0)
    end

    hooksecurefunc("MountJournal_UpdateMountList", UpdateMountList)
    hooksecurefunc(MountJournal.ListScrollFrame, "update", UpdateMountList)
end

hooksecurefunc(ADDON, "LoadUI", ModifyMountList)