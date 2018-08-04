local ADDON_NAME, ADDON = ...

ADDON.hooks = {}
ADDON.indexMap = {}

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

    if (not self.indexMap) then
        self:UpdateIndexMap()
    end

    return self.indexMap[index]
end

local function C_MountJournal_GetNumDisplayedMounts()
    if SearchIsActive() then
        return ADDON.hooks["GetNumDisplayedMounts"]()
    end

    if (not ADDON.indexMap) then
        ADDON:UpdateIndexMap()
    end

    return #ADDON.indexMap
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

local function C_MountJournal_SetIsFavorite(oldIndex, isFavorited)
    local mappedOldIndex = ADDON:MapIndex(oldIndex)
    local _, searchSpellId = ADDON.hooks["GetDisplayedMountInfo"](mappedOldIndex)
    local result = ADDON.hooks["SetIsFavorite"](mappedOldIndex, isFavorited)

    table.remove(ADDON.indexMap, oldIndex)

    local beginnLoop, endLoop = 1, mappedOldIndex
    if not isFavorited then
        beginnLoop = mappedOldIndex
        endLoop = ADDON.hooks["GetNumDisplayedMounts"]()
    end

    local newPosition
    for i = beginnLoop, endLoop do
        local _, spellId = ADDON.hooks["GetDisplayedMountInfo"](i)
        if searchSpellId == spellId then
            newPosition = i
            break
        end
    end

    if isFavorited then
        for i = 1, oldIndex - 1 do
            if ADDON.indexMap[i] >= newPosition then
                ADDON.indexMap[i] = ADDON.indexMap[i] + 1
            end
        end

        table.insert(ADDON.indexMap, newPosition)
        table.sort(ADDON.indexMap)
    elseif ADDON.settings.filter.onlyFavorites then
        for i = oldIndex, #ADDON.indexMap do
            ADDON.indexMap[i] = ADDON.indexMap[i] - 1
        end
    else
        for i = oldIndex, #ADDON.indexMap do
            local position = ADDON.indexMap[i]
            if position <= newPosition then
                ADDON.indexMap[i] = position - 1
            else
                break
            end
        end

        table.insert(ADDON.indexMap, newPosition)
        table.sort(ADDON.indexMap)
    end

    return result
end

local function RegisterMountJournalHooks()
    ADDON:Hook(C_MountJournal, "GetNumDisplayedMounts", C_MountJournal_GetNumDisplayedMounts)
    ADDON:Hook(C_MountJournal, "GetDisplayedMountInfo", C_MountJournal_GetDisplayedMountInfo)
    ADDON:Hook(C_MountJournal, "GetDisplayedMountInfoExtra", C_MountJournal_GetDisplayedMountInfoExtra)
    ADDON:Hook(C_MountJournal, "SetIsFavorite", C_MountJournal_SetIsFavorite)
    ADDON:Hook(C_MountJournal, "GetIsFavorite", function(index)
        local mappedIndex = ADDON:MapIndex(index)
        if nil~= mappedIndex then
            return ADDON.hooks["GetIsFavorite"](mappedIndex)
        end
    end)
    ADDON:Hook(C_MountJournal, "Pickup", function(index)
        local mappedIndex = ADDON:MapIndex(index)
        if nil~= mappedIndex then
            return ADDON.hooks["Pickup"](mappedIndex)
        end
    end)
end

--endregion Hooks

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
    frame:RegisterEvent("SPELL_UPDATE_USABLE")
    frame:RegisterEvent("MOUNT_JOURNAL_USABILITY_CHANGED")
    frame:SetScript("OnEvent", function(sender, ...)
        if (CollectionsJournal:IsShown()) then
            ADDON:UpdateIndexMap()
            MountJournal_UpdateMountList()
        end
    end);
end

function ADDON:UpdateIndexMap()
    local indexMap = {}

    if not SearchIsActive() then
        for i = 1, self.hooks["GetNumDisplayedMounts"]() do
            if (ADDON:FilterMount(i)) then
                indexMap[#indexMap + 1] = i
            end
        end
    end

    self.indexMap = indexMap
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

local function Load()
    if not ADDON.initialized then
        ADDON.initialized = true
        ADDON:LoadSettings()
        ADDON:LoadUI()
        if ADDON.settings.debugMode then
            ADDON:RunDebugTest()
        end
    end
end

-- reset default filter settings
C_MountJournal.SetCollectedFilterSetting(LE_MOUNT_JOURNAL_FILTER_COLLECTED, true)
C_MountJournal.SetCollectedFilterSetting(LE_MOUNT_JOURNAL_FILTER_NOT_COLLECTED, true)
C_MountJournal.SetCollectedFilterSetting(LE_MOUNT_JOURNAL_FILTER_UNUSABLE, true)
C_MountJournal.SetAllSourceFilters(true)
C_MountJournal.SetSearch('')

hooksecurefunc("LoadAddOn", function(name)
    if (name == 'Blizzard_Collections') then
        Load()
    end
end)