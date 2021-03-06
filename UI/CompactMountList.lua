local ADDON_NAME, ADDON = ...

local MOUNT_BUTTON_HEIGHT = 29

local function ModifyListButtons()
    local scrollFrame = MountJournal.MJE_ListScrollFrame
    local buttons = scrollFrame.buttons

    buttons[1]:SetHeight(MOUNT_BUTTON_HEIGHT)
    buttons[1]:ClearAllPoints()
    buttons[1]:SetPoint("TOPLEFT", scrollFrame.scrollChild, "TOPLEFT", 33, 0)
    HybridScrollFrame_CreateButtons(scrollFrame, "MountListButtonTemplate")

    local previousButton
    for _, button in pairs(scrollFrame.buttons) do
        if previousButton then
            button:ClearAllPoints()
            button:SetPoint("TOPLEFT", previousButton, "BOTTOMLEFT", 0, -1)
        end

        button:SetSize(221, MOUNT_BUTTON_HEIGHT)
        button.DragButton:SetSize(MOUNT_BUTTON_HEIGHT, MOUNT_BUTTON_HEIGHT)
        button.icon:SetSize(MOUNT_BUTTON_HEIGHT, MOUNT_BUTTON_HEIGHT)
        button.icon:ClearAllPoints()
        button.icon:SetPoint("RIGHT", button, "LEFT", -2, 0)

        if button.backdrop then
            -- ElvUI customization
            button.backdrop:SetInside(button, 0, 0)
            button.icon:SetSize(MOUNT_BUTTON_HEIGHT - 2, MOUNT_BUTTON_HEIGHT - 2)
        end

        button.name:ClearAllPoints()
        button.name:SetPoint("LEFT", button, "LEFT", 10, 0)
        button.name:SetPoint("RIGHT", button, "RIGHT", -10, 0)

        button.new:ClearAllPoints()
        button.new:SetPoint("CENTER", button.DragButton)

        button.factionIcon:ClearAllPoints()
        button.factionIcon:SetPoint('TOPRIGHT', -2, -2)
        button.factionIcon:SetPoint('TOPLEFT', button, "TOPRIGHT", 2 - MOUNT_BUTTON_HEIGHT, -2)
        button.factionIcon:SetPoint('BOTTOMRIGHT', -2, 2)

        previousButton = button
    end
end

local function SaveLayout()
    local scrollFrame = MountJournal.MJE_ListScrollFrame
    for _, button in pairs(scrollFrame.buttons) do
        ADDON.UI:SavePoint(button)
        ADDON.UI:SaveSize(button)
        ADDON.UI:SaveSize(button.DragButton)
        ADDON.UI:SaveSize(button.icon)
        ADDON.UI:SavePoint(button.icon)
        ADDON.UI:SavePoint(button.name)
        ADDON.UI:SavePoint(button.new)
        ADDON.UI:SavePoint(button.factionIcon)
    end
end
local function RestoreLayout()
    local scrollFrame = MountJournal.MJE_ListScrollFrame

    for _, button in pairs(scrollFrame.buttons) do
        ADDON.UI:RestorePoint(button)
        ADDON.UI:RestoreSize(button)
        ADDON.UI:RestoreSize(button.DragButton)
        ADDON.UI:RestoreSize(button.icon)
        ADDON.UI:RestorePoint(button.icon)
        ADDON.UI:RestorePoint(button.name)
        ADDON.UI:RestorePoint(button.new)
        ADDON.UI:RestorePoint(button.factionIcon)

        if button.backdrop then
            -- ElvUI customization
            button.backdrop:SetInside(button, 3, 3)
        end
    end

    HybridScrollFrame_CreateButtons(scrollFrame, "MountListButtonTemplate")
end

local saved = false
ADDON:RegisterUISetting('compactMountList', true, ADDON.L.SETTING_COMPACT_LIST, function(flag)
    if ADDON.initialized then
        if flag then
            if not saved then
                SaveLayout()
                saved = true
            end
            ModifyListButtons()
        else
            RestoreLayout()
        end
    end
end)

ADDON.Events:RegisterCallback("loadUI", function()
    ADDON:ApplySetting('compactMountList', ADDON.settings.ui.compactMountList)
end, "compact")