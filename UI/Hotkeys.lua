local ADDON_NAME, ADDON = ...

-- UI:
-- * RightClick on Scroll buttons to scroll to the top/bottom

-- Keyboard Shortcuts:
-- UP: Select Previous Mount
-- DOWN: Select Next Mount

local function FetchCurrentSelectedIndex(totalDisplayed)
    local target = ADDON.Api:GetSelected()

    for i = 1, totalDisplayed do
        local mountId = select(12, ADDON.Api:GetDisplayedMountInfo(i))
        if mountId == target then
            return i
        end
    end
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

    local mountId = select(12, ADDON.Api:GetDisplayedMountInfo(index))
    ADDON.Api:SetSelected(mountId)
end

ADDON:RegisterUISetting('enableCursorKeys', true, ADDON.L.SETTING_CURSOR_KEYS)

ADDON.Events:RegisterCallback("loadUI", function()
    local scrollFrame = MountJournal.MJE_ListScrollFrame

    -- I had issues handling the input directly at the MountJournal frame. So I'm using ListScrollFrame instead.
    scrollFrame:SetPropagateKeyboardInput(true)
    scrollFrame:EnableKeyboard(true)
    scrollFrame:HookScript("OnKeyDown", function(self, key)
        local totalDisplayed
        if (key == "DOWN" or key == "UP") and ADDON.settings.ui.enableCursorKeys and not IsModifierKeyDown() then
            totalDisplayed = ADDON.Api:GetNumDisplayedMounts()
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

    scrollFrame.scrollDown:RegisterForClicks("LeftButtonUp", "LeftButtonDown", "RightButtonUp");
    scrollFrame.scrollDown:HookScript("OnClick", function(self, button, isDown)
        if button == "RightButton" and not isDown then
            scrollFrame.scrollBar:SetValue(scrollFrame.range)
        end
    end)
    scrollFrame.scrollUp:RegisterForClicks("LeftButtonUp", "LeftButtonDown", "RightButtonUp");
    scrollFrame.scrollUp:HookScript("OnClick", function(self, button, isDown)
        if button == "RightButton" and not isDown then
            scrollFrame.scrollBar:SetValue(0)
        end
    end)
end, "hotkeys")