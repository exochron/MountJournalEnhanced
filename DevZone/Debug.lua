local ADDON_NAME, ADDON = ...

local function print(...)
    _G.print("[MJE]", ...)
end

ADDON.Debug = {}

local lastProfileTimes = {}
local lastProfileCounts = {}
--- to actually use this enable the cvar: scriptProfile
function ADDON.Debug:ProfileFunction(name, func, includeSubroutines)
    local lastTime = lastProfileTimes[name] or 0
    local lastCount = lastProfileCounts[name] or 0
    local totalTime, totalCount = GetFunctionCPUUsage(func, includeSubroutines)
    if totalCount > lastCount then
        print("*" .. name .. "*", "current_time=" .. (totalTime - lastTime), "total_time=" .. totalTime, "total_count=" .. totalCount)
        lastProfileTimes[name] = totalTime
        lastProfileCounts[name] = totalCount
    end
end
function ADDON.Debug:WatchFunction(name, func, includeSubroutines)
    C_Timer.NewTicker(5, function()
        ADDON.Debug:ProfileFunction(name, func, includeSubroutines)
    end)
end

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

    if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
        checkDBForOldMountIds(ADDON.DB.FeatsOfStrength, "FeatsOfStrength")
        checkDBForOldMountIds(ADDON.DB.Expansion, "Expansion")
        checkDBForOldMountIds(ADDON.DB.Type, "Type")
        checkDBForOldMountIds(ADDON.DB.Ignored.ids, "Ignored")

        searchRetiredMountsInCurrentSources()
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

ADDON.Events:RegisterCallback("postloadUI", function()
    testDatabase()

    -- https://github.com/Stanzilla/WoWUIBugs/issues/699
    if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE and C_MountJournal.GetMountLink(458) then
        print("C_MountJournal.GetMountLink() got fixed! \\o\/")
    end

    -- disable taint checks for now
    --checkForTaint()
    --C_Timer.NewTicker(1, checkForTaint)
end, "debug")

ADDON.Events:RegisterFrameEventAndCallback("PLAYER_ENTERING_WORLD", function(_, isLogin, isReload)
    if isLogin and not isReload then
        print("Thank you for participating in the development of "..ADDON_NAME.."! Your help is really appreciated!")
    end
end, 'hello dev')

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