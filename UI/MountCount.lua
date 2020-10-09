local _, ADDON = ...

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
        if hideOnChar == false then
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
    frame.staticText:SetPoint("LEFT", frame, 10, 0)
    frame.staticText:SetText(CHARACTER)

    frame.uniqueCount = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    frame.uniqueCount:ClearAllPoints()
    frame.uniqueCount:SetPoint("RIGHT", frame, -10, 0)

    local lastOriginalValue, lastDisplayCount, lastTotalCount, original_CountSetText
    original_CountSetText = MountJournal.MountCount.Count.SetText
    MountJournal.MountCount.Count.SetText = function(label, value)

        if ADDON.settings.ui.showPersonalCount then
            local displayCount = C_MountJournal.GetNumDisplayedMounts()

            if value ~= lastOriginalValue
                    or (displayCount == lastTotalCount and lastDisplayCount ~= nil and lastDisplayCount < displayCount)
                    or (displayCount == 0 and lastDisplayCount ~= nil)
            then
                lastOriginalValue = value
                lastDisplayCount = nil
                local personal, personalTotal, owned, totalCount = count()
                lastTotalCount = totalCount
                frame.uniqueCount:SetText(generateText(personal, personalTotal))

                if displayCount == 0 or displayCount == totalCount then
                    MountJournal.MountCount.Label:SetText(TOTAL_MOUNTS)
                    original_CountSetText(MountJournal.MountCount.Count, generateText(owned, totalCount))
                end
            end
            if displayCount > 0 and displayCount < lastTotalCount and displayCount ~= lastDisplayCount then
                lastDisplayCount = displayCount
                local collectedFilter = 0
                for index = 1, displayCount do
                    local _, _, _, _, _, _, _, _, _, _, isCollected = C_MountJournal.GetDisplayedMountInfo(index)
                    if isCollected then
                        collectedFilter = collectedFilter + 1
                    end
                end
                MountJournal.MountCount.Label:SetText(FILTER)
                original_CountSetText(MountJournal.MountCount.Count, generateText(collectedFilter, displayCount))
            end
        else
            original_CountSetText(MountJournal.MountCount.Count, value)
            lastOriginalValue, lastDisplayCount, lastTotalCount = nil
        end
    end

    return frame
end

local frame

ADDON:RegisterUISetting('showPersonalCount', true, ADDON.L.SETTING_MOUNT_COUNT, function(flag)
    if MountJournal then
        if not frame and flag then
            frame = CreateCharacterMountCount()

            ADDON.UI:SavePoint(MountJournal.MountCount)
            ADDON.UI:SaveSize(MountJournal.MountCount)
        end

        if frame then
            frame:SetShown(flag)

            if flag then
                MountJournal.MountCount:SetPoint("TOPLEFT", 70, -41)
                MountJournal.MountCount:SetSize(130, 19)
            else
                ADDON.UI:RestorePoint(MountJournal.MountCount)
                ADDON.UI:RestoreSize(MountJournal.MountCount)
            end

            --to trigger update function
            MountJournal_UpdateMountList()
        end
    end
end)

ADDON:RegisterLoadUICallback(function()
    ADDON:ApplySetting('showPersonalCount', ADDON.settings.ui.showPersonalCount)
end)

ADDON.UI:RegisterUIOverhaulCallback(function(self)
    if (self == MountJournal.MountCount) then
        doStrip = true
    end
end)