local ADDON_NAME, ADDON = ...

ADDON.Api = {}

local indexMap -- initialize with nil, so we know if it's not ready yet and not just empty

local function OwnIndexToMountId(index)
    -- index=0 => SummonRandomButton
    if index == 0 then
        return index
    end

    return indexMap[index] and indexMap[index][1] or nil
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
        ADDON.Api:UpdateIndex()
    end

    return #indexMap
end

function ADDON.Api.GetMountInfoByID(mountId)
    local creatureName, spellId, icon, active, isUsable, sourceType, isFavorite, isFaction, faction, hideOnChar, isCollected, mountID, a, b, c, d, e, f, g, h = C_MountJournal.GetMountInfoByID(mountId)
    isUsable = isUsable and IsUsableSpell(spellId)

    return creatureName, spellId, icon, active, isUsable, sourceType, isFavorite, isFaction, faction, hideOnChar, isCollected, mountID, a, b, c, d, e, f, g, h
end
function ADDON.Api.GetDisplayedMountInfo(index)
    if nil == indexMap then
        ADDON.Api:UpdateIndex()
    end

    local mappedMountId = OwnIndexToMountId(index)
    if mappedMountId then
        return ADDON.Api.GetMountInfoByID(mappedMountId)
    end
end
function ADDON.Api.PickupByID(mountId, ...)
    if nil == indexMap then
        ADDON.Api:UpdateIndex()
    end

    local index = MountIdToOriginalIndex(mountId)
    if index then
        return C_MountJournal.Pickup(index, ...)
    end
end
function ADDON.Api.GetIsFavoriteByID(mountId, ...)
    if nil == indexMap then
        ADDON.Api:UpdateIndex()
    end

    local index = MountIdToOriginalIndex(mountId)
    if index then
        return C_MountJournal.GetIsFavorite(index, ...)
    end
end
function ADDON.Api.SetIsFavoriteByID(mountId, ...)
    if nil == indexMap then
        ADDON.Api:UpdateIndex()
    end

    local index = MountIdToOriginalIndex(mountId)
    if index then
        return C_MountJournal.SetIsFavorite(index, ...)
    end
end

function ADDON.Api:UpdateIndex(calledFromEvent)
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


local selectedMount
function ADDON.Api:SetSelected(selectedMountID)
    selectedMount = selectedMountID
    --MountJournal_HideMountDropdown();
    ADDON.UI:UpdateMountList()
    ADDON.UI:UpdateMountDisplay()
    ADDON.UI:ScrollToSelected()
end
function ADDON.Api:GetSelected()
    return selectedMount
end

-- from https://www.townlong-yak.com/framexml/live/Blizzard_Collections/Blizzard_MountCollection.lua#668
function ADDON.Api:UseMount(mountID)
    if mountID then
        local creatureName, spellID, icon, active = C_MountJournal.GetMountInfoByID(mountID);
        if ( active ) then
            C_MountJournal.Dismiss();
        elseif ( C_MountJournal.NeedsFanfare(mountID) ) then
            local function OnFinishedCallback()
                C_MountJournal.ClearFanfare(mountID);
                --MountJournal_HideMountDropdown();
                ADDON.UI:UpdateMountList()
                ADDON.UI:UpdateMountDisplay()
            end
            MountJournal.MountDisplay.ModelScene:StartUnwrapAnimation(OnFinishedCallback);
        else
            C_MountJournal.SummonByID(mountID);
        end
    end
end
