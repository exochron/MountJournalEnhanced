local ADDON_NAME, ADDON = ...

ADDON.hooks = {}
local indexMap

local function SearchIsActive()
    local searchString = MountJournal.searchBox:GetText()
    if (not searchString or string.len(searchString) == 0) then
        return false
    end

    return true
end

--region C_MountJournal Hooks
function ADDON:MapIndex(index)
    -- index=0 => SummonRandomButton
    if (SearchIsActive() or index == 0) then
        return index
    end

    if nil == indexMap then
        self:UpdateIndexMap()
    end

    return indexMap[index]
end

local function C_MountJournal_GetNumDisplayedMounts()
    if SearchIsActive() then
        return ADDON.hooks["GetNumDisplayedMounts"]()
    end

    if nil == indexMap then
        ADDON:UpdateIndexMap()
    end

    return #indexMap
end

local function C_MountJournal_GetDisplayedMountInfo(index)
    local creatureName, spellId, icon, active, isUsable, sourceType, isFavorite, isFaction, faction, hideOnChar, isCollected, mountID, a, b, c, d, e, f, g, h
    local mappedIndex = ADDON:MapIndex(index)
    if nil ~= mappedIndex then
        creatureName, spellId, icon, active, isUsable, sourceType, isFavorite, isFaction, faction, hideOnChar, isCollected, mountID, a, b, c, d, e, f, g, h = ADDON.hooks["GetDisplayedMountInfo"](mappedIndex)
    end

    isUsable = isUsable and IsUsableSpell(spellId)

    return creatureName, spellId, icon, active, isUsable, sourceType, isFavorite, isFaction, faction, hideOnChar, isCollected, mountID, a, b, c, d, e, f, g, h
end

local function C_MountJournal_GetDisplayedMountInfoExtra(index)
    local _, _, _, _, _, _, _, _, _, _, _, mountId = C_MountJournal.GetDisplayedMountInfo(index)
    if (not mountId) then
        return nil
    end

    return C_MountJournal.GetMountInfoExtraByID(mountId)
end

local function C_MountJournal_GetDisplayedMountAllCreatureDisplayInfo(index)
    local mappedIndex = ADDON:MapIndex(index)
    if nil ~= mappedIndex then
        return ADDON.hooks["GetDisplayedMountAllCreatureDisplayInfo"](mappedIndex)
    end
end

local function CallHookedFunction(functionName, index, arg1, arg2)
    local mappedIndex = ADDON:MapIndex(index)
    if nil ~= mappedIndex then
        return ADDON.hooks[functionName](mappedIndex, arg1, arg2)
    end
end

local function RegisterMountJournalHooks()
    ADDON:Hook(C_MountJournal, "GetNumDisplayedMounts", C_MountJournal_GetNumDisplayedMounts)
    ADDON:Hook(C_MountJournal, "GetDisplayedMountInfo", C_MountJournal_GetDisplayedMountInfo)
    ADDON:Hook(C_MountJournal, "GetDisplayedMountInfoExtra", C_MountJournal_GetDisplayedMountInfoExtra)
    ADDON:Hook(C_MountJournal, "GetDisplayedMountAllCreatureDisplayInfo", C_MountJournal_GetDisplayedMountAllCreatureDisplayInfo)
    ADDON:Hook(C_MountJournal, "SetIsFavorite", function(index, isFavored)
        local result = CallHookedFunction("SetIsFavorite", index, isFavored)
        ADDON:UpdateIndexMap()
        return result
    end)
    ADDON:Hook(C_MountJournal, "GetIsFavorite", function(index)
        return CallHookedFunction("GetIsFavorite", index)
    end)
    ADDON:Hook(C_MountJournal, "Pickup", function(index)
        return CallHookedFunction("Pickup", index)
    end)
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

function ADDON:OnLogin()
    FireCallbacks(loginCallbacks)
end

function ADDON:LoadUI()

    PetJournal:HookScript("OnShow", function()
        if (not PetJournalPetCard.petID) then
            PetJournal_ShowPetCard(1)
        end
    end)

    RegisterMountJournalHooks()

    self:UpdateIndexMap()
    MountJournal_UpdateMountList()

    local frame = CreateFrame("frame");
    frame:RegisterEvent("ZONE_CHANGED")
    frame:RegisterEvent("ZONE_CHANGED_INDOORS")
    frame:RegisterEvent("MOUNT_JOURNAL_USABILITY_CHANGED")
    frame:RegisterEvent("MOUNT_JOURNAL_SEARCH_UPDATED")
    frame:SetScript("OnEvent", function(sender, ...)
        if CollectionsJournal:IsShown() then
            ADDON:UpdateIndexMap(true)
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

function ADDON:UpdateIndexMap(calledFromEvent)
    if nil == indexMap or not SearchIsActive() then
        local map = {}
        for i = 1, self.hooks["GetNumDisplayedMounts"]() do
            if ADDON:FilterMount(i) then
                map[#map + 1] = i
            end
        end

        if calledFromEvent and nil ~= indexMap and #map == #indexMap then
            return
        end

        if ADDON.settings.ui.enableSortOptions then
            table.sort(map, function(a, b)

                if a == b then
                    return false
                end

                local result = false
                local nameA, _, _, _, _, _, isFavoriteA, _, _, _, isCollectedA, mountIdA = ADDON.hooks["GetDisplayedMountInfo"](a)
                local nameB, _, _, _, _, _, isFavoriteB, _, _, _, isCollectedB, mountIdB = ADDON.hooks["GetDisplayedMountInfo"](b)

                if ADDON.settings.sort.favoritesOnTop and isFavoriteA ~= isFavoriteB then
                    return isFavoriteA and not isFavoriteB
                end
                if ADDON.settings.sort.unownedOnBottom and isCollectedA ~= isCollectedB then
                    return isCollectedA and not isCollectedB
                end

                if ADDON.settings.sort.by == 'name' then
                    result = strcmputf8i(nameA, nameB) < 0
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

        indexMap = map
    end
end

function ADDON:Hook(obj, name, func)
    local hook = self.hooks[name]
    if (hook ~= nil) then
        return false
    end

    if (obj == nil) then
        self.hooks[name] = _G[name]
        _G[name] = func
    else
        self.hooks[name] = obj[name]
        obj[name] = func
    end

    return true
end

function ADDON:Unhook(obj, name)
    local hook = self.hooks[name]
    if (hook == nil) then
        return false
    end

    if (obj == nil) then
        _G[name] = hook
    else
        obj[name] = hook
    end
    self.hooks[name] = nil

    return true
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
        ADDON:OnLogin()
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
        ADDON:LoadUI()
        ADDON.initialized = true
    end
end)