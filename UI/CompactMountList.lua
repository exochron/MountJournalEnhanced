local ADDON_NAME, ADDON = ...

local MOUNT_BUTTON_HEIGHT = 29
local scrollBarMinMaxHandler

local function HookScrollUpdate(self, totalHeight, displayedHeight)
    if self == MountJournal.ListScrollFrame then
        totalHeight = C_MountJournal.GetNumDisplayedMounts() * (MOUNT_BUTTON_HEIGHT + 1)
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

local function GenerateButtons()
    local scrollFrame = MountJournal.ListScrollFrame
    local buttons = scrollFrame.buttons

    buttons[1]:SetHeight(MOUNT_BUTTON_HEIGHT)
    buttons[1]:ClearAllPoints()
    buttons[1]:SetPoint("TOPLEFT", scrollFrame.scrollChild, "TOPLEFT", 33, 0)
    HybridScrollFrame_CreateButtons(scrollFrame, "MountListButtonTemplate", nil, nil, nil, nil, 0, -1)

    scrollBarMinMaxHandler = scrollFrame.scrollBar.SetMinMaxValues
    scrollFrame.scrollBar.SetMinMaxValues = function()
    end
    hooksecurefunc("HybridScrollFrame_Update", HookScrollUpdate)
end

local function ModifyListButtons()
    local previousButton
    for _, button in pairs(MountJournal.ListScrollFrame.buttons) do
        if (previousButton) then
            button:ClearAllPoints()
            button:SetPoint("TOPLEFT", previousButton, "BOTTOMLEFT", 0, -1)
        end

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

        button.name:ClearAllPoints()
        button.name:SetPoint("LEFT", button, "LEFT", 10, 0)
        button.name:SetPoint("RIGHT", button, "RIGHT", -10, 0)

        button.new:ClearAllPoints()
        button.new:SetPoint("CENTER", button.DragButton)

        button.factionIcon:ClearAllPoints()
        button.factionIcon:SetPoint('TOPRIGHT', -2, -2)
        button.factionIcon:SetPoint('TOPLEFT', button, "TOPRIGHT", -2 - MOUNT_BUTTON_HEIGHT, -2)
        button.factionIcon:SetPoint('BOTTOMRIGHT', -2, 2)

        previousButton = button
    end
end

local doInit = true

ADDON:RegisterLoadUICallback(function()
    if ADDON.settings.compactMountList then
        if doInit then
            doInit = false
            GenerateButtons()
        end
        ModifyListButtons()
    end
end)

-- UI Pack fix  (eg. ElvUI, TukUI)
ADDON:RegisterUIOverhaulCallback(function(self)
    if (doInit and self == MountJournal and ADDON.settings.compactMountList) then
        doInit = false
        GenerateButtons()
    end
end)