local _, ADDON = ...

local function print(...)
    _G.print("[MJE]", ...)
end

ADDON.Debug = {}

local function runFilterTest(testName)
    ADDON:ResetFilterSettings()
    for key, value in pairs(ADDON.settings.filter[testName]) do
        if type(value) == "table" then
            for subKey, _ in pairs(value) do
                ADDON.settings.filter[testName][key][subKey] = false
            end
        else
            ADDON.settings.filter[testName][key] = false
        end
    end
    ADDON.settings.filter.hiddenIngame = true
    for _, mountId in ipairs(ADDON:FilterMounts()) do
        local name, spellID, _, _, _, sourceType = C_MountJournal.GetMountInfoByID(mountId)
        local _, _, _, _, mountType = C_MountJournal.GetMountInfoExtraByID(mountId)
        print("No " .. testName .. " info for mount: " .. name .. " (spell=" .. spellID .. ", ID=" .. mountId .. ", source=" .. sourceType .. ", type=" .. mountType .. ") ")
    end
end

local function checkDBForOldMountIds(tbl, index)
    for mountId, value in pairs(tbl) do
        if true ~= value and "table" == type(value) then
            checkDBForOldMountIds(value, index)
        elseif mountId == 1 then
            break -- just a regular list
        elseif "number" == type(mountId) then
            local name = C_MountJournal.GetMountInfoByID(mountId)
            if not name then
                print(index .. ":", "old entry for mount: " .. mountId)
            end
        end
    end
end

local function searchRetiredMountsInCurrentSources()
    for spellId, _ in pairs(ADDON.DB.Source.Unavailable) do
        for sourceKey, sourceList in pairs(ADDON.DB.Source) do
            if sourceKey ~= "Unavailable" and sourceList[spellId] ~= nil then
                print(sourceKey..": found retired mount: "..spellId)
            end
        end
    end
end

local function testDatabase()
    local filterSettingsBackup = CopyTable(ADDON.settings.filter)

    runFilterTest("source")
    runFilterTest("mountType")
    runFilterTest("faction")
    runFilterTest("family")
    runFilterTest("expansion")

    ADDON.settings.filter = CopyTable(filterSettingsBackup)
    if ADDON.settings.personalFilter then
        MJEPersonalSettings.filter = ADDON.settings.filter
    else
        MJEGlobalSettings.filter = ADDON.settings.filter
    end

    if ADDON.isRetail then
        checkDBForOldMountIds(ADDON.DB.FeatsOfStrength, "FeatsOfStrength")
        checkDBForOldMountIds(ADDON.DB.Expansion, "Expansion")
        checkDBForOldMountIds(ADDON.DB.Type, "Type")
        checkDBForOldMountIds(ADDON.DB.Ignored.ids, "Ignored")

        searchRetiredMountsInCurrentSources()
    end
end

local function checkMissingFamilyLocalisations()

-- manual english export
local L = {
	["Families"] = {
-- fill me
	}
}

    for outerIndex, outerList in pairs(ADDON.DB.Family) do
        if not L.Families[outerIndex] then
            print("Missing Localisation for", outerIndex)
        end

        for innerIndex, innerValue in pairs(outerList) do
            if innerValue ~= true and not L.Families[innerIndex] then
                print("Missing Localisation for", innerIndex)
            end
        end
    end
end

local function testFavorites()
    local _,_, favorites = ADDON.Api:GetFavoriteProfile()
    local expectedMounts = tFilter(favorites, function(mountId)
        local _, _, _, _, _, _, _, _, _, shouldHideOnChar = C_MountJournal.GetMountInfoByID(mountId)
        return not shouldHideOnChar
    end, true)

    for i = 1, 10000 do
        local name, _, _, _, _, _, isFavorite, _,_,_,_, mountId = C_MountJournal.GetDisplayedMountInfo(i)
        if isFavorite then
            local listIndex = tIndexOf(expectedMounts,mountId)
            if listIndex then
                tUnorderedRemove(expectedMounts, listIndex)
            else
                print("Mount still favored although not in profile:", mountId, name)
            end
        else
            break
        end
    end

    for _, mountId in pairs(expectedMounts) do
        local name = C_MountJournal.GetMountInfoByID(mountId)
        print("Mount still not favored:", mountId, name)
    end
end

local taintedList = {}
local function checkTaintedTable(tbl, parentPath, currentList)
    for key, val in pairs(tbl) do
        if type(key) == "number" or (type(key) == "string" and not key:match("MJE_")) then
            local isSecure, taintedBy = issecurevariable(tbl, key)
            if not isSecure and currentList[key] ~= true then
                print(key .. " got tainted within " .. parentPath .. " by: " .. taintedBy)
                currentList[key] = true
            elseif isSecure and currentList[key] == true then
                print(key .. " is not tainted within " .. parentPath .. " anymore")
                currentList[key] = nil
            end

            if currentList[key] ~= true and type(val) == "table" and key ~= "parent" and key ~= "ModelScene" and key ~= "tooltipFrame" and key ~= "tooltipFrame" and key ~= "ScrollBox"  and key ~= "ScrollBar" then
                if currentList[key] == nil then
                    currentList[key] = {}
                end
                currentList[key] = checkTaintedTable(val, parentPath .. "." .. key, currentList[key])
            end
        end
    end

    return currentList
end
local function checkForTaint()
    local isSecure, taintedBy = issecurevariable("MountJournal")
    if not isSecure and not taintedList["MountJournal"] then
        print("MountJournal got tainted by: " .. taintedBy)
        taintedList["MountJournal"] = true
    end
    taintedList = checkTaintedTable(MountJournal, "MountJournal", taintedList)
end

function MJE_CheckBackgroundFavorites()
    for i = 1, 100 do
        local name, _, _, _, _, _, isFavorite,_,_,_,_,mountId = C_MountJournal.GetDisplayedMountInfo(i)
        if isFavorite then
            print("Favorit:", name, mountId)
        end
    end
end

ADDON.Events:RegisterCallback("postloadUI", function()
    testDatabase()
    -- checkMissingFamilyLocalisations()

    -- disable taint checks for now
    --checkForTaint()
    --C_Timer.NewTicker(1, checkForTaint)
end, "debug")
ADDON.Events:RegisterCallback("AfterLogin", function()
    C_Timer.After(30, testFavorites)
end, "debug")

function ADDON.Debug:CheckListTaint(process)
    if MountJournal and MountJournal.ListScrollFrame then
        taintedList.ListScrollFrame = taintedList.ListScrollFrame or {}

        local isTrue = function(val)
            return val == true
        end

        if not ContainsIf(taintedList.ListScrollFrame, isTrue) then
            checkTaintedTable(MountJournal.ListScrollFrame, process .. " - MountJournal.ListScrollFrame", taintedList)
            if ContainsIf(taintedList.ListScrollFrame, isTrue) then
                print("Call stack:\n" .. debugstack())
            end
        end
    end
end