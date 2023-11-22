local _, ADDON = ...

--region transliterate string
local translitCache = {}
local translitTable = {
    ["À"] = "A",
    ["Á"] = "A",
    ["Â"] = "A",
    ["Ã"] = "A",
    ["Ä"] = "A",
    ["Å"] = "A",
    ["Æ"] = "AE",
    ["Ç"] = "C",
    ["È"] = "E",
    ["É"] = "E",
    ["Ê"] = "E",
    ["Ë"] = "E",
    ["Ì"] = "I",
    ["Í"] = "I",
    ["Î"] = "I",
    ["Ï"] = "I",
    ["Ð"] = "D",
    ["Ñ"] = "N",
    ["Ò"] = "O",
    ["Ó"] = "O",
    ["Ô"] = "O",
    ["Õ"] = "O",
    ["Ö"] = "O",
    ["Ø"] = "O",
    ["Ù"] = "U",
    ["Ú"] = "U",
    ["Û"] = "U",
    ["Ü"] = "U",
    ["Ý"] = "Y",
    ["ß"] = "ss",
    ["à"] = "a",
    ["á"] = "a",
    ["â"] = "a",
    ["ã"] = "a",
    ["ä"] = "a",
    ["å"] = "a",
    ["æ"] = "ae",
    ["ç"] = "c",
    ["è"] = "e",
    ["é"] = "e",
    ["ê"] = "e",
    ["ë"] = "e",
    ["ì"] = "i",
    ["í"] = "i",
    ["î"] = "i",
    ["ï"] = "i",
    ["ñ"] = "n",
    ["ò"] = "o",
    ["ó"] = "o",
    ["ô"] = "o",
    ["õ"] = "o",
    ["ö"] = "o",
    ["ø"] = "o",
    ["ù"] = "u",
    ["ú"] = "u",
    ["û"] = "u",
    ["ü"] = "u",
    ["ý"] = "y",
    ["ÿ"] = "y",
}

local function TransliterateName(name, id)
    if translitCache[id] then
        if translitCache[id] == true then
            return name
        end

        return translitCache[id]
    end

    -- has latin-1 supplement
    if string.find(name, "\195", 1, true) then

        for i = 1, string.len(name) do
            local char = string.sub(name, i, i + 1)
            if translitTable[char] then
                local replaceChar = translitTable[char]
                if i == 1 then
                    name = replaceChar .. string.sub(name, i + 2)
                else
                    name = string.sub(name, 1, i - 1) .. replaceChar .. string.sub(name, i + 2)
                end
            end
        end

        translitCache[id] = name
    else
        translitCache[id] = true
    end

    return name
end
--endregion

local function CompareNames(nameA, idA, nameB, idB)
    return TransliterateName(nameA, idA) < TransliterateName(nameB, idB)
end

local RemappedTypes = {}
for category, values in pairs(ADDON.DB.Type) do
    for _, typeId in pairs(values.typeIDs or {}) do
        RemappedTypes[typeId] = category
    end
end
local TrackingIndex = {
    usage_count = 1,
    last_usage = 2,
    travel_duration = 3,
    travel_distance = 4,
    learned_date = 5,
}

local cache = {}
local setTimer = false
local function CacheMount(mountId)
    if cache[mountId] then
        return cache[mountId][1], cache[mountId][2], cache[mountId][3], cache[mountId][4], cache[mountId][5], cache[mountId][6]
    end

    if not setTimer then
        C_Timer.After(0.1, function()
            cache = {}
            setTimer = false
        end)
        setTimer = true
    end

    local name, _, _, _, isUsable, _, isFavorite, _, _, _, isCollected, _, isForDragonriding = ADDON.Api:GetMountInfoByID(mountId)
    local needsFanfare = isCollected and C_MountJournal.NeedsFanfare(mountId)

    cache[mountId] = { name, isUsable, isFavorite, isCollected, needsFanfare, isForDragonriding }

    return name, isUsable, isFavorite, isCollected, needsFanfare, isForDragonriding
end
local function CacheType(mountId)
    if not cache[mountId][6] then
        cache[mountId][6] = select(5, C_MountJournal.GetMountInfoExtraByID(mountId))
    end

    return cache[mountId][6]
end

local function CheckDescending(result, doNotDescend)
    if ADDON.settings.sort.descending and not doNotDescend then
        result = not result
    end

    return result
end

local function FallbackByName(mountIdA, mountIdB)
    local nameA = CacheMount(mountIdA)
    local nameB = CacheMount(mountIdB)
    return CompareNames(nameA, mountIdA, nameB, mountIdB)
end

local function SortByType(mountIdA, mountIdB)
    local mountTypeA = RemappedTypes[CacheType(mountIdA)] or nil
    local mountTypeB = RemappedTypes[CacheType(mountIdB)] or nil

    local result = false
    if mountTypeA == mountTypeB then
        return CheckDescending(FallbackByName(mountIdA, mountIdB), true)
    elseif mountTypeA == "dragonriding" then
        result = (mountTypeB ~= "flying")
    elseif mountTypeA == "flying" then
        result = (mountTypeB ~= "dragonriding")
    elseif mountTypeA == "ground" then
        result = (mountTypeB == "underwater")
    elseif mountTypeA == "underwater" then
        result = false
    end

    return CheckDescending(result)
end

local function SortByTracking(mountIdA, mountIdB)
    local sortBy = ADDON.settings.sort.by
    local result = false
    local valueA = select(TrackingIndex[sortBy], ADDON:GetMountStatistics(mountIdA)) or 0
    local valueB = select(TrackingIndex[sortBy], ADDON:GetMountStatistics(mountIdB)) or 0
    if valueA == valueB then
        return CheckDescending(FallbackByName(mountIdA, mountIdB), true)
    elseif sortBy == 'learned_date' or sortBy == 'last_usage' then
        result = valueA > valueB
    else
        result = valueA < valueB
    end

    return CheckDescending(result)
end

local LibMountsRarity
local function SortByRarity(mountIdA, mountIdB)
    LibMountsRarity = LibMountsRarity or LibStub("MountsRarity-2.0")
    local rarityA = LibMountsRarity:GetRarityByID(mountIdA)
    local rarityB = LibMountsRarity:GetRarityByID(mountIdB)
    if nil ~= rarityA and nil ~= rarityB and rarityA ~= rarityB then
        return CheckDescending(rarityA > rarityB)
    elseif nil ~= rarityA and nil == rarityB then
        return CheckDescending(true, true)
    elseif nil == rarityA and nil ~= rarityB then
        return CheckDescending(false, true)
    end

    return CheckDescending(FallbackByName(mountIdA, mountIdB), true)
end

function ADDON:SortHandler(mountA, mountB)
    local mountIdA, mountIdB = mountA.mountID, mountB.mountID
    if mountIdA == mountIdB then
        return false
    end

    local _, isUsableA, isFavoriteA, isCollectedA, needsFanfareA, isForDragonridingA = CacheMount(mountIdA)
    local _, isUsableB, isFavoriteB, isCollectedB, needsFanfareB, isForDragonridingB = CacheMount(mountIdB)

    if needsFanfareA ~= needsFanfareB then
        return needsFanfareA and not needsFanfareB
    end

    if ADDON.settings.sort.favoritesOnTop and isFavoriteA ~= isFavoriteB then
        return isFavoriteA and not isFavoriteB
    end
    if ADDON.settings.sort.unusableToBottom and isUsableA ~= isUsableB then
        return isUsableA and not isUsableB
    end
    if ADDON.settings.sort.unownedOnBottom and isCollectedA ~= isCollectedB then
        return isCollectedA and not isCollectedB
    end
    if ADDON.settings.sort.dragonridingOnTop and isForDragonridingA ~= isForDragonridingB then
        return isForDragonridingA and not isForDragonridingB
    end

    local sortBy = ADDON.settings.sort.by
    if sortBy == 'type' then
        return SortByType(mountIdA, mountIdB)
    elseif sortBy == 'expansion' then
        return CheckDescending(mountIdA < mountIdB)
    elseif sortBy == 'expansion' then
        return CheckDescending(mountIdA < mountIdB)
    elseif sortBy == 'rarity' then
        return SortByRarity(mountIdA, mountIdB)
    elseif TrackingIndex[sortBy] then
        return SortByTracking(mountIdA, mountIdB)
    else
        return CheckDescending(FallbackByName(mountIdA, mountIdB))
    end
end