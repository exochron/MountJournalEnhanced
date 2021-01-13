local ADDON_NAME, ADDON = ...

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

local function CompareNames(nameA, idA, nameB, idB)
    return TransliterateName(nameA, idA) < TransliterateName(nameB, idB)
end

local function mapMountType(mountId)
    local _, _, _, _, mountType = C_MountJournal.GetMountInfoExtraByID(mountId)
    for category, values in pairs(ADDON.DB.Type) do
        if values.typeIDs and tContains(values.typeIDs, mountType) then
            return category
        end
    end
end

function ADDON:SortMounts(ids)
    if ADDON.settings.ui.enableSortOptions then
        table.sort(ids, function(dataA, dataB)
            local mountIdA = dataA[1]
            local mountIdB = dataB[1]

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
                result = CompareNames(nameA, mountIdA, nameB, mountIdB)
            elseif ADDON.settings.sort.by == 'type' then
                local mountTypeA = mapMountType(mountIdA)
                local mountTypeB = mapMountType(mountIdB)

                if mountTypeA == mountTypeB then
                    result = CompareNames(nameA, mountIdA, nameB, mountIdB)
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

    return ids
end