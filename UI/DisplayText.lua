local _, ADDON = ...

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
                sourceText = sourceText:gsub(name, link)
                MountJournal.MountDisplay.InfoButton.Source:SetText(sourceText)

                break
            end
        end

    end
end

ADDON.Events:RegisterCallback("OnUpdateMountDisplay", replaceTextWithLinks, 'ReplaceText')