local ADDON_NAME, ADDON = ...

local MOUNT_BUTTON_HEIGHT = 29

--region scroll handling
local scrollBarMinMaxHandler

local function HookScrollUpdate(self, totalHeight, displayedHeight)
    if self == MountJournal.ListScrollFrame then
        local button = MountJournal.ListScrollFrame.buttons[2]

        local height = button:GetHeight()
        totalHeight = C_MountJournal.GetNumDisplayedMounts() * height

        local _, _, _, _, yOfs = button:GetPoint(1)
        if (yOfs ~= 0) then
            yOfs = -yOfs
            local countButtons = self:GetHeight() / height
            totalHeight = totalHeight + (countButtons * yOfs)
        end

        local range = floor(totalHeight - self:GetHeight() + 0.5);

        if (range > 0 and self.scrollBar) then
            local minVal, maxVal = self.scrollBar:GetMinMaxValues();
            if (math.floor(self.scrollBar:GetValue()) >= math.floor(maxVal)) then
                scrollBarMinMaxHandler(self.scrollBar, 0, range)
                if (math.floor(self.scrollBar:GetValue()) ~= math.floor(range)) then
                    self.scrollBar:SetValue(range);
                else
                    HybridScrollFrame_SetOffset(self, range); -- If we've scrolled to the bottom, we need to recalculate the offset.
                end
            else
                scrollBarMinMaxHandler(self.scrollBar, 0, range)
            end
            self.scrollBar:Enable();
            HybridScrollFrame_UpdateButtonStates(self);
            self.scrollBar:Show();
        end

        self.totalHeight = totalHeight
        self.range = range
        self:UpdateScrollChildRect()
    end
end

local function SetupScrollFix()
    scrollBarMinMaxHandler = MountJournal.ListScrollFrame.scrollBar.SetMinMaxValues
    MountJournal.ListScrollFrame.scrollBar.SetMinMaxValues = function()
    end
    hooksecurefunc("HybridScrollFrame_Update", HookScrollUpdate)
end
--endregion

local function GenerateButtons()
    local scrollFrame = MountJournal.ListScrollFrame
    local buttons = scrollFrame.buttons

    -- first generate some buttons
    local height = buttons[1]:GetHeight()
    buttons[1]:SetHeight(21)
    HybridScrollFrame_CreateButtons(scrollFrame, "MountListButtonTemplate")

    -- then change back
    buttons[1]:SetHeight(height)
    HybridScrollFrame_CreateButtons(scrollFrame, "MountListButtonTemplate")
end

local function ModifyListButtons()
    local scrollFrame = MountJournal.ListScrollFrame
    local buttons = scrollFrame.buttons

    ADDON.UI:SavePoint(buttons[1])
    ADDON.UI:SaveSize(buttons[1])

    buttons[1]:SetHeight(MOUNT_BUTTON_HEIGHT)
    buttons[1]:ClearAllPoints()
    buttons[1]:SetPoint("TOPLEFT", scrollFrame.scrollChild, "TOPLEFT", 33, 0)
    HybridScrollFrame_CreateButtons(scrollFrame, "MountListButtonTemplate")

    local previousButton
    for _, button in pairs(scrollFrame.buttons) do
        if (previousButton) then
            ADDON.UI:SavePoint(button)
            ADDON.UI:SaveSize(button)

            button:ClearAllPoints()
            button:SetPoint("TOPLEFT", previousButton, "BOTTOMLEFT", 0, -1)
        end

        ADDON.UI:SaveSize(button.DragButton)
        ADDON.UI:SaveSize(button.icon)
        ADDON.UI:SavePoint(button.icon)
        button:SetSize(221, MOUNT_BUTTON_HEIGHT)
        button.DragButton:SetSize(MOUNT_BUTTON_HEIGHT, MOUNT_BUTTON_HEIGHT)
        button.icon:SetSize(MOUNT_BUTTON_HEIGHT, MOUNT_BUTTON_HEIGHT)
        button.icon:ClearAllPoints()
        button.icon:SetPoint("RIGHT", button, "LEFT", -2, 0)

        if (button.backdrop) then
            -- ElvUI customization
            button.backdrop:SetInside(button, 0, 0)
            button.icon:SetSize(MOUNT_BUTTON_HEIGHT - 2, MOUNT_BUTTON_HEIGHT - 2)
        end

        ADDON.UI:SavePoint(button.name)
        button.name:ClearAllPoints()
        button.name:SetPoint("LEFT", button, "LEFT", 10, 0)
        button.name:SetPoint("RIGHT", button, "RIGHT", -10, 0)

        ADDON.UI:SavePoint(button.new)
        button.new:ClearAllPoints()
        button.new:SetPoint("CENTER", button.DragButton)

        ADDON.UI:SavePoint(button.factionIcon)
        button.factionIcon:ClearAllPoints()
        button.factionIcon:SetPoint('TOPRIGHT', -2, -2)
        button.factionIcon:SetPoint('TOPLEFT', button, "TOPRIGHT", -2 - MOUNT_BUTTON_HEIGHT, -2)
        button.factionIcon:SetPoint('BOTTOMRIGHT', -2, 2)

        previousButton = button
    end
end

local function RestoreListButtons()
    local scrollFrame = MountJournal.ListScrollFrame

    for _, button in pairs(scrollFrame.buttons) do
        ADDON.UI:RestorePoint(button)
        ADDON.UI:RestoreSize(button)
        ADDON.UI:RestoreSize(button.DragButton)
        ADDON.UI:RestoreSize(button.icon)
        ADDON.UI:RestorePoint(button.icon)
        ADDON.UI:RestorePoint(button.name)
        ADDON.UI:RestorePoint(button.new)
        ADDON.UI:RestorePoint(button.factionIcon)

        if (button.backdrop) then
            -- ElvUI customization
            button.backdrop:SetInside(button, 3, 3)
        end
    end

    HybridScrollFrame_CreateButtons(scrollFrame, "MountListButtonTemplate")
end

ADDON:RegisterUISetting('compactMountList', true, ADDON.L.SETTING_COMPACT_LIST, function(flag)
    if (MountJournal) then
        if (flag) then
            ModifyListButtons()
        else
            RestoreListButtons()
        end
    end
end)

local doInit = true

ADDON:RegisterLoadUICallback(function()
    if doInit then
        doInit = false
        GenerateButtons()
        SetupScrollFix()
    end
    ADDON:ApplySetting('compactMountList', ADDON.settings.ui.compactMountList)
end)

-- UI Pack fix  (eg. ElvUI, TukUI)
ADDON.UI:RegisterUIOverhaulCallback(function(self)
    if (doInit and self == MountJournal) then
        doInit = false
        GenerateButtons()
        SetupScrollFix()
    end
end)