local ADDON_NAME, ADDON = ...

local doStrip = false

local function isPersonalMount(spellId, faction, hasRidingSkill)

    -- without riding skill you can only ride heirloom chopper and sea or riding turtle
    if hasRidingSkill == false and spellId ~= 179244 and spellId ~= 179245 and spellId ~= 30174 and spellId ~= 64731 then
        return false
    end

    if faction ~= nil and false == ADDON.playerIsFaction(faction) then
        return false
    end

    if ADDON.DB.Restrictions[spellId] == nil then
        return true
    end

    return ADDON.DB.Restrictions[spellId]()
end

local function count()
    local hasSkill = IsSpellKnown(33388) or IsSpellKnown(33391) or IsSpellKnown(34090) or IsSpellKnown(34091) or IsSpellKnown(90265)  -- Riding skils

    local mountIDs = C_MountJournal.GetMountIDs()
    local total, owned, personal, personalTotal = 0, 0, 0, 0
    for _, mountID in ipairs(mountIDs) do
        local _, spellId, _, _, _, _, _, _, faction, hideOnChar, isCollected = C_MountJournal.GetMountInfoByID(mountID)
        if hideOnChar == false or (ADDON.settings.filter.hiddenIngame and not ADDON.DB.Ignored[mountID]) then
            total = total + 1

            local isPersonal = isPersonalMount(spellId, faction, hasSkill)

            if isPersonal then
                personalTotal = personalTotal + 1
            end

            if isCollected then
                owned = owned + 1
                if isPersonal then
                    personal = personal + 1
                end
            end
        end
    end

    return personal, personalTotal, owned, total
end

local function generateText(num, total)
    if num < total then
        return num .. '/' .. total
    end

    return total
end

local function CreateCharacterMountCount()
    local frame = CreateFrame("frame", nil, MountJournal, "InsetFrameTemplate3")

    frame:ClearAllPoints()
    frame:SetPoint("BOTTOMLEFT", MountJournal.MountCount, "TOPLEFT", 0, 0)
    frame:SetSize(130, 19)
    if doStrip then
        frame:StripTextures()
    end

    frame.staticText = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    frame.staticText:ClearAllPoints()
    frame.staticText:SetPoint("LEFT", frame, 6, 0)
    frame.staticText:SetText(CHARACTER)

    frame.uniqueCount = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    frame.uniqueCount:ClearAllPoints()
    frame.uniqueCount:SetPoint("RIGHT", frame, -6, 0)

    local updateTexts = function(_, value, _, _, _, isRecursiveCall)

        if true == isRecursiveCall then
            return
        end

        if ADDON.settings.ui.showPersonalCount then
            local displayCount = ADDON.Api:GetNumDisplayedMounts()

            local personal, personalTotal, owned, totalCount = count()
            frame.uniqueCount:SetText(generateText(personal, personalTotal))

            if displayCount == 0 or displayCount == totalCount then
                MountJournal.MountCount.Label:SetText(TOTAL_MOUNTS)
                MountJournal.MountCount.Count.SetText(MountJournal.MountCount.Count, generateText(owned, totalCount), nil, nil, nil, true)
            else
                local collectedFilter = 0
                for index = 1, displayCount do
                    local _, _, _, _, _, _, _, _, _, _, isCollected = ADDON.Api:GetDisplayedMountInfo(index)
                    if isCollected then
                        collectedFilter = collectedFilter + 1
                    end
                end
                MountJournal.MountCount.Label:SetText(FILTER)
                MountJournal.MountCount.Count.SetText(MountJournal.MountCount.Count, generateText(collectedFilter, displayCount), nil, nil, nil, true)
            end
        end
    end
    hooksecurefunc(MountJournal.MountCount.Count, "SetText", updateTexts)
    ADDON.Events:RegisterCallback("OnFilterUpdate", updateTexts, ADDON_NAME .. 'MountCount')
    updateTexts()

    return frame
end

local frame

ADDON:RegisterUISetting('showPersonalCount', true, ADDON.L.SETTING_MOUNT_COUNT, function(flag)
    if ADDON.initialized then
        if not frame and flag then
            frame = CreateCharacterMountCount()

            ADDON.UI:SaveSize(MountJournal.MountCount)
            ADDON.UI:SavePoint(MountJournal.MountCount)
            ADDON.UI:SavePoint(MountJournal.MountCount.Label)
            ADDON.UI:SavePoint(MountJournal.MountCount.Count)
        end

        if frame then
            frame:SetShown(flag)

            if flag then
                MountJournal.MountCount:SetSize(130, 19)
                MountJournal.MountCount:SetPoint("TOPLEFT", 70, -41)
                MountJournal.MountCount.Label:SetPoint("LEFT", 6, 0)
                MountJournal.MountCount.Count:SetPoint("RIGHT", -6, 0)
            else
                ADDON.UI:RestoreSize(MountJournal.MountCount)
                ADDON.UI:RestorePoint(MountJournal.MountCount)
                ADDON.UI:RestorePoint(MountJournal.MountCount.Label)
                ADDON.UI:RestorePoint(MountJournal.MountCount.Count)
            end

            --to trigger update function
            ADDON.UI:UpdateMountList()
        end
    end
end)

ADDON.Events:RegisterCallback("loadUI", function()
    ADDON:ApplySetting('showPersonalCount', ADDON.settings.ui.showPersonalCount)
end, "mount count")

ADDON.UI:RegisterUIOverhaulCallback(function(self)
    if self == MountJournal.MountCount then
        doStrip = true
    end
end)