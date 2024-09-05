local _, ADDON = ...

local function updateSourceText(search, replace, sourceText)
    local text, count = sourceText:gsub(search, replace, 1)
    MountJournal.MountDisplay.InfoButton.Source:SetText(text)
    return count
end

local function replaceTextWithLinks()
    local mountId = ADDON.Api:GetSelected()
    local _, spellId = C_MountJournal.GetMountInfoByID(mountId)

    local achievementIds = ADDON.DB.Source.Achievement[spellId]
    if achievementIds and achievementIds ~= true then
        if type(achievementIds)=="number" then
            achievementIds = {achievementIds}
        end
        local _, _, sourceText = C_MountJournal.GetMountInfoExtraByID(mountId)

        for _, achievementId in ipairs(achievementIds) do
            local _, name = GetAchievementInfo(achievementId)
            if name then
                local link = GetAchievementLink(achievementId)
                name = name:gsub("([()-])", "%%%1")
                updateSourceText(name, link, sourceText)

                break
            end
        end
    elseif ADDON.DB.Source.Instance[spellId] and ADDON.DB.Source.Instance[spellId] ~= true then
        local _, _, sourceText = C_MountJournal.GetMountInfoExtraByID(mountId)
        local encounterId = ADDON.DB.Source.Instance[spellId][1]
        local difficultyId = ADDON.DB.Source.Instance[spellId][2]
        local name = EJ_GetEncounterInfo(encounterId)
        local link = C_EncounterJournal.GetEncounterJournalLink(1, encounterId, name, difficultyId)
        if 0 == updateSourceText(":%s?|r%s?.+|n", ":|r "..link.."|n", sourceText) then
            updateSourceText(":%s?|r%s?.+$", ":|r "..link, sourceText)
        end
    end
end

ADDON.Events:RegisterCallback("OnUpdateMountDisplay", replaceTextWithLinks, 'ReplaceText')