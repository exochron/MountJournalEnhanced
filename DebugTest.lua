local ADDON_NAME, ADDON = ...

local MountJournalEnhancedFamily = ADDON.MountJournalEnhancedFamily
local MountJournalEnhancedSource = ADDON.MountJournalEnhancedSource
local MountJournalEnhancedExpansion = ADDON.MountJournalEnhancedExpansion
local MountJournalEnhancedIgnored = ADDON.MountJournalEnhancedIgnored

local function RunDebugTest()
    local mounts = {}
    local mountIDs = C_MountJournal.GetMountIDs()
    for i, mountID in ipairs(mountIDs) do
        local name, spellID, icon, active, isUsable, sourceType = C_MountJournal.GetMountInfoByID(mountID)
        mounts[spellID] = {
            name = name,
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

    for spellID, data in pairs(mounts) do
        if not MountJournalEnhancedIgnored[spellID] then
            if ADDON:FilterMountsBySource(spellID, data.sourceType) then
                print("[MJE] New mount: " .. data.name .. " (" .. spellID .. ")")
            end
            if ADDON:FilterMountsByFamily(spellID) then
                print("[MJE] No family info for mount: " .. data.name .. " (" .. spellID .. ")")
            end
            if ADDON:FilterMountsByExpansion(spellID) then
                print("[MJE] No expansion info for mount: " .. data.name .. " (" .. spellID .. ")")
            end
            if ADDON:FilterMountsByType(spellID, data.mountID) then
                print("[MJE] New mount type for mount \"" .. data.name .. "\" (" .. spellID .. ")")
            end
        end
    end

    ADDON.settings.filter = CopyTable(filterSettingsBackup)

    for _, expansionMounts in pairs(MountJournalEnhancedExpansion) do
        for id, _ in pairs(expansionMounts) do
            if id ~= "minID" and id ~= "maxID" and not mounts[id] then
                print("[MJE] Old expansion info for mount: " .. id)
            end
        end
    end

    for id, name in pairs(MountJournalEnhancedIgnored) do
        if not mounts[id] then
            print("[MJE] Old ignore entry for mount: " .. id)
        end
    end
end

ADDON:RegisterLoadUICallback(function()
    if ADDON.settings.debugMode then
        RunDebugTest()
    end
end)