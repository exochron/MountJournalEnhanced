local _, ADDON = ...

-- Keyboard Shortcuts:
-- UP: Select Previous Mount
-- DOWN: Select Next Mount
-- HOME: Select first Mount
-- END: Select last Mount

local function FetchCurrentSelectedIndex()
    local target = MountJournal.selectedMountID
    if target then
        return MountJournal.ScrollBox:FindByPredicate(function(element)
            return element.mountID == target
        end)
    end
end

local function JumpTo(index)
    MountJournal.ScrollBox:ScrollToElementDataIndex(index)
    local frame = MountJournal.ScrollBox:FindFrame(MountJournal.ScrollBox:Find(index))
    if frame then
        frame:Click()
    end
end

local function Select(step, totalDisplayed)
    local currentIndex = FetchCurrentSelectedIndex()
    if currentIndex == nil then
        return JumpTo(1)
    end

    local index = currentIndex + step
    if index < 1 then
        JumpTo(1)
    elseif index > totalDisplayed then
        JumpTo(totalDisplayed)
    else
        JumpTo(index)
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
        if (key == "DOWN" or key == "UP" or key == "HOME" or key == "END") and ADDON.settings.ui.enableCursorKeys and not IsModifierKeyDown() then
            totalDisplayed = ADDON.Api:GetDataProvider():GetSize()
            if totalDisplayed > 0 then
                if key == "END" then
                    JumpTo(totalDisplayed)
                elseif key == "HOME" then
                    JumpTo(1)
                elseif key == "UP" then
                    Select(-1, totalDisplayed)
                elseif key == "DOWN" then
                    Select(1, totalDisplayed)
                end

                self:SetPropagateKeyboardInput(false)
                return
            end
        end
        self:SetPropagateKeyboardInput(true)
    end)
end, "hotkeys")