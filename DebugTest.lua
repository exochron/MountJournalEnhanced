local ADDON_NAME, ADDON = ...

local IgnoredDB = ADDON.DB.Ignored

local function RunDebugTest()
    local mounts = {}
    local mountIDs = C_MountJournal.GetMountIDs()
    for _, mountID in ipairs(mountIDs) do
        local name, spellID, icon, active, isUsable, sourceType = C_MountJournal.GetMountInfoByID(mountID)
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
                print("[MJE] New mount: " .. data.name .. " (" .. data.spellID .. ", " .. data.mountID .. ", " .. data.sourceType .. ") ")
            end
            if ADDON:FilterMountsByFamily(data.spellID) then
                print("[MJE] No family info for mount: " .. data.name .. " (" .. data.spellID .. ", " .. data.mountID .. ")")
            end
            if ADDON:FilterMountsByExpansion(data.spellID) then
                print("[MJE] No expansion info for mount: " .. data.name .. " (" .. data.spellID .. ", " .. data.mountID .. ")")
            end
            if ADDON:FilterMountsByType(data.spellID, data.mountID) then
                print("[MJE] New mount type for mount \"" .. data.name .. "\" (" .. data.spellID .. ", " .. data.mountID .. ") ")
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
    --            print("[MJE] Old expansion info for mount: " .. id)
    --        end
    --    end
    --end

    for mountId, _ in pairs(IgnoredDB) do
        if not mounts[mountId] then
            print("[MJE] Old ignore entry for mount: " .. mountId)
        end
    end
end

ADDON:RegisterLoadUICallback(function()
    if ADDON.settings.ui.debugMode then
        RunDebugTest()
    end
end)

EventRegistry:RegisterCallback("MountJournal.OnShow", function()
    if ADDON.settings.ui.debugMode then
        local blacklist= {}
        local check = function()
            if not issecurevariable("MountJournal") and not blacklist["MJ"] then
                print("MountJournal is tainted")
                blacklist["MJ"] = true
            end
            for key, val in pairs(MountJournal) do
                if not issecurevariable(MountJournal, key) and not blacklist[key] and not key:match("MJE_") then
                    print(key .. " is tainted")
                    blacklist[key] = true
                elseif issecurevariable(MountJournal, key) and blacklist[key] then
                    print(key .. " is not tainted anymore")
                    blacklist[key] = nil
                end
            end
        end
        C_Timer.NewTicker(0.3, check)
    end
    EventRegistry:UnregisterCallback("MountJournal.OnShow", ADDON_NAME .. ".debug")
end, ADDON_NAME .. ".debug")