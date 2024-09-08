local _, ADDON = ...

local function updateSourceText(replace, sourceText)
    local text, count = sourceText:gsub(":%s?|r%s?.+|n", ":|r "..replace.."|n", 1)
    if count == 0 then
        text = sourceText:gsub(":%s?|r%s?.+$", ":|r "..replace, 1)
    end
    MountJournal.MountDisplay.InfoButton.Source:SetText(text)
end

local function replaceTextWithLinks()
    local mountId = ADDON.Api:GetSelected()
    local _, spellId, _, _, _, sourceType = C_MountJournal.GetMountInfoByID(mountId)

    local achievementIds = ADDON.DB.Source.Achievement[spellId] or ADDON.DB.FeatsOfStrength[mountId]
    if achievementIds and achievementIds ~= true then
        if type(achievementIds)=="number" then
            achievementIds = {achievementIds}
        end
        local _, _, sourceText = C_MountJournal.GetMountInfoExtraByID(mountId)

        for _, achievementId in ipairs(achievementIds) do
            local link = GetAchievementLink(achievementId)
            if link then
                if sourceType == 6 then
                    updateSourceText(link, sourceText)
                    break
                else
                    local _, name = GetAchievementInfo(achievementId)
                    if name then
                        name = name:gsub("([()-])", "%%%1")
                        sourceText = sourceText:gsub(name, link)
                        MountJournal.MountDisplay.InfoButton.Source:SetText(sourceText)
                        break
                    end
                end
            end
        end
    elseif ADDON.DB.Source.Instance[spellId] and ADDON.DB.Source.Instance[spellId] ~= true then
        local _, _, sourceText = C_MountJournal.GetMountInfoExtraByID(mountId)
        local encounterId = ADDON.DB.Source.Instance[spellId][1]
        local difficultyId = ADDON.DB.Source.Instance[spellId][2]
        local name = EJ_GetEncounterInfo(encounterId)
        local link = C_EncounterJournal.GetEncounterJournalLink(1, encounterId, name, difficultyId)
        updateSourceText(link, sourceText)
    end
end

ADDON.Events:RegisterCallback("OnUpdateMountDisplay", replaceTextWithLinks, 'ReplaceText')