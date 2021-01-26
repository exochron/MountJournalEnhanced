local ADDON_NAME, ADDON = ...

ADDON.Api = {}

local indexMap -- initialize with nil, so we know if it's not ready yet and not just empty

local function OwnIndexToOriginal(index)
    -- index=0 => SummonRandomButton
    if index == 0 then
        return index
    end

    return indexMap[index] and indexMap[index][2] or nil
end
local function OwnIndexToMountId(index)
    -- index=0 => SummonRandomButton
    if index == 0 then
        return index
    end

    return indexMap[index] and indexMap[index][1] or nil
end
local function MountIdToOwnIndex(mountId)
    for i, blob in ipairs(indexMap) do
        if blob[1] == mountId then
            return i
        end
    end

    return nil
end
local function MountIdToOriginalIndex(mountId)
    for i, blob in ipairs(indexMap) do
        if blob[1] == mountId then
            return blob[2] or nil
        end
    end

    return nil
end

function ADDON.Api.GetNumDisplayedMounts()
    if nil == indexMap then
        ADDON:UpdateIndex()
    end

    return #indexMap
end

function ADDON.Api.GetDisplayedMountInfo(index)
    if nil == indexMap then
        ADDON:UpdateIndex()
    end

    local mappedMountId = OwnIndexToMountId(index)
    if mappedMountId then
        local creatureName, spellId, icon, active, isUsable, sourceType, isFavorite, isFaction, faction, hideOnChar, isCollected, mountID, a, b, c, d, e, f, g, h = C_MountJournal.GetMountInfoByID(mappedMountId)
        isUsable = isUsable and IsUsableSpell(spellId)

        return creatureName, spellId, icon, active, isUsable, sourceType, isFavorite, isFaction, faction, hideOnChar, isCollected, mountID, a, b, c, d, e, f, g, h
    end
end
function ADDON.Api.GetDisplayedMountInfoExtra(index, ...)
    if nil == indexMap then
        ADDON:UpdateIndex()
    end

    local mountId = OwnIndexToMountId(index)
    if mountId then
        return C_MountJournal.GetMountInfoExtraByID(mountId, ...)
    end
end
function ADDON.Api.GetDisplayedMountAllCreatureDisplayInfo(index, ...)
    if nil == indexMap then
        ADDON:UpdateIndex()
    end

    local mountId = OwnIndexToMountId(index)
    if mountId then
        return C_MountJournal.GetMountAllCreatureDisplayInfoByID(mountId, ...)
    end
end
function ADDON.Api.Pickup(index, ...)
    if nil == indexMap then
        ADDON:UpdateIndex()
    end

    index = OwnIndexToOriginal(index)
    if index then
        return C_MountJournal.Pickup(index, ...)
    end
end
function ADDON.Api.GetIsFavorite(index, ...)
    if nil == indexMap then
        ADDON:UpdateIndex()
    end

    index = OwnIndexToOriginal(index)
    if index then
        return C_MountJournal.GetIsFavorite(index, ...)
    end
end
function ADDON.Api.GetIsFavoriteByID(mountId, ...)
    if nil == indexMap then
        ADDON:UpdateIndex()
    end

    local index = MountIdToOriginalIndex(mountId)
    if index then
        return C_MountJournal.GetIsFavorite(index, ...)
    end
end
function ADDON.Api.SetIsFavorite(index, ...)
    if nil == indexMap then
        ADDON:UpdateIndex()
    end

    index = OwnIndexToOriginal(index)
    if index then
        return C_MountJournal.SetIsFavorite(index, ...)
    end
end
function ADDON.Api.SetIsFavoriteByID(mountId, ...)
    if nil == indexMap then
        ADDON:UpdateIndex()
    end

    local index = MountIdToOriginalIndex(mountId)
    if index then
        return C_MountJournal.SetIsFavorite(index, ...)
    end
end


function ADDON:UpdateIndex(calledFromEvent)
    local map = {}
    local handledMounts = {}

    local searchString = MountJournal.searchBox:GetText() or ""
    if searchString ~= "" then
        searchString = searchString:lower()
    end

    for i = 1, C_MountJournal.GetNumDisplayedMounts() do
        local mountId = select(12, C_MountJournal.GetDisplayedMountInfo(i))
        if ADDON:FilterMount(mountId, searchString) then
            map[#map + 1] = { mountId, i }
        end
        handledMounts[mountId] = true
    end

    for _, mountId in ipairs(C_MountJournal.GetMountIDs()) do
        if not handledMounts[mountId] and ADDON:FilterMount(mountId, searchString) then
            map[#map + 1] = { mountId }
        end
    end

    if calledFromEvent and nil ~= indexMap and #map == #indexMap then
        return
    end

    indexMap = ADDON:SortMounts(map)
end

local MOUNT_FACTION_TEXTURES = {
    [0] = "MountJournalIcons-Horde",
    [1] = "MountJournalIcons-Alliance"
};

function ADDON:UpdateMountList()
    local showMounts = C_MountJournal.GetNumMounts() > 0

    local scrollFrame = MountJournal.ListScrollFrame;
    local offset = HybridScrollFrame_GetOffset(scrollFrame);
    local buttons = scrollFrame.buttons;

    local numDisplayedMounts = ADDON.Api.GetNumDisplayedMounts()
    for i=1, #buttons do
        local button = buttons[i];
        local displayIndex = i + offset;
        if ( displayIndex <= numDisplayedMounts and showMounts ) then
            local index = displayIndex;
            local creatureName, spellID, icon, active, isUsable, sourceType, isFavorite, isFactionSpecific, faction, isFiltered, isCollected, mountID = ADDON.Api.GetDisplayedMountInfo(index)
            local needsFanfare = C_MountJournal.NeedsFanfare(mountID);
            button.name:SetText(creatureName);
            button.icon:SetTexture(needsFanfare and COLLECTIONS_FANFARE_ICON or icon);
            button.new:SetShown(needsFanfare);
            button.newGlow:SetShown(needsFanfare);
            button.MJE_index = index
            button.MJE_spellID = spellID
            button.MJE_mountID = mountID
            button.MJE_active = active
            if (active) then
                button.DragButton.ActiveTexture:Show();
            else
                button.DragButton.ActiveTexture:Hide();
            end
            button:Show();
            if ( MountJournal.selectedSpellID == spellID ) then
                button.MJE_selected = true;
                button.selectedTexture:Show();
            else
                button.MJE_selected = false;
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
            if ( isFavorite ) then
                button.favorite:Show();
            else
                button.favorite:Hide();
            end
            if ( isFactionSpecific ) then
                button.factionIcon:SetAtlas(MOUNT_FACTION_TEXTURES[faction], true);
                button.factionIcon:Show();
            else
                button.factionIcon:Hide();
            end
            if ( button.showingTooltip ) then
                MountJournalMountButton_UpdateTooltip(button);
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
        end

        -- overwrite click handler
        button:SetScript("OnClick", function(self, button)
            if ( button ~= "LeftButton" ) then
                -- menu via MountListDropDown.lua
            elseif ( IsModifiedClick("CHATLINK") ) then
                -- ignore macro frame here :>
                local id = self.MJE_spellID;
                local spellLink = GetSpellLink(id);
                ChatEdit_InsertLink(spellLink);
            elseif ( self.MJE_spellID ~= MountJournal.MJE_selectedSpellID ) then
                MountJournal_SelectByMountID(self.MJE_mountID); -- taints
            end
        end)
    end
end

ADDON:RegisterLoadUICallback(function()
    hooksecurefunc("MountJournal_UpdateMountList", ADDON.UpdateMountList)
    hooksecurefunc(MountJournal.ListScrollFrame, "update", ADDON.UpdateMountList)

end)