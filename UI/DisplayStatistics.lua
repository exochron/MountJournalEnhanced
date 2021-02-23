local ADDON_NAME, ADDON = ...

ADDON:RegisterUISetting('showUsageStatistics', true, ADDON.L.SETTING_SHOW_USAGE, function()
    if ADDON.initialized then
        ADDON.UI:UpdateMountDisplay()
    end
end)

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
    -- see: https://wow.gamepedia.com/UI_escape_sequences
    local text = ''
    local useCount, lastUseTime, travelTime, travelDistance, learnedTime = ADDON:GetMountStatistics(mountId)
    if useCount ~= nil then
        if useCount > 0 then
            -- interface/icons/achievement_guildperk_mountup
            text = '|T413588:0|t' .. useCount .. 'x'
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
            local data = date('*t', learnedTime)
            text = text .. "  |A:auctionhouse-icon-checkmark:0:0|a" .. FormatShortDate(data.day, data.month, data.year)
        end
    end
    return text
end

ADDON.Events:RegisterCallback("loadUI", function()
    local statsText = setupFontString()

    local callback = function()
        local selectedMount = ADDON.Api:GetSelected()
        if selectedMount and statsText then
            local text = ''
            if ADDON.settings.ui.showUsageStatistics then
                text = generateText(selectedMount)
            end
            statsText:SetText(text)
        end
    end
    ADDON.Events:RegisterCallback("OnUpdateMountDisplay", callback, ADDON_NAME .. 'DisplayStatistics')
end, "display statistics")