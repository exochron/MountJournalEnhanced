local ADDON_NAME, ADDON = ...

ADDON:RegisterUISetting('showUsageStatistics', true, ADDON.L.SETTING_SHOW_USAGE)

local function setupFontString()
    local frame = MountJournal.MountDisplay.InfoButton

    local statsText = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    statsText:SetPoint("TOPLEFT", frame.Icon, "BOTTOMLEFT", 0, -6)
    statsText:SetSize(345, 0)
    statsText:SetJustifyH("CENTER")

    frame.Source:ClearAllPoints()
    frame.Source:SetPoint("TOPLEFT", statsText, "BOTTOMLEFT", 0, 0)

    return statsText
end

local function formatDistance(length)
    if ADDON.isMetric then
        length = length / 1.0936
        if length < 1000 then
            return floor(length) .. 'm';
        end
        return floor(length / 1000) .. 'km';
    else
        if length < 1760 then
            return floor(length) .. 'yd';
        end
        return floor(length / 1760) .. 'mi';
    end
end

local function generateText(mountId)
    local text = ''
    local useCount, lastUseTime, travelTime, travelDistance, learnedTime = ADDON:GetMountStatistics(mountId)
    if useCount ~= nil then
        if useCount > 0 then
            -- interface/icons/achievement_guildperk_mountup
            text = '|T413588:0|t' .. useCount..'x'
        end
        if travelTime > 0 then
            -- interface/icons/spell_nature_timestop
            text = text .. '  |T136106:0|t' .. SecondsToClock(travelTime, true)
        end
        if travelDistance > 0 then
            -- interface/icons/ability_druid_dash_orange
            text = text .. '  |T1817485:0|t' .. formatDistance(travelDistance)
        end
        if learnedTime then
            -- interface/buttons/ui-checkbox-check
            local data = date('*t', learnedTime)
            text = text .. "  |T130751:0|t" .. FormatShortDate(data.day, data.month, data.year)
        end
    end
    return text
end

ADDON:RegisterLoadUICallback(function()
    local statsText = setupFontString()

    hooksecurefunc("MountJournal_UpdateMountDisplay", function()
        if MountJournal.selectedMountID and statsText then
            local text = ''
            if ADDON.settings.ui.showUsageStatistics then
                text = generateText(MountJournal.selectedMountID)
            end
            statsText:SetText(text)
        end
    end)
end)