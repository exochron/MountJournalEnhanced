local ADDON_NAME, ADDON = ...

local FamilyDB = ADDON.DB.Family
local SourceDB = ADDON.DB.Source
local ExpansionDB = ADDON.DB.Expansion
local TypeDB = ADDON.DB.Type
local TradableDB = ADDON.DB.Tradable

local function FilterHiddenMounts(spellId)
    return ADDON.settings.filter.hidden or not ADDON.settings.hiddenMounts[spellId]
end

local function FilterFavoriteMounts(isFavorite)
    return isFavorite or not ADDON.settings.filter.onlyFavorites or not ADDON.settings.filter.collected
end

local function FilterUsableMounts(spellId, isUsable)
    return not ADDON.settings.filter.onlyUsable or (isUsable and IsUsableSpell(spellId))
end

local function FilterTradableMounts(spellId)
    return not ADDON.settings.filter.onlyTradable or TradableDB[spellId]
end

local function FilterCollectedMounts(collected)
    return (ADDON.settings.filter.collected and collected) or (ADDON.settings.filter.notCollected and not collected)
end

local function CheckAllSettings(settings)
    local allDisabled = true
    local allEnabled = true
    for _, value in pairs(settings) do
        if type(value) == "table" then
            local subResult = CheckAllSettings(value)
            if (subResult ~= false) then
                allDisabled = false
            elseif (subResult ~= true) then
                allEnabled = false
            end
        elseif (value) then
            allDisabled = false
        else
            allEnabled = false
        end

        if allEnabled == false and false == allDisabled then
            break
        end
    end

    if allEnabled then
        return true
    elseif allDisabled then
        return false
    end

    return nil
end

local function CheckMountInList(settings, sourceData, spellId)
    local isInList = false

    for setting, value in pairs(settings) do
        if type(value) == "table" then
            local subResult = CheckMountInList(value, sourceData[setting], spellId)
            if subResult then
                return true
            elseif subResult == false then
                isInList = true
            end
        elseif sourceData[setting] and sourceData[setting][spellId] then
            if (value) then
                return true
            else
                isInList = true
            end
        end
    end

    if isInList then
        return false
    end

    return nil
end

function ADDON:FilterMountsBySource(spellId, sourceType)

    local settingsResult = CheckAllSettings(self.settings.filter.source)
    if settingsResult then
        return true
    end

    local mountResult = CheckMountInList(self.settings.filter.source, SourceDB, spellId)
    if mountResult ~= nil then
        return mountResult
    end

    for source, value in pairs(self.settings.filter.source) do
        if SourceDB[source] and SourceDB[source]["sourceType"]
                and tContains(SourceDB[source]["sourceType"], sourceType) then
            return value
        end
    end

    return true
end

local function FilterMountsByFaction(isFaction, faction)
    return (ADDON.settings.filter.faction.noFaction and not isFaction
            or ADDON.settings.filter.faction.alliance and faction == 1
            or ADDON.settings.filter.faction.horde and faction == 0)
end

function ADDON:FilterMountsByFamily(spellId)

    local settingsResult = CheckAllSettings(self.settings.filter.family)
    if settingsResult then
        return true
    end

    local mountResult = CheckMountInList(self.settings.filter.family, FamilyDB, spellId)
    if mountResult then
        return true
    end

    return mountResult == nil
end

function ADDON:FilterMountsByExpansion(spellId)

    local settingsResult = CheckAllSettings(self.settings.filter.expansion)
    if settingsResult then
        return true
    end

    local mountResult = CheckMountInList(self.settings.filter.expansion, ExpansionDB, spellId)
    if mountResult ~= nil then
        return mountResult
    end

    for expansion, value in pairs(self.settings.filter.expansion) do
        if ExpansionDB[expansion] and
                ExpansionDB[expansion]["minID"] <= spellId and
                spellId <= ExpansionDB[expansion]["maxID"] then
            return value
        end
    end

    return false
end

function ADDON:FilterMountsByType(spellId, mountID)
    local settingsResult = CheckAllSettings(self.settings.filter.mountType)
    if settingsResult then
        return true
    end

    local mountResult = CheckMountInList(self.settings.filter.mountType, TypeDB, spellId)
    if mountResult == true then
        return true
    end

    local _, _, _, isSelfMount, mountType = C_MountJournal.GetMountInfoExtraByID(mountID)

    if (self.settings.filter.mountType.transform and isSelfMount) then
        return true
    end

    local result
    for category, value in pairs(self.settings.filter.mountType) do
        if TypeDB[category] and
                TypeDB[category].typeIDs and
                tContains(TypeDB[category].typeIDs, mountType) then
            result = result or value
        end
    end

    if result == nil then
        result = true
        if mountResult ~= nil then
            result = mountResult
        end
    end

    return result
end

function ADDON:FilterMount(index)

    local creatureName, spellId, icon, active, isUsable, sourceType, isFavorite, isFaction, faction, isFiltered, isCollected, mountId = ADDON.hooks["GetDisplayedMountInfo"](index)

    if (FilterHiddenMounts(spellId) and
            FilterFavoriteMounts(isFavorite) and
            FilterUsableMounts(spellId, isUsable) and
            FilterTradableMounts(spellId) and
            FilterCollectedMounts(isCollected) and
            FilterMountsByFaction(isFaction, faction) and
            self:FilterMountsBySource(spellId, sourceType) and
            self:FilterMountsByType(spellId, mountId) and
            self:FilterMountsByFamily(spellId) and
            self:FilterMountsByExpansion(spellId)) then
        return true
    end

    return false
end