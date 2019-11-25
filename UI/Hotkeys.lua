local ADDON_NAME, ADDON = ...

-- Keyboard Shortcuts:
-- UP: Select Previous Mount
-- DOWN: Select Next Mount

local function FetchCurrentSelectedIndex(totalDisplayed)
    local target = MountJournal.selectedSpellID

    for i = 1, totalDisplayed do
        local _, spellId = C_MountJournal.GetDisplayedMountInfo(i)
        if spellId == target then
            return i
        end
    end
end

local function ScrollToIndex(index)
    local buttonHeight = MountJournal.ListScrollFrame.buttonHeight
    local totalHeight = buttonHeight * (index - 1)
    local scrollFrameHeight = MountJournal.ListScrollFrame:GetHeight()

    local offset = MountJournal.ListScrollFrame.scrollBar:GetValue();
    if (totalHeight + buttonHeight > offset + scrollFrameHeight) then
        offset = totalHeight + buttonHeight - scrollFrameHeight;
    elseif (totalHeight < offset) then
        offset = totalHeight;
    end

    MountJournal.ListScrollFrame.scrollBar:SetValue(offset, true)
end

local function Select(step, totalDisplayed)
    local currentIndex = FetchCurrentSelectedIndex(totalDisplayed)
    local index
    if currentIndex == nil then
        index = 1
    else
        index = currentIndex + step
        if index < 1 then
            index = 1
        elseif index > totalDisplayed then
            index = totalDisplayed
        end
    end
    MountJournal_Select(index)
    ScrollToIndex(index)
end

ADDON:RegisterUISetting('enableCursorKeys', true, ADDON.L.SETTING_CURSOR_KEYS)

ADDON:RegisterLoadUICallback(function()
    -- I had issues handling the keyboard directly at the MountJournal frame. So I used ListScrollFrame instead.
    MountJournal.ListScrollFrame:SetPropagateKeyboardInput(true)
    MountJournal.ListScrollFrame:EnableKeyboard(true)
    MountJournal.ListScrollFrame:SetScript("OnKeyDown", function(self, key)
        local totalDisplayed
        if (key == "DOWN" or key == "UP") and ADDON.settings.ui.enableCursorKeys and not IsModifierKeyDown() then
            totalDisplayed = C_MountJournal.GetNumDisplayedMounts()
            if totalDisplayed > 0 then
                local step = 1
                if key == "UP" then
                    step = -1
                end
                Select(step, totalDisplayed)

                self:SetPropagateKeyboardInput(false)
                return
            end
        end
        self:SetPropagateKeyboardInput(true)
    end)
end)