local _, ADDON = ...

-- Keyboard Shortcuts:
-- UP: Select Previous Mount
-- DOWN: Select Next Mount

local function FetchCurrentSelectedIndex()
    local target = MountJournal.selectedMountID
    if target then
        return MountJournal.ScrollBox:FindByPredicate(function(element)
            return element.mountID == target
        end)
    end
end

local function Select(step, totalDisplayed)
    local currentIndex = FetchCurrentSelectedIndex()
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

    MountJournal.ScrollBox:ScrollToElementDataIndex(index)
    local frame = MountJournal.ScrollBox:FindFrame(MountJournal.ScrollBox:Find(index))
    if frame then
        frame:Click()
    end
end

ADDON:RegisterUISetting('enableCursorKeys', true, ADDON.L.SETTING_CURSOR_KEYS)

ADDON.Events:RegisterCallback("loadUI", function()
    local scrollFrame = MountJournal.ScrollBox

    -- I had issues handling the input directly at the MountJournal frame. So I'm using the ScrollFrame instead.
    scrollFrame:SetPropagateKeyboardInput(true)
    scrollFrame:EnableKeyboard(true)
    scrollFrame:HookScript("OnKeyDown", function(self, key)
        local totalDisplayed
        if (key == "DOWN" or key == "UP") and ADDON.settings.ui.enableCursorKeys and not IsModifierKeyDown() then
            totalDisplayed = ADDON.Api:GetDataProvider():GetSize()
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
end, "hotkeys")