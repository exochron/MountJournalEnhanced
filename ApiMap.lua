local ADDON_NAME, ADDON = ...

ADDON.Api = {}

local indexMap -- initialize with nil, so we know if it's not ready yet and not just empty

local function MapIndex(index, toMountId)
    -- index=0 => SummonRandomButton
    if index == 0 then
        return index
    end

    return indexMap[index] and indexMap[index][toMountId and 1 or 2] or nil
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

    local mappedMountId = MapIndex(index, true)
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

    local mountId = MapIndex(index, true)
    if mountId then
        return C_MountJournal.GetMountInfoExtraByID(mountId, ...)
    end
end
function ADDON.Api.GetDisplayedMountAllCreatureDisplayInfo(index, ...)
    if nil == indexMap then
        ADDON:UpdateIndex()
    end

    local mountId = MapIndex(index, true)
    if mountId then
        return C_MountJournal.GetMountAllCreatureDisplayInfoByID(mountId, ...)
    end
end
function ADDON.Api.Pickup(index, ...)
    if nil == indexMap then
        ADDON:UpdateIndex()
    end

    index = MapIndex(index, false)
    if index then
        return C_MountJournal.Pickup(index, ...)
    end
end
function ADDON.Api.GetIsFavorite(index, ...)
    if nil == indexMap then
        ADDON:UpdateIndex()
    end

    index = MapIndex(index, false)
    if index then
        return C_MountJournal.GetIsFavorite(index, ...)
    end
end
function ADDON.Api.SetIsFavorite(index, ...)
    if nil == indexMap then
        ADDON:UpdateIndex()
    end

    index = MapIndex(index, false)
    if index then
        return C_MountJournal.SetIsFavorite(index, ...)
    end
end


function ADDON:UpdateIndex(calledFromEvent)
    local map = {}

    local searchString = MountJournal.searchBox:GetText() or ""
    if searchString ~= "" then
        searchString = searchString:lower()
    end

    for _, mountId in ipairs(C_MountJournal.GetMountIDs()) do
        if ADDON:FilterMount(mountId, searchString) then
            map[#map + 1] = { mountId }
        end
    end

    if calledFromEvent and nil ~= indexMap and #map == #indexMap then
        return
    end

    indexMap = ADDON:SortMounts(map)
end