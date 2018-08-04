local ADDON_NAME, ADDON = ...

local MOUNT_BUTTON_HEIGHT = 30
local scrollBarMinMaxHandler

local function HookScrollUpdate(self, totalHeight, displayedHeight)
    if self == MountJournal.ListScrollFrame then
        local totalHeight = C_MountJournal.GetNumDisplayedMounts() * MOUNT_BUTTON_HEIGHT
        local range = floor(totalHeight - self:GetHeight() + 0.5);

        if ( range > 0 and self.scrollBar ) then
            local minVal, maxVal = self.scrollBar:GetMinMaxValues();
            if ( math.floor(self.scrollBar:GetValue()) >= math.floor(maxVal) ) then
                scrollBarMinMaxHandler(self.scrollBar, 0, range)
                if ( math.floor(self.scrollBar:GetValue()) ~= math.floor(range) ) then
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

local function ModifyMountList()
    local scrollFrame = MountJournal.ListScrollFrame
    local buttons = MountJournal.ListScrollFrame.buttons
    scrollFrame.buttons[1]:SetHeight(MOUNT_BUTTON_HEIGHT)
    scrollFrame.buttons[1]:ClearAllPoints()
    scrollFrame.buttons[1]:SetPoint("TOPLEFT", scrollFrame.scrollChild, "TOPLEFT", 34, 0)

    HybridScrollFrame_CreateButtons(scrollFrame, "MountListButtonTemplate")
    scrollBarMinMaxHandler = scrollFrame.scrollBar.SetMinMaxValues
    scrollFrame.scrollBar.SetMinMaxValues = function() end

    for buttonIndex = 1, #buttons do
        local button = buttons[buttonIndex]

        button:SetSize(220, MOUNT_BUTTON_HEIGHT)
        button.DragButton:SetSize(MOUNT_BUTTON_HEIGHT, MOUNT_BUTTON_HEIGHT)
        button.icon:SetSize(MOUNT_BUTTON_HEIGHT, MOUNT_BUTTON_HEIGHT)
        button.icon:ClearAllPoints()
        button.icon:SetPoint("RIGHT", button, "LEFT", -2, 0)

        button.unusable:ClearAllPoints()
        button.unusable:SetPoint("TOPLEFT", button.DragButton)
        button.unusable:SetPoint("BOTTOMRIGHT", button.DragButton)

        button.name:SetWidth(208)
        button.name:ClearAllPoints()
        button.name:SetPoint("LEFT", button, "LEFT", 10, 0)

        button.new:ClearAllPoints()
        button.new:SetPoint("CENTER", button.DragButton)

        button.factionIcon:ClearAllPoints()
        button.factionIcon:SetPoint("RIGHT", button, -1, 0)
        hooksecurefunc(button.factionIcon, "SetAtlas", function(self)
            self:SetSize(MOUNT_BUTTON_HEIGHT, MOUNT_BUTTON_HEIGHT)
        end)
    end

    hooksecurefunc("HybridScrollFrame_Update", HookScrollUpdate)
end

hooksecurefunc(ADDON, "LoadUI",function()
    if ADDON.settings.compactMountList then
        ModifyMountList()
    end
end )