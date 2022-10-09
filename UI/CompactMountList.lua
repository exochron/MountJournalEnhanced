local ADDON_NAME, ADDON = ...

local MOUNT_BUTTON_HEIGHT = 29

local function SaveButtonLayout(button)
    ADDON.UI:SavePoint(button)
    ADDON.UI:SaveSize(button)
    ADDON.UI:SaveSize(button.DragButton)
    ADDON.UI:SaveSize(button.icon)
    ADDON.UI:SavePoint(button.icon)
    ADDON.UI:SavePoint(button.name)
    ADDON.UI:SavePoint(button.new)
    ADDON.UI:SavePoint(button.factionIcon)
end
local function RestoreButtonLayout(button)
    ADDON.UI:RestoreSize(button)
    ADDON.UI:RestorePoint(button)
    ADDON.UI:RestorePoint(button.icon)
    ADDON.UI:RestoreSize(button.icon)
    ADDON.UI:RestoreSize(button.DragButton)
    ADDON.UI:RestorePoint(button.name)
    ADDON.UI:RestorePoint(button.new)
    ADDON.UI:RestorePoint(button.factionIcon)

    if button.backdrop then
        -- ElvUI customization
        button.backdrop:SetInside(button, 3, 3)
    end
end

local function ModifyButton(button)
    button:SetHeight(MOUNT_BUTTON_HEIGHT)
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
end

ADDON:RegisterUISetting('compactMountList', true, ADDON.L.SETTING_COMPACT_LIST, function(flag)
    if ADDON.initialized then
        local box = MountJournal.ScrollBox
        local view = box:GetView()
        if flag then
            box:ForEachFrame(function(button)
                SaveButtonLayout(button)
                ModifyButton(button)
            end)
            ScrollUtil.AddAcquiredFrameCallback(box, function(button, _, new)
                if new then
                    SaveButtonLayout(button)
                end
                if ADDON.settings.ui.compactMountList then
                    ModifyButton(button)
                else
                    RestoreButtonLayout(button)
                end
            end, ADDON_NAME .. 'compact')
            ScrollUtil.AddReleasedFrameCallback(box, RestoreButtonLayout, ADDON_NAME .. 'compact')
            view:SetPadding(0, 0, MOUNT_BUTTON_HEIGHT + 2, 0, 0)
            view:SetElementExtent(MOUNT_BUTTON_HEIGHT)
        else
            box:UnregisterCallback(ScrollBoxListMixin.Event.OnAcquiredFrame, ADDON_NAME .. 'compact')
            box:UnregisterCallback(ScrollBoxListMixin.Event.OnReleasedFrame, ADDON_NAME .. 'compact')
            box:ForEachFrame(function(button)
                RestoreButtonLayout(button)
            end)
            view:SetPadding(0, 0, 44, 0, 0)
            view:SetElementExtent(46)
        end
        box:FullUpdate(false)
        view:Layout()
    end
end)

ADDON.Events:RegisterCallback("loadUI", function()
    ADDON:ApplySetting('compactMountList', ADDON.settings.ui.compactMountList)
end, "compact")