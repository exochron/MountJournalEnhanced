local ADDON_NAME, ADDON = ...

ADDON.hooks = {}
local indexMap -- initialize with nil, so we know if it's not ready yet and not just empty

local function SearchIsActive()
    local searchString = MountJournal.searchBox:GetText()
    if not searchString or string.len(searchString) == 0 then
        return false
    end

    return true
end

--region C_MountJournal Hooks

-- maps index to mountID
local function MapIndex(index)
    -- index=0 => SummonRandomButton
    if index == 0 then
        return 0
    end

    if SearchIsActive() then
        return select(12, ADDON.hooks["GetDisplayedMountInfo"](index))
    end

    if nil == indexMap then
        ADDON:UpdateIndex()
    end

    return indexMap[index]
end

local function C_MountJournal_GetNumDisplayedMounts()
    if SearchIsActive() then
        return ADDON.hooks["GetNumDisplayedMounts"]()
    end

    if nil == indexMap then
        ADDON:UpdateIndex()
    end

    return #indexMap
end

local function C_MountJournal_GetDisplayedMountInfo(index)
    local creatureName, spellId, icon, active, isUsable, sourceType, isFavorite, isFaction, faction, hideOnChar, isCollected, mountID, a, b, c, d, e, f, g, h
    local mappedMountId = MapIndex(index)
    if mappedMountId > 0 then
        creatureName, spellId, icon, active, isUsable, sourceType, isFavorite, isFaction, faction, hideOnChar, isCollected, mountID, a, b, c, d, e, f, g, h = C_MountJournal.GetMountInfoByID(mappedMountId)
    else
        creatureName, spellId, icon, active, isUsable, sourceType, isFavorite, isFaction, faction, hideOnChar, isCollected, mountID, a, b, c, d, e, f, g, h = ADDON.hooks["GetDisplayedMountInfo"](index)
    end

    isUsable = isUsable and IsUsableSpell(spellId)

    return creatureName, spellId, icon, active, isUsable, sourceType, isFavorite, isFaction, faction, hideOnChar, isCollected, mountID, a, b, c, d, e, f, g, h
end

local function Hook(obj, name, func)
    ADDON.hooks[name] = obj[name]
    obj[name] = func
end

local function HookWithMountId(originalFuncName, mappedFuncName)
    Hook(C_MountJournal, originalFuncName, function(index, arg1, arg2)
        local mountId = MapIndex(index)
        if mountId > 0 then
            return C_MountJournal[mappedFuncName](mountId, arg1, arg2)
        end
    end)
end
local function HookWithMappedIndex(functionName)
    Hook(C_MountJournal, functionName, function(index, arg1, arg2)
        local mountId = MapIndex(index)
        if mountId > 0 then
            local mappedIndex = tIndexOf(indexMap, mountId)
            return ADDON.hooks[functionName](mappedIndex, arg1, arg2)
        end
    end)
end

local function RegisterMountJournalHooks()
    Hook(C_MountJournal, "GetNumDisplayedMounts", C_MountJournal_GetNumDisplayedMounts)
    Hook(C_MountJournal, "GetDisplayedMountInfo", C_MountJournal_GetDisplayedMountInfo)
    HookWithMountId("GetDisplayedMountInfoExtra", "GetMountInfoExtraByID")
    HookWithMountId("GetDisplayedMountAllCreatureDisplayInfo", "GetMountAllCreatureDisplayInfoByID")
    HookWithMappedIndex("SetIsFavorite")
    hooksecurefunc(C_MountJournal, "SetIsFavorite", ADDON.UpdateIndex)
    HookWithMappedIndex("GetIsFavorite")
    HookWithMappedIndex("Pickup")
end

--endregion Hooks

--region callbacks
local loginCallbacks, loadUICallbacks = {}, {}
function ADDON:RegisterLoginCallback(func)
    table.insert(loginCallbacks, func)
end
function ADDON:RegisterLoadUICallback(func)
    table.insert(loadUICallbacks, func)
end
local function FireCallbacks(callbacks)
    for _, callback in pairs(callbacks) do
        callback()
    end
end
--endregion

local function LoadUI()
    RegisterMountJournalHooks()

    ADDON:UpdateIndex()
    MountJournal_UpdateMountList()

    local frame = CreateFrame("frame");
    frame:RegisterEvent("ZONE_CHANGED")
    frame:RegisterEvent("ZONE_CHANGED_INDOORS")
    frame:RegisterEvent("MOUNT_JOURNAL_USABILITY_CHANGED")
    frame:RegisterEvent("MOUNT_JOURNAL_SEARCH_UPDATED")
    frame:SetScript("OnEvent", function(sender, ...)
        if CollectionsJournal:IsShown() then
            ADDON:UpdateIndex(true)
            MountJournal_UpdateMountList()
        end
    end);

    FireCallbacks(loadUICallbacks)
end

local function mapMountType(mountId)
    local _, _, _, _, mountType = C_MountJournal.GetMountInfoExtraByID(mountId)
    for category, values in pairs(ADDON.DB.Type) do
        if values.typeIDs and tContains(values.typeIDs, mountType) then
            return category
        end
    end
end

function ADDON:UpdateIndex(calledFromEvent)
    local map = {}

    if not SearchIsActive() then
        for i = 1, self.hooks["GetNumDisplayedMounts"]() do
            local mountId = select(12, ADDON.hooks["GetDisplayedMountInfo"](i))
            if ADDON:FilterMount(mountId) then
                map[#map + 1] = mountId
            end
        end

        if calledFromEvent and nil ~= indexMap and #map == #indexMap then
            return
        end

        if ADDON.settings.ui.enableSortOptions then
            table.sort(map, function(mountIdA, mountIdB)

                if mountIdA == mountIdB then
                    return false
                end

                local result = false
                local nameA, _, _, _, _, _, isFavoriteA, _, _, _, isCollectedA = C_MountJournal.GetMountInfoByID(mountIdA)
                local nameB, _, _, _, _, _, isFavoriteB, _, _, _, isCollectedB = C_MountJournal.GetMountInfoByID(mountIdB)

                if ADDON.settings.sort.favoritesOnTop and isFavoriteA ~= isFavoriteB then
                    return isFavoriteA and not isFavoriteB
                end
                if ADDON.settings.sort.unownedOnBottom and isCollectedA ~= isCollectedB then
                    return isCollectedA and not isCollectedB
                end

                if ADDON.settings.sort.by == 'name' then
                    result = strcmputf8i(nameA, nameB) < 0 -- still not comparing Umlauts right :(
                elseif ADDON.settings.sort.by == 'type' then
                    local mountTypeA = mapMountType(mountIdA)
                    local mountTypeB = mapMountType(mountIdB)

                    if mountTypeA == mountTypeB then
                        result = strcmputf8i(nameA, nameB) < 0
                    elseif mountTypeA == "flying" then
                        result = true
                    elseif mountTypeA == "ground" then
                        result = (mountTypeB == "underwater")
                    elseif mountTypeA == "underwater" then
                        result = false
                    end

                elseif ADDON.settings.sort.by == 'expansion' then
                    result = mountIdA < mountIdB
                end

                if ADDON.settings.sort.descending then
                    result = not result
                end

                return result
            end)
        end
    end

    indexMap = map
end

local function ResetIngameFilter()
    -- reset default filter settings
    C_MountJournal.SetCollectedFilterSetting(LE_MOUNT_JOURNAL_FILTER_COLLECTED, true)
    C_MountJournal.SetCollectedFilterSetting(LE_MOUNT_JOURNAL_FILTER_NOT_COLLECTED, true)
    C_MountJournal.SetCollectedFilterSetting(LE_MOUNT_JOURNAL_FILTER_UNUSABLE, true)
    C_MountJournal.SetAllSourceFilters(true)
    C_MountJournal.SetSearch("")
end
ResetIngameFilter()

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function(self, event, arg1)
    local doInit = false
    if event == "PLAYER_LOGIN" then
        ResetIngameFilter()
        FireCallbacks(loginCallbacks)
        if MountJournal then
            doInit = true
        end
    elseif event == "ADDON_LOADED" and arg1 == "Blizzard_Collections" then
        if not ADDON.initialized and ADDON.settings then
            doInit = true
        end
    end

    if doInit then
        frame:UnregisterEvent("ADDON_LOADED")
        LoadUI()
        ADDON.initialized = true
    end
end)