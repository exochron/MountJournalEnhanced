local _, ADDON = ...

local doStrip = false

local playerFaction
local function isPersonalMount(mountID, faction)

    if mountID >= 117 and mountID <= 120 then
        -- qiraji battle tanks dont count
        return false
    end

    if faction == nil then
        return true
    end

    if playerFaction == nil then
        playerFaction = UnitFactionGroup("player")
    end

    if faction == 1 and playerFaction == "Alliance" then
        return true
    end
    if faction == 0 and playerFaction == "Horde" then
        return true
    end

    return false
end

local function count()
    local mountIDs = C_MountJournal.GetMountIDs()
    local total, owned, personal, personalTotal = 0, 0, 0, 0
    for _, mountID in ipairs(mountIDs) do
        local _, _, _, _, _, _, _, _, faction, hideOnChar, isCollected = C_MountJournal.GetMountInfoByID(mountID)
        if hideOnChar ~= true then
            total = total + 1

            local isPersonal = isPersonalMount(mountID, faction)

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

    local updateFunc = function()
        if ADDON.settings.ui.showPersonalCount then
            local personal, personalTotal, owned, totalCount = count()

            local displayCount = C_MountJournal.GetNumDisplayedMounts()
            if displayCount > 0 and displayCount < totalCount then
                local collectedFilter = 0
                for index = 1, displayCount do
                    local _, _, _, _, _, _, _, _, _, _, isCollected = C_MountJournal.GetDisplayedMountInfo(index)
                    if isCollected then
                        collectedFilter = collectedFilter + 1
                    end
                end
                MountJournal.MountCount.Label:SetText(FILTER)
                MountJournal.MountCount.Count:SetText(generateText(collectedFilter, displayCount))
            else
                MountJournal.MountCount.Label:SetText(TOTAL_MOUNTS)
                MountJournal.MountCount.Count:SetText(generateText(owned, totalCount))
            end

            frame.uniqueCount:SetText(generateText(personal, personalTotal))
        end
    end
    hooksecurefunc("MountJournal_UpdateMountList", updateFunc)
    hooksecurefunc(MountJournal.ListScrollFrame, "update", updateFunc)

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