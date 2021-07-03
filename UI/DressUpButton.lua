local _, ADDON = ...

local function createJournalButton(ParentFrame, ...)

    -- the addon DressUp replaces DressUpFrame entirely and doesn't have a ModelScene
    if ParentFrame.ModelScene then

        local AceGUI = LibStub("AceGUI-3.0")

        local button = AceGUI:Create("Button")
        button:SetParent({ content = ParentFrame })
        button:SetText(ADDON.L["Show in Collections"])
        button:SetAutoWidth(true)
        button:SetHeight(22)
        button:SetPoint(...)

        button:SetCallback("OnClick", function(self)
            local parentFrame = self.parent.content
            if parentFrame.mode == "mount" then
                local mountId = parentFrame:GetAttribute("mountID")
                if mountId then
                    SetCollectionsJournalShown(true, COLLECTIONS_JOURNAL_TAB_INDEX_MOUNTS);
                    ADDON.Api:SetSelected(mountId)
                end
            end
        end)

        hooksecurefunc(ParentFrame.ModelScene, "ClearScene", function()
            button.frame:Hide()
        end)
        hooksecurefunc(ParentFrame.ModelScene, "AttachPlayerToMount", function()
            if ADDON.settings.ui.previewButton then
                button.frame:Show()
            end
        end)
    end
end

local inititalized = false

ADDON:RegisterUISetting('previewButton', true, ADDON.L.SETTING_PREVIEW_LINK, function(flag)
    if flag and not inititalized then
        createJournalButton(DressUpFrame, "BOTTOMLEFT", DressUpFrame, "BOTTOMLEFT", 7, 4)

        hooksecurefunc("DressUpMount", function(mountId)
            if mountId then
                DressUpFrame:SetAttribute("mountID", mountId)
            end
        end)

        inititalized = true
    end
end)

ADDON.Events:RegisterCallback("OnLogin", function()
    ADDON:ApplySetting('previewButton', ADDON.settings.ui.previewButton)
end, "dressUp")
