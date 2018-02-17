
local function findMountIdOfSpellId(spellId)
    local mountIds = C_MountJournal.GetMountIDs()
    for i, mountId in ipairs(mountIds) do
        local _, mountSpellId = C_MountJournal.GetMountInfoByID(mountId)
        if spellId == mountSpellId then
            return mountId
        end
    end
end

local function openMountBySpellId(spellId)
    local mountId = findMountIdOfSpellId(spellId)
    if mountId then
        SetCollectionsJournalShown(true, COLLECTIONS_JOURNAL_TAB_INDEX_MOUNTS);
        MountJournal_SelectByMountID(mountId, spellId)
    end
end

local function handleDressUp(itemLink)
    local itemId = GetItemInfoInstant(itemLink)
    if itemId and MountJournalEnhancedItems[itemId] then
        openMountBySpellId( MountJournalEnhancedItems[itemId])
    end
end

hooksecurefunc("DressUpItemLink", handleDressUp)