local ADDON_NAME, ADDON = ...

local MountJournalEnhancedFamily = ADDON.MountJournalEnhancedFamily
local MountJournalEnhancedSource = ADDON.MountJournalEnhancedSource
local MountJournalEnhancedExpansion = ADDON.MountJournalEnhancedExpansion
local MountJournalEnhancedIgnored = ADDON.MountJournalEnhancedIgnored

function ADDON:RunDebugTest()
    local mounts = {}
    local mountIDs = C_MountJournal.GetMountIDs()
    for i, mountID in ipairs(mountIDs) do
        local name, spellID, icon, active, isUsable, sourceType = C_MountJournal.GetMountInfoByID(mountID)
        mounts[spellID] = {
            name=name,
            mountID=mountID,
            sourceType=sourceType,
        }
    end

    local filterSettingsBackup = CopyTable(self.settings.filter)
    for key, _ in pairs(self.settings.filter.source) do
        self.settings.filter.source[key] = false
    end
    for key, _ in pairs(self.settings.filter.family) do
        self.settings.filter.family[key] = false
    end
    for key, _ in pairs(self.settings.filter.expansion) do
        self.settings.filter.expansion[key] = false
    end
    for key, _ in pairs(self.settings.filter.mountType) do
        self.settings.filter.mountType[key] = false
    end

    for spellID, data in pairs(mounts) do
        if not MountJournalEnhancedIgnored[spellID] then
            if self:FilterMountsBySource(spellID, data.sourceType) then
                print("[MJE] New mount: " .. data.name .. " (" .. spellID .. ")")
            end
            if self:FilterMountsByFamily(spellID) then
                print("[MJE] No family info for mount: " .. data.name .. " (" .. spellID .. ")")
            end
            if self:FilterMountsByExpansion(spellID) then
                print("[MJE] No expansion info for mount: " .. data.name .. " (" .. spellID .. ")")
            end
            if self:FilterMountsByType(spellID, data.mountID) then
                print("[MJE] New mount type for mount \"" .. data.name .. "\" (" .. spellID .. ")")
            end
        end
    end

    self.settings.filter = CopyTable(filterSettingsBackup)

    for _, familyMounts in pairs(MountJournalEnhancedFamily) do
        for id, name in pairs(familyMounts) do
            if id ~= "keywords" and not MountJournalEnhancedIgnored[id] and not mounts[id] then
                print("[MJE] Old family info for mount: " .. name .. " (" .. id .. ")")
            end
        end
    end

    for _, expansionMounts in pairs(MountJournalEnhancedExpansion) do
        for id, name in pairs(expansionMounts) do
            if id ~= "minID" and id ~= "maxID" and not MountJournalEnhancedIgnored[id] and not mounts[id] then
                print("[MJE] Old expansion info for mount: " .. name .. " (" .. id .. ")")
            end
        end
    end

    local names = { }
    for _, data in pairs(MountJournalEnhancedSource) do
        for id, name in pairs(data) do
            if id ~= "sourceType" then
                if (names[id] and names[id] ~= name) then
                    print("[MJE] Invalide mount info for mount: " .. name .. " (" .. id .. ")")
                end
                names[id] = name
            end
        end
    end

    for id, name in pairs(MountJournalEnhancedIgnored) do
        if not mounts[id] then
            print("[MJE] Old ignore entry for mount: " .. name .. " (" .. id .. ")")
        end
    end
end