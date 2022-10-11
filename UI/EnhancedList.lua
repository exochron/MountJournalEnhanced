local ADDON_NAME, ADDON = ...

local RestrictionsDB = ADDON.DB.Restrictions

local MOUNT_FACTION_TEXTURES = {
    [0] = "MountJournalIcons-Horde",
    [1] = "MountJournalIcons-Alliance"
};
local COVENANT_TEXTURES = {
    [1] = "covenantchoice-panel-sigil-kyrian",
    [2] = "covenantchoice-panel-sigil-venthyr",
    [3] = "covenantchoice-panel-sigil-nightfae",
    [4] = "covenantchoice-panel-sigil-necrolords",
}
local CLASS_TEXTURES = {
    ["DEATHKNIGHT"] = "Artifacts-DeathKnightFrost-BG-Rune",
    ["DEMONHUNTER"] = "Artifacts-DemonHunter-BG-rune",
    ["DRUID"] = "Artifacts-Druid-BG-rune",
    ["HUNTER"] = "Artifacts-Hunter-BG-rune",
    ["MAGE"] = "Artifacts-MageArcane-BG-rune",
    ["MONK"] = "Artifacts-Monk-BG-rune",
    ["PALADIN"] = "Artifacts-Paladin-BG-rune",
    ["PRIEST"] = "Artifacts-Priest-BG-rune",
    ["ROGUE"] = "Artifacts-Rogue-BG-rune",
    ["SHAMAN"] = "Artifacts-Shaman-BG-rune",
    ["WARLOCK"] = "Artifacts-Warlock-BG-rune",
    ["WARRIOR"] = "Artifacts-Warrior-BG-rune",
    -- TODO: Evoker ?
}

-- originally from MountJournal_InitMountButton()
local function InitMountButton(button, elementData)
    local creatureName, spellID, icon, active, isUsable, sourceType, isFavorite, isFactionSpecific, faction, isFiltered, isCollected, mountID, isForDragonriding = ADDON.Api:GetMountInfoByID(elementData.mountID)
    -- everything below this line is from the original function
    local needsFanfare = C_MountJournal.NeedsFanfare(mountID);

    button.name:SetText(creatureName);
    button.icon:SetTexture(needsFanfare and COLLECTIONS_FANFARE_ICON or icon);
    button.new:SetShown(needsFanfare);
    button.newGlow:SetShown(needsFanfare);

    local yOffset = 1;
    if isForDragonriding then
        if button.name:GetNumLines() == 1 then
            yOffset = 6;
        else
            yOffset = 5;
        end
    end
    button.name:SetPoint("LEFT", button.icon, "RIGHT", 10, yOffset);

    button.DragonRidingLabel:SetShown(isForDragonriding);

    button.index = elementData.index;
    button.spellID = spellID;
    button.mountID = mountID;

    button.active = active;
    if (active) then
        button.DragButton.ActiveTexture:Show();
    else
        button.DragButton.ActiveTexture:Hide();
    end
    button:Show();

    if (MountJournal.selectedSpellID == spellID) then
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
end

local function SetupExtras(button)
    if not button.DragButton.IsHidden then

        button:SetScript("OnClick", function(self, clickButton)
            if clickButton ~= "LeftButton" then
                -- right click is handled in MountListDropDown.lua
            elseif IsModifiedClick("CHATLINK") then
                -- No MacroFrame exception :>
                local mountLink = C_MountJournal.GetMountLink(self.spellID);
                ChatEdit_InsertLink(mountLink);
            elseif self.mountID ~= MountJournal.selectedMountID then
                MountJournal_SelectByMountID(self.mountID)
            end
        end)
        button.DragButton:SetScript("OnClick", function(self, clickButton)
            local parent = self:GetParent();
            if clickButton ~= "LeftButton" then
            elseif IsModifiedClick("CHATLINK") then
                local mountLink = C_MountJournal.GetMountLink(parent.spellID);
                ChatEdit_InsertLink(mountLink);
            else
                ADDON.Api:PickupByID(parent.mountID)
            end
        end)
        button.DragButton:SetScript("OnDragStart", function(self)
            ADDON.Api:PickupByID(self:GetParent().mountID)
        end)
        button:HookScript("OnDoubleClick", function(sender, clickButton)
            if clickButton == "LeftButton" then
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

        button.factionIcon:SetWidth(44)

        button.HalfFactionIcon = button:CreateTexture(nil, "BORDER")
        button.HalfFactionIcon:SetTexCoord(0.5, 1, 0, 1)
        button.HalfFactionIcon:SetPoint("TOPLEFT", button.factionIcon, "TOP")
        button.HalfFactionIcon:SetPoint("BOTTOMRIGHT", button.factionIcon, "BOTTOMRIGHT")

        button.ClassIcon = button:CreateTexture(nil, "BORDER")
        button.ClassIcon:SetPoint("TOPLEFT", button.factionIcon, "TOPLEFT")
        button.ClassIcon:SetPoint("BOTTOMRIGHT", button.factionIcon, "BOTTOMRIGHT")
    end
end

local function UpdateExtras(button, elementData)
    local _, spellID, _, _, _, _, _, isFactionSpecific, faction, _, _, mountID, _ = ADDON.Api:GetMountInfoByID(elementData.mountID)
    if (isFactionSpecific) then
        button.factionIcon:SetAtlas(MOUNT_FACTION_TEXTURES[faction], true)
        button.factionIcon:Show()
        button.factionIcon:SetAlpha(1.0)
    elseif RestrictionsDB[mountID] and RestrictionsDB[mountID].covenant then
        local h = button:GetHeight() - 2
        button.factionIcon:SetAtlas(COVENANT_TEXTURES[RestrictionsDB[mountID].covenant[1]], false)
        button.factionIcon:SetAlpha(0.6)
        button.factionIcon:SetSize(h * 0.8, h)
        button.factionIcon:Show()
    else
        button.factionIcon:Hide()
    end
    if RestrictionsDB[mountID] and RestrictionsDB[mountID].class then
        button.ClassIcon:SetAtlas(CLASS_TEXTURES[RestrictionsDB[mountID].class[1]], false)
        if button.factionIcon:IsShown() then
            button.factionIcon:Hide()
            button.HalfFactionIcon:SetAtlas(button.factionIcon:GetAtlas(), false)
            button.HalfFactionIcon:Show()

            button.ClassIcon:SetPoint("BOTTOMRIGHT", button.factionIcon, "BOTTOM")
            button.ClassIcon:SetTexCoord(0, 0.5, 0, 1)
        else
            button.HalfFactionIcon:Hide()
            button.ClassIcon:SetTexCoord(0, 1, 0, 1)
            button.ClassIcon:SetPoint("BOTTOMRIGHT", button.factionIcon, "BOTTOMRIGHT")
        end

        button.ClassIcon:Show()
    else
        button.ClassIcon:Hide()
        button.HalfFactionIcon:Hide()
    end

    if button.DragButton.IsHidden then
        if ADDON.settings.hiddenMounts[spellID] then
            button.DragButton.IsHidden:SetShown(true)
        else
            button.DragButton.IsHidden:SetShown(false)
        end
    end
end

-- from https://www.townlong-yak.com/framexml/live/Blizzard_Collections/Blizzard_MountCollection.lua#386
-- deprecated: TODO remove after patch 10.0
function ADDON.UI:UpdateMountList()
    MountJournal_UpdateMountList()
end

function ADDON.UI:ScrollToSelected()
    --TODO
end

ADDON.Events:RegisterCallback("preloadUI", function()
    MountJournal.ScrollBox:ForEachFrame(SetupExtras)
    ScrollUtil.AddAcquiredFrameCallback(MountJournal.ScrollBox, function(button, _, new)
        if new then
            SetupExtras(button)
        end
    end, ADDON_NAME .. 'enhanced')

    MountJournal_InitMountButton = function(button, elementData)
        InitMountButton(button, elementData)
        UpdateExtras(button, elementData)
    end

    local view = MountJournal.ScrollBox:GetView()
    local orgSetDataProvider = view.SetDataProvider
    view.SetDataProvider = function(self, orgProvider)
        local dragonridingMounts = MountJournal.needsDragonridingHelpTip and C_MountJournal.GetCollectedDragonridingMounts() or nil

        local data = {}
        for index, mountID in ipairs(ADDON.Api:DisplayedMounts()) do
            table.insert(data, { index = index, mountID = mountID })
            if dragonridingMounts and tContains(dragonridingMounts, mountID) then
                MountJournal.dragonridingHelpTipMountIndex = index;
                dragonridingMounts = nil
            end
        end

        local mountProvider = CreateDataProvider(data)
        ADDON:UpdateProviderSort(mountProvider)
        orgSetDataProvider(self, mountProvider)
    end
    MountJournal.ScrollBox:SetDataProvider(CreateDataProvider(), ScrollBoxConstants.RetainScrollPosition);

    -- TODO: ElvUI okay?
end, "enhanced list")
