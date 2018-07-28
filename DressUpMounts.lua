local ADDON_NAME = ...
local L = CoreFramework:GetModule("Localization", "1.1"):GetLocalization(ADDON_NAME)

local function handleDressUpItem(itemLink)
    local itemId = GetItemInfoInstant(itemLink)
    if itemId then
        local spellId = MountJournalEnhancedItems[itemId]
        if spellId then

            if ( SideDressUpFrame.parentFrame and SideDressUpFrame.parentFrame:IsShown() ) then
                SideDressUpFrame.spellId = spellId
            else
                DressUpFrame.spellId = spellId
            end

            local mountId = C_MountJournal.GetMountFromSpell(spellId);
            if mountId then
                local creatureDisplayID = C_MountJournal.GetMountInfoExtraByID(mountId);
                return DressUpMount(creatureDisplayID);
            end
        end
    end
end

-- handle items for dress up
hooksecurefunc("DressUpItemLink", handleDressUpItem)


local function saveSpellIdInFrame(link)
    if( link ) then
        local _, _, _, linkType, spellId = strsplit(":|H", link);
        if linkType == "spell" then
            spellId = tonumber(spellId);
            if ( SideDressUpFrame.parentFrame and SideDressUpFrame.parentFrame:IsShown() ) then
                SideDressUpFrame.spellId = spellId
            else
                DressUpFrame.spellId = spellId
            end
        end
    end
end
hooksecurefunc("DressUpMountLink", saveSpellIdInFrame)

local function createJournalButton(ParentFrame)
    local button = CreateFrame("Button", nil, ParentFrame, "UIPanelButtonNoTooltipTemplate")
    button:SetText(L["Show in Collections"])
    if (ParentFrame == SideDressUpFrame) then
        button:SetFrameStrata("HIGH")
        button:SetPoint("BOTTOM", ParentFrame, "BOTTOM", 0, 14)
    else
        button:SetPoint("BOTTOMLEFT", ParentFrame, "BOTTOMLEFT", 7, 4)
    end
    button:SetSize(button.Text:GetWidth() + 15, 22)
    button:SetScript("OnClick", function(self)
        if (ParentFrame.mode == "mount") then
            local mountId = C_MountJournal.GetMountFromSpell(ParentFrame.spellId);
            if mountId then
                SetCollectionsJournalShown(true, COLLECTIONS_JOURNAL_TAB_INDEX_MOUNTS);
                MountJournal_SelectByMountID(mountId, ParentFrame.spellId)
            end
        end
    end)
    button:Hide()

    hooksecurefunc(ParentFrame.ResetButton, "Show", function ()
        button:Hide()
    end)
    hooksecurefunc(ParentFrame.ResetButton, "Hide", function ()
        if(ParentFrame.mode == "mount") then
            button:Show()
        else
            button:Hide()
        end
    end)

end
createJournalButton(DressUpFrame)
createJournalButton(SideDressUpFrame)
