local ADDON_NAME, ADDON = ...

local function createJournalButton(ParentFrame)

    -- the addon DressUp replaces DressUpFrame entirely and doesn't have a ModelScene
    if ParentFrame.ModelScene then

        local AceGUI = LibStub("AceGUI-3.0")

        local button = AceGUI:Create("Button")
        button:SetParent({ content = ParentFrame })
        button:SetText(ADDON.L["Show in Collections"])
        button:SetAutoWidth(true)
        button:SetHeight(22)
        if (ParentFrame == SideDressUpFrame) then
            button.frame:SetFrameStrata("HIGH")
            button:SetPoint("BOTTOM", SideDressUpModel, "BOTTOM", 0, 0)
        else
            button:SetPoint("BOTTOMLEFT", ParentFrame, "BOTTOMLEFT", 7, 4)
        end

        button:SetCallback("OnClick", function()
            if (ParentFrame.mode == "mount") then
                local mountId = ParentFrame:GetAttribute("mountID")
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
        createJournalButton(DressUpFrame)
        createJournalButton(SideDressUpFrame)

        hooksecurefunc("DressUpMount", function(mountId)
            if mountId then
                if SideDressUpFrame.parentFrame and SideDressUpFrame.parentFrame:IsShown() then
                    SideDressUpFrame:SetAttribute("mountID", mountId)
                else
                    DressUpFrame:SetAttribute("mountID", mountId)
                end
            end
        end)

        inititalized = true
    end
end)

ADDON.Events:RegisterCallback("OnLogin", function()
    ADDON:ApplySetting('previewButton', ADDON.settings.ui.previewButton)
end, "dressUp")
