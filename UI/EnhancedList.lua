local ADDON_NAME, ADDON = ...

local function getMountButtonHeight()
    return MountJournal.MJE_ListScrollFrame.buttonHeight
end

local MOUNT_FACTION_TEXTURES = {
    [0] = "MountJournalIcons-Horde",
    [1] = "MountJournalIcons-Alliance"
};
-- from https://www.townlong-yak.com/framexml/live/Blizzard_Collections/Blizzard_MountCollection.lua#386
function ADDON.UI:UpdateMountList()
    local deltaY = 0
    local showMounts = C_MountJournal.GetNumMounts() > 0

    local scrollFrame = MountJournal.MJE_ListScrollFrame
    if not scrollFrame then
        return
    end
    local offset = HybridScrollFrame_GetOffset(scrollFrame);
    local buttons = scrollFrame.buttons;

    local numDisplayedMounts = ADDON.Api:GetNumDisplayedMounts()
    for i = 1, #buttons do
        local button = buttons[i];
        local displayIndex = i + offset;
        if (displayIndex <= numDisplayedMounts and showMounts) then
            local index = displayIndex;
            local creatureName, spellID, icon, active, isUsable, sourceType, isFavorite, isFactionSpecific, faction, isFiltered, isCollected, mountID = ADDON.Api:GetDisplayedMountInfo(index)
            local needsFanfare = C_MountJournal.NeedsFanfare(mountID);
            button.name:SetText(creatureName);
            button.icon:SetTexture(needsFanfare and COLLECTIONS_FANFARE_ICON or icon);
            button.new:SetShown(needsFanfare);
            button.newGlow:SetShown(needsFanfare);
            button.index = index
            button.spellID = spellID
            button.mountID = mountID
            button.active = active
            if (active) then
                button.DragButton.ActiveTexture:Show();
            else
                button.DragButton.ActiveTexture:Hide();
            end
            button:Show();
            if (ADDON.Api:GetSelected() == mountID) then
                button.selected = true;
                button.selectedTexture:Show();
            else
                button.selected = false;
                button.selectedTexture:Hide();
            end
            button:SetEnabled(true);
            CollectionItemListButton_SetRedOverlayShown(button, false);
            button.iconBorder:Hide();
            button.background:SetVertexColor(1, 1, 1, 1);
            if (isUsable or needsFanfare) then
                button.DragButton:SetEnabled(true);
                button.additionalText = nil;
                button.icon:SetDesaturated(false);
                button.icon:SetAlpha(1.0);
                button.name:SetFontObject("GameFontNormal");
            else
                if (isCollected) then
                    CollectionItemListButton_SetRedOverlayShown(button, true);
                    button.DragButton:SetEnabled(true);
                    button.name:SetFontObject("GameFontNormal");
                    button.icon:SetAlpha(0.75);
                    button.additionalText = nil;
                    button.background:SetVertexColor(1, 0, 0, 1);
                else
                    button.icon:SetDesaturated(true);
                    button.DragButton:SetEnabled(false);
                    button.icon:SetAlpha(0.25);
                    button.additionalText = nil;
                    button.name:SetFontObject("GameFontDisable");
                end
            end
            if (isFavorite) then
                button.favorite:Show();
            else
                button.favorite:Hide();
            end
            if (isFactionSpecific) then
                button.factionIcon:SetAtlas(MOUNT_FACTION_TEXTURES[faction], true);
                button.factionIcon:Show();
            else
                button.factionIcon:Hide();
            end
            if (button.showingTooltip) then
                MountJournalMountButton_UpdateTooltip(button);
            end

            if button.DragButton.IsHidden then
                if ADDON.settings.hiddenMounts[spellID] then
                    button.DragButton.IsHidden:SetShown(true)
                else
                    button.DragButton.IsHidden:SetShown(false)
                end
            end
        else
            button.name:SetText("");
            button.icon:SetTexture("Interface\\PetBattles\\MountJournalEmptyIcon");
            button.index = nil;
            button.spellID = 0;
            button.selected = false;
            CollectionItemListButton_SetRedOverlayShown(button, false);
            button.DragButton.ActiveTexture:Hide();
            button.selectedTexture:Hide();
            button:SetEnabled(false);
            button.DragButton:SetEnabled(false);
            button.icon:SetDesaturated(true);
            button.icon:SetAlpha(0.5);
            button.favorite:Hide();
            button.factionIcon:Hide();
            button.background:SetVertexColor(1, 1, 1, 1);
            button.iconBorder:Hide();

            if button.DragButton.IsHidden then
                button.DragButton.IsHidden:SetShown(false)
            end
        end

        _, _, _, _, deltaY = button:GetPoint(1)
    end

    local totalHeight = numDisplayedMounts * getMountButtonHeight()
    if deltaY ~= 0 then
        totalHeight = totalHeight - ((scrollFrame:GetHeight() / getMountButtonHeight()) * deltaY)
    end
    HybridScrollFrame_Update(scrollFrame, totalHeight, scrollFrame:GetHeight());
end

local function SetupButtons(scrollFrame)

    -- generate buttons with original size
    HybridScrollFrame_CreateButtons(scrollFrame, "MountListButtonTemplate", 44, 0)

    local buttons = scrollFrame.buttons
    -- generate more buttons with smaller height
    local height = buttons[1]:GetHeight()
    buttons[1]:SetHeight(height / 3)
    HybridScrollFrame_CreateButtons(scrollFrame, "MountListButtonTemplate")
    -- switch back to original height
    buttons[1]:SetHeight(height)
    HybridScrollFrame_CreateButtons(scrollFrame, "MountListButtonTemplate")

    for i, button in ipairs(buttons) do
        button:SetScript("OnClick", function(self, button)
            if button ~= "LeftButton" then
                -- right click is handled in MountListDropDown.lua
            elseif IsModifiedClick("CHATLINK") then
                -- No MacroFrame exception :>
                local spellLink = GetSpellLink(self.spellID)
                ChatEdit_InsertLink(spellLink)
            elseif (self.mountID ~= ADDON.Api:GetSelected()) then
                ADDON.Api:SetSelected(self.mountID);
            end
        end)
        button.DragButton:SetScript("OnClick", function(self, button)
            local parent = self:GetParent();
            if button ~= "LeftButton" then
            elseif IsModifiedClick("CHATLINK") then
                local spellLink = GetSpellLink(parent.spellID)
                ChatEdit_InsertLink(spellLink)
            else
                ADDON.Api:PickupByID(parent.mountID)
            end
        end)
        button.DragButton:SetScript("OnDragStart", function(self)
            ADDON.Api:PickupByID(self:GetParent().mountID)
        end)

        button:HookScript("OnDoubleClick", function(sender, button)
            if button == "LeftButton" then
                ADDON.Api:UseMount(sender.mountID)
            end
        end)

        -- IsHidden Icon
        button.DragButton.IsHidden = button.DragButton:CreateTexture(nil, "OVERLAY")
        button.DragButton.IsHidden:SetTexture("Interface\\BUTTONS\\UI-GroupLoot-Pass-Up")
        button.DragButton.IsHidden:SetSize(34, 34)
        button.DragButton.IsHidden:SetPoint("CENTER", button.DragButton, "CENTER", 0, 0)
        button.DragButton.IsHidden:SetDrawLayer("OVERLAY", 1)
        button.DragButton.IsHidden:SetShown(false)
    end
end

local function GetMountButtonByMountID(mountID)
    local scrollFrame = MountJournal.MJE_ListScrollFrame
    local buttons = scrollFrame.buttons;
    for i = 1, #buttons do
        local button = buttons[i];
        if button.mountID == mountID then
            return button;
        end
    end
end
local function GetMountDisplayIndexByMountID(mountID)
    for i = 1, ADDON.Api:GetNumDisplayedMounts() do
        local currentMountID = select(12, ADDON.Api:GetDisplayedMountInfo(i))
        if currentMountID == mountID then
            return i;
        end
    end
    return nil;
end
function ADDON.UI:ScrollToSelected()
    local selectedMountID = ADDON.Api:GetSelected()

    local scrollFrame = MountJournal.MJE_ListScrollFrame
    if scrollFrame and selectedMountID then

        local inView
        local button = GetMountButtonByMountID(selectedMountID)
        if button then
            local delta = getMountButtonHeight() * 0.666 -- next button should be at least visible for 2/3
            inView = button:GetTop() > (scrollFrame:GetBottom() + delta) and button:GetBottom() < (scrollFrame:GetTop() - delta)
        else
            inView = false
        end
        if not inView then
            local mountIndex = GetMountDisplayIndexByMountID(selectedMountID)
            if mountIndex then
                HybridScrollFrame_ScrollToIndex(scrollFrame, mountIndex, getMountButtonHeight);
            end
        end
    end
end

ADDON.Events:RegisterCallback("preloadUI", function()
    MountJournal.ListScrollFrame:Hide()
    --ADDON.Debug:CheckListTaint("after list hide")
    MountJournal.MJE_ListScrollFrame = CreateFrame("ScrollFrame", "MountJournalEnhancedListScrollFrame", MountJournal, "MJE_ListScrollFrameTemplate")
    MountJournal.MJE_ListScrollFrame.scrollBar.doNotHide = true
    MountJournal.MJE_ListScrollFrame.update = ADDON.UI.UpdateMountList

    --ADDON.Debug:CheckListTaint("before list buttons")
    SetupButtons(MountJournal.MJE_ListScrollFrame)
    --ADDON.Debug:CheckListTaint("after list buttons")

    hooksecurefunc("MountJournal_UpdateMountList", ADDON.UI.UpdateMountList)

    ADDON.UI:StyleListWithElvUI(MountJournal.MJE_ListScrollFrame)
end, "enhanced list")
