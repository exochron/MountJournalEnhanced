local ADDON_NAME, ADDON = ...

local function saveMountIdInFrame(link)
    if (link) then
        local mountId
        local _, _, _, linkType, linkId = strsplit(":|H", link);
        if linkType == "item" then
            mountId = C_MountJournal.GetMountFromItem(tonumber(linkId));
        elseif linkType == "spell" then
            mountId = C_MountJournal.GetMountFromSpell(tonumber(linkId));
        end

        if mountId then
            if (SideDressUpFrame.parentFrame and SideDressUpFrame.parentFrame:IsShown()) then
                SideDressUpFrame.mountId = mountId
            else
                DressUpFrame.mountId = mountId
            end
        end
    end
end

local function createJournalButton(ParentFrame)
    local AceGUI = LibStub("AceGUI-3.0")

    local button = AceGUI:Create("Button")
    button:SetParent({ content = ParentFrame })
    button:SetText(ADDON.L["Show in Collections"])
    button:SetAutoWidth(true)
    if (ParentFrame == SideDressUpFrame) then
        button.frame:SetFrameStrata("HIGH")
        button:SetPoint("BOTTOM", SideDressUpModel, "BOTTOM", 0, 0)
    else
        button:SetPoint("BOTTOMLEFT", ParentFrame, "BOTTOMLEFT", 7, 4)
    end
    button:SetCallback("OnClick", function()
        if (ParentFrame.mode == "mount") then
            local mountId = ParentFrame.mountId;
            if mountId then
                local spellId = select(2, C_MountJournal.GetMountInfoByID(mountId))
                SetCollectionsJournalShown(true, COLLECTIONS_JOURNAL_TAB_INDEX_MOUNTS);
                MountJournal_SelectByMountID(mountId, spellId)
            end
        end
    end)

    -- Todo: wobbly show/hide
    ParentFrame.ResetButton:HookScript("OnShow", function()
        button.frame:Hide()
    end)
    ParentFrame.ResetButton:HookScript("OnHide", function()
        if (ParentFrame.mode == "mount" and ADDON.settings.previewButton) then
            button.frame:Show()
        else
            button.frame:Hide()
        end
    end)
    ParentFrame:HookScript("OnShow", function()
        if (ParentFrame.mode == "mount" and ADDON.settings.previewButton) then
            button.frame:Show()
        else
            button.frame:Hide()
        end
    end)
end

local inititalized = false

function ADDON:ApplyPreviewButton(flag)
    ADDON.settings.previewButton = flag

    if (flag and not inititalized) then
        createJournalButton(DressUpFrame)
        createJournalButton(SideDressUpFrame)

        hooksecurefunc("DressUpMountLink", saveMountIdInFrame)

        inititalized = true
    end
end

ADDON:RegisterLoginCallback(function ()
    ADDON:ApplyPreviewButton(ADDON.settings.previewButton)
end)
