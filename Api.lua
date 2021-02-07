local _, ADDON = ...

ADDON.Api = {}

local mountIdToOriginalIndex = {}
local orderedMountIds -- initialize with nil, so we know if it's not ready yet and not just empty

local function collectMountIds()
    ADDON:ResetIngameFilter()

    local list = {}
    for _, mountId in ipairs(C_MountJournal.GetMountIDs()) do
        list[mountId] = false
    end

    local count = C_MountJournal.GetNumDisplayedMounts()
    for i = 1, count do
        local mountId = select(12, C_MountJournal.GetDisplayedMountInfo(i))
        list[mountId] = i
    end

    mountIdToOriginalIndex = list
end

local function OwnIndexToMountId(index)
    -- index=0 => SummonRandomButton
    if index == 0 then
        return index
    end

    return orderedMountIds[index] or nil
end
local function MountIdToOriginalIndex(mountId)
    local index = mountIdToOriginalIndex[mountId] or nil

    if index then
        local displayedMountId = select(12, C_MountJournal.GetDisplayedMountInfo(index))
        if displayedMountId ~= mountId then
            collectMountIds()
        end
    end

    return index
end

function ADDON.Api:GetNumDisplayedMounts()
    if nil == orderedMountIds then
        ADDON.Api:UpdateIndex()
    end

    return #orderedMountIds
end

function ADDON.Api:GetMountInfoByID(mountId)
    local creatureName, spellId, icon, active, isUsable, sourceType, isFavorite, isFaction, faction, hideOnChar, isCollected, mountID, a, b, c, d, e, f, g, h = C_MountJournal.GetMountInfoByID(mountId)
    isUsable = isUsable and IsUsableSpell(spellId)

    return creatureName, spellId, icon, active, isUsable, sourceType, isFavorite, isFaction, faction, hideOnChar, isCollected, mountID, a, b, c, d, e, f, g, h
end
function ADDON.Api:GetDisplayedMountInfo(index)
    if nil == orderedMountIds then
        ADDON.Api:UpdateIndex()
    end

    local mappedMountId = OwnIndexToMountId(index)
    if mappedMountId then
        return ADDON.Api:GetMountInfoByID(mappedMountId)
    end
end
function ADDON.Api:PickupByID(mountId, ...)
    local index = MountIdToOriginalIndex(mountId)
    if index then
        return C_MountJournal.Pickup(index, ...)
    end
end
function ADDON.Api:GetIsFavoriteByID(mountId, ...)
    local index = MountIdToOriginalIndex(mountId)
    if index then
        return C_MountJournal.GetIsFavorite(index, ...)
    end
end
function ADDON.Api:SetIsFavoriteByID(mountId, ...)
    local index = MountIdToOriginalIndex(mountId)
    if index then
        C_MountJournal.SetIsFavorite(index, ...)
        collectMountIds()
    end
end

function ADDON.Api:UpdateIndex(calledFromEvent)
    local list = ADDON:FilterMounts()
    --ADDON.Debug:ProfileFunction("filter", ADDON.FilterMounts, true)

    if true ~= calledFromEvent or nil == orderedMountIds or #list ~= #orderedMountIds then
        orderedMountIds = ADDON:SortMounts(list)
        EventRegistry:TriggerEvent("MountJournal.OnFilterUpdate")
        --ADDON.Debug:ProfileFunction("sort", ADDON.SortMounts, true)
    end
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
        if (active) then
            C_MountJournal.Dismiss();
        elseif (C_MountJournal.NeedsFanfare(mountID)) then
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

ADDON:RegisterLoginCallback(function()
    collectMountIds()
end)
