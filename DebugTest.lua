local ADDON_NAME, ADDON = ...

local IgnoredDB = ADDON.DB.Ignored

local function print(...)
    _G.print("[MJE]", ...)
end

ADDON.Debug = {}

local lastProfileTimes = {}
local lastProfileCounts = {}
--- to actually use this enable the cvar: scriptProfile
function ADDON.Debug:ProfileFunction(func, includeSubroutines)
    local lastTime = lastProfileTimes[func] or 0
    local lastCount = lastProfileCounts[func] or 0
    local totalTime, totalCount = GetFunctionCPUUsage(ADDON.SortMounts, includeSubroutines)
    if totalCount > lastCount then
        print("current call time: "..(totalTime-lastTime), "total call time: " .. totalTime, "total call count " .. totalCount)
        lastProfileTimes[func] = totalTime
        lastProfileCounts[func] = totalCount
    end
end
function ADDON.Debug:WatchFunction(func, includeSubroutines)
    C_Timer.NewTicker(5, function()
        ADDON.Debug:ProfileFunction(func, includeSubroutines)
    end)
end

local function testDatabase()
    local mounts = {}
    local mountIDs = C_MountJournal.GetMountIDs()
    for _, mountID in ipairs(mountIDs) do
        local name, spellID, _, _, _, sourceType = C_MountJournal.GetMountInfoByID(mountID)
        mounts[mountID] = {
            name = name,
            spellID = spellID,
            mountID = mountID,
            sourceType = sourceType,
        }
    end

    local filterSettingsBackup = CopyTable(ADDON.settings.filter)
    for key, _ in pairs(ADDON.settings.filter.source) do
        ADDON.settings.filter.source[key] = false
    end
    for key, value in pairs(ADDON.settings.filter.family) do
        if type(value) == "table" then
            for subKey, _ in pairs(value) do
                ADDON.settings.filter.family[key][subKey] = false
            end
        else
            ADDON.settings.filter.family[key] = false
        end
    end
    for key, _ in pairs(ADDON.settings.filter.expansion) do
        ADDON.settings.filter.expansion[key] = false
    end
    for key, _ in pairs(ADDON.settings.filter.mountType) do
        ADDON.settings.filter.mountType[key] = false
    end

    for _, data in pairs(mounts) do
        if not IgnoredDB[data.mountID] then
            if ADDON:FilterMountsBySource(data.spellID, data.sourceType) then
                print("New mount: " .. data.name .. " (" .. data.spellID .. ", " .. data.mountID .. ", " .. data.sourceType .. ") ")
            end
            if ADDON:FilterMountsByFamily(data.spellID) then
                print("No family info for mount: " .. data.name .. " (" .. data.spellID .. ", " .. data.mountID .. ")")
            end
            if ADDON:FilterMountsByExpansion(data.spellID) then
                print("No expansion info for mount: " .. data.name .. " (" .. data.spellID .. ", " .. data.mountID .. ")")
            end
            if ADDON:FilterMountsByType(data.spellID, data.mountID) then
                print("New mount type for mount \"" .. data.name .. "\" (" .. data.spellID .. ", " .. data.mountID .. ") ")
            end
        end
    end

    ADDON.settings.filter = CopyTable(filterSettingsBackup)
    if ADDON.settings.personalFilter then
        MJEPersonalSettings.filter = ADDON.settings.filter
    else
        MJEGlobalSettings.filter = ADDON.settings.filter
    end

    --for _, expansionMounts in pairs(ADDON.DB.Expansion) do
    --    for id, _ in pairs(expansionMounts) do
    --        if id ~= "minID" and id ~= "maxID" and not mounts[id] then
    --            print("Old expansion info for mount: " .. id)
    --        end
    --    end
    --end

    for mountId, _ in pairs(IgnoredDB) do
        if not mounts[mountId] then
            print("Old ignore entry for mount: " .. mountId)
        end
    end
end

local taintedList = {}
local function checkForTaint()
    local isSecure, taintedBy = issecurevariable("MountJournal")
    if not isSecure and not taintedList["MountJournal"] then
        print("MountJournal got tainted by: " .. taintedBy)
        taintedList["MountJournal"] = true
    end
    for key, _ in pairs(MountJournal) do
        isSecure, taintedBy = issecurevariable(MountJournal, key)
        if not isSecure and not taintedList[key] and not key:match("MJE_") then
            print(key .. " got tainted within MountJournal by: " .. taintedBy)
            taintedList[key] = true
        elseif isSecure and taintedList[key] then
            print(key .. " is not tainted within MountJournal anymore")
            taintedList[key] = nil
        end
    end
end

ADDON:RegisterLoadUICallback(function()
    if ADDON.settings.ui.debugMode then
        testDatabase()

        checkForTaint()
        C_Timer.NewTicker(1, checkForTaint)
    end
end)