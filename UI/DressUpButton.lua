local ADDON_NAME, ADDON = ...

-- TODO: ElvUI Skinning

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

hooksecurefunc("DressUpMountLink", saveMountIdInFrame)

local function createJournalButton(ParentFrame)
    local button = CreateFrame("Button", nil, ParentFrame, "UIPanelButtonNoTooltipTemplate")
    button:SetText(ADDON.L["Show in Collections"])
    if (ParentFrame == SideDressUpFrame) then
        button:SetFrameStrata("HIGH")
        button:SetPoint("BOTTOM", ParentFrame, "BOTTOM", 0, 14)
    else
        button:SetPoint("BOTTOMLEFT", ParentFrame, "BOTTOMLEFT", 7, 4)
    end
    button:SetSize(button.Text:GetWidth() + 15, 22)
    button:SetScript("OnClick", function(self)
        if (ParentFrame.mode == "mount") then
            local mountId = ParentFrame.mountId;
            if mountId then
                local spellId = select(2, C_MountJournal.GetMountInfoByID(mountId))
                SetCollectionsJournalShown(true, COLLECTIONS_JOURNAL_TAB_INDEX_MOUNTS);
                MountJournal_SelectByMountID(mountId, spellId)
            end
        end
    end)
    button:Hide()

    ParentFrame.ResetButton:HookScript("OnShow", function()
        button:Hide()
    end)
    ParentFrame.ResetButton:HookScript("OnHide", function()
        if (ParentFrame.mode == "mount") then
            button:Show()
        else
            button:Hide()
        end
    end)
end

createJournalButton(DressUpFrame)
createJournalButton(SideDressUpFrame)
