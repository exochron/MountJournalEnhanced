local ADDON_NAME, ADDON = ...

local FamilyDB = ADDON.DB.Family
local SourceDB = ADDON.DB.Source
local ExpansionDB = ADDON.DB.Expansion
local TypeDB = ADDON.DB.Type
local TradableDB = ADDON.DB.Tradable
local IgnoredDB = ADDON.DB.Ignored

local function FilterByName(searchString, name, mountId)
    name = name:lower()
    local pos = strfind(name, searchString, 1, true)
    local result = pos ~= nil

    if result == false and ADDON.settings.searchInDescription then
        local _, description, sourceText = C_MountJournal.GetMountInfoExtraByID(mountId)
        description = description:lower()
        pos = strfind(description, searchString, 1, true)
        result = pos ~= nil

        if result == false then
            sourceText = sourceText:lower()
            pos = strfind(sourceText, searchString, 1, true)
            result = pos ~= nil
        end
    end

    return result
end

local function FilterUserHiddenMounts(spellId)
    return ADDON.settings.filter.hidden or not ADDON.settings.hiddenMounts[spellId]
end
local function FilterIngameHiddenMounts(shouldHideOnChar, mountId)
    return not shouldHideOnChar or (ADDON.settings.filter.hiddenIngame and not IgnoredDB[mountId])
end

local function FilterFavoriteMounts(isFavorite)
    return isFavorite or not ADDON.settings.filter.onlyFavorites or not ADDON.settings.filter.collected
end

local function FilterUsableMounts(isUsable)
    return not ADDON.settings.filter.onlyUsable or isUsable
end

local function FilterTradableMounts(mountId)
    return not ADDON.settings.filter.onlyTradable or TradableDB[mountId]
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

local function prepareSettings(settings, sourceData)

    local result = {}
    for key, sourceList in pairs(sourceData) do
        if settings[key] ~= nil then

            if type(settings[key]) == "table" then
                for subId, subValue in pairs(prepareSettings(settings[key], sourceData[key])) do
                    if not result[subId] then -- if it was somewhere true than keep it true.
                        result[subId] = subValue
                    end
                end
            else
                for id, _ in pairs(sourceList) do
                    if not result[id] then
                        result[id] = settings[key]
                    end
                end
            end
        end
    end

    return result
end

local function FilterByFaction(isFaction, faction)
    return (ADDON.settings.filter.faction.noFaction and not isFaction)
            or (ADDON.settings.filter.faction.alliance and faction == 1)
            or (ADDON.settings.filter.faction.horde and faction == 0)
end

local function FilterBySource(spellId, sourceType, preparedSettings)
    if preparedSettings[spellId] ~= nil then
        return preparedSettings[spellId]
    end

    for source, value in pairs(ADDON.settings.filter.source) do
        if SourceDB[source] and SourceDB[source]["sourceType"]
                and tContains(SourceDB[source]["sourceType"], sourceType) then
            return value
        end
    end

    return true
end

local function FilterByFamily(mountId, preparedSettings)
    if preparedSettings[mountId] ~= nil then
        return preparedSettings[mountId]
    end

    return true
end

local function FilterByExpansion(spellId, preparedSettings)
    if preparedSettings[spellId] ~= nil then
        return preparedSettings[spellId]
    end

    for expansion, value in pairs(ADDON.settings.filter.expansion) do
        if ExpansionDB[expansion] and
                ExpansionDB[expansion]["minID"] <= spellId and
                spellId <= ExpansionDB[expansion]["maxID"] then
            return value
        end
    end

    return false
end

local function FilterByType(spellId, mountID, preparedSettings)
    if preparedSettings[spellId] then
        return true
    end

    local _, _, _, isSelfMount, mountType = C_MountJournal.GetMountInfoExtraByID(mountID)

    if (ADDON.settings.filter.mountType.transform and isSelfMount) then
        return true
    end

    local result
    for category, value in pairs(ADDON.settings.filter.mountType) do
        if TypeDB[category] and
                TypeDB[category].typeIDs and
                tContains(TypeDB[category].typeIDs, mountType) then
            result = result or value
        end
    end

    if result == nil then
        result = true
        if preparedSettings[spellId] ~= nil then
            result = preparedSettings[spellId]
        end
    end

    return result
end

function ADDON:FilterMounts()
    local result = {}
    local ids = C_MountJournal.GetMountIDs()

    local searchText = MountJournal and MountJournal.searchBox:GetText() or ""
    if searchText ~= "" then
        searchText = searchText:lower()

        for _, mountId in ipairs(ids) do
            local creatureName, _, _, _, _, _, _, _, _, shouldHideOnChar = ADDON.Api:GetMountInfoByID(mountId)
            if FilterIngameHiddenMounts(shouldHideOnChar, mountId) and FilterByName(searchText, creatureName, mountId) then
                result[#result + 1] = mountId
            end
        end
    else
        local allSettingsSource, preparedSource = CheckAllSettings(ADDON.settings.filter.source)
        if not preparedSource then
            preparedSource = prepareSettings(ADDON.settings.filter.source, SourceDB)
        end

        local allSettingsType, preparedTypes = CheckAllSettings(ADDON.settings.filter.mountType)
        if not allSettingsType then
            preparedTypes = prepareSettings(ADDON.settings.filter.mountType, TypeDB)
        end

        local allSettingsFamily, preparedFamily = CheckAllSettings(ADDON.settings.filter.family)
        if not allSettingsFamily then
            preparedFamily = prepareSettings(ADDON.settings.filter.family, FamilyDB)
        end

        local allSettingsExpansion, preparedExpansion = CheckAllSettings(ADDON.settings.filter.expansion)
        if not allSettingsExpansion then
            preparedExpansion = prepareSettings(ADDON.settings.filter.expansion, ExpansionDB)
        end

        for _, mountId in ipairs(ids) do
            local _, spellId, _, _, isUsable, sourceType, isFavorite, isFaction, faction, shouldHideOnChar, isCollected = ADDON.Api:GetMountInfoByID(mountId)
            if FilterUserHiddenMounts(spellId)
                    and FilterIngameHiddenMounts(shouldHideOnChar, mountId)
                    and FilterFavoriteMounts(isFavorite)
                    and FilterUsableMounts(isUsable)
                    and FilterTradableMounts(mountId)
                    and FilterCollectedMounts(isCollected)
                    and FilterByFaction(isFaction, faction)
                    and (allSettingsSource or FilterBySource(spellId, sourceType, preparedSource))
                    and (allSettingsType or FilterByType(spellId, mountId, preparedTypes))
                    and (allSettingsFamily or FilterByFamily(mountId, preparedFamily))
                    and (allSettingsExpansion or FilterByExpansion(spellId, preparedExpansion))
            then
                result[#result + 1] = mountId
            end
        end
    end

    return result
end