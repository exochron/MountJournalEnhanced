local function handleDressUpItem(itemLink)
    local itemId = GetItemInfoInstant(itemLink)
    if itemId then
        local spellId = MountJournalEnhancedItems[itemId]
        if spellId then
            local mountId = C_MountJournal.GetMountFromSpell(spellId);
            if mountId then
                local creatureDisplayID = C_MountJournal.GetMountInfoExtraByID(mountId);
                return DressUpMount(creatureDisplayID);
            end
        end
    end
end

hooksecurefunc("DressUpItemLink", handleDressUpItem)