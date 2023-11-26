local ADDON_NAME, ADDON = ...

local tooltip
local LibMountsRarity

ADDON:RegisterUISetting('showStatistics', true, ADDON.L.SETTING_SHOW_STATISTICS, function()
    if ADDON.initialized then
        MountJournal_UpdateMountDisplay()
    end
end)

local function buildStat(container, iconTexture, tooltipHead, tooltipText)
    local item = CreateFrame("frame", nil, container)

    local icon = item:CreateTexture(nil, "OVERLAY")
    icon:SetTexture(iconTexture)
    if type(iconTexture) == "string" then
        icon:SetAtlas(iconTexture)
    end
    icon:SetSize(12, 12)
    icon:SetPoint("TOPLEFT", item, "TOPLEFT", 0, 0)
    item.Icon = icon

    local text = item:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    text:SetPoint("TOPLEFT", icon, "TOPRIGHT", 2, 0)
    item.Text = text

    item:SetHeight(12)

    item:HookScript("OnEnter", function(self)
        tooltip:SetOwner(self, "ANCHOR_TOP")
        tooltip:SetText(tooltipHead, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
        if tooltipText then
            tooltip:AddLine(tooltipText)
        end
        tooltip:Show()
    end)
    item:HookScript("OnLeave", function()
        tooltip:Hide()
    end)

    return item
end

local function setupContainer()

    local L = ADDON.L
    local infoButton = MountJournal.MountDisplay.InfoButton

    local container = CreateFrame("Frame", nil, infoButton)
    container:SetPoint("TOPLEFT", infoButton.Icon, "BOTTOMLEFT", 0, -5)
    container:SetPoint("RIGHT", MountJournal.MountDisplay, "RIGHT", -26, 0)
    container:SetHeight(12)

    tooltip = CreateFrame("GameTooltip", "MJEStatisticsHelpToolTip", container, "SharedNoHeaderTooltipTemplate")

    ADDON.UI:SavePoint(infoButton.Source)
    container:HookScript("OnShow", function()
        infoButton.Source:ClearAllPoints()
        infoButton.Source:SetPoint("TOPLEFT", container, "BOTTOMLEFT", 0, 0)
    end)
    container:HookScript("OnHide", function()
        ADDON.UI:RestorePoint(infoButton.Source)
    end)

    container.CustomizationCount = buildStat(container,
            "colorblind-colorwheel",
            L["STATS_TIP_CUSTOMIZATION_COUNT_HEAD"]
    )
    container.UsedCount = buildStat(container,
            397908, -- interface/levelup/leveluptex
            L["STATS_TIP_USAGE_COUNT_HEAD"]
    )
    container.UsedCount.Icon:SetTexCoord(0.720703125, 0.78125, 0.03515625, 0.1015625)
    container.TravelTime = buildStat(container,
            136106, -- spell_nature_timestop
            L["STATS_TIP_TRAVEL_TIME_HEAD"],
            L["STATS_TIP_TRAVEL_TIME_TEXT"]
    )
    container.TravelDistance = buildStat(container,
            132120, -- ability_druid_dash
            L["STATS_TIP_TRAVEL_DISTANCE_HEAD"]
    )
    container.LearnedDate = buildStat(container,
            "auctionhouse-icon-checkmark",
            L["STATS_TIP_LEARNED_DATE_HEAD"]
    )
    container.Rarity = buildStat(container,
            134071, -- interface/icons/inv_misc_gem_01
            L["STATS_TIP_RARITY_HEAD"],
            L["STATS_TIP_RARITY_DESCRIPTION"]
    )
    container.Family1 = buildStat(container,
            132834, -- interface/icons/inv_egg_03
            L["Family"]
    )
    container.Family2 = buildStat(container,
            132834, -- interface/icons/inv_egg_03
            L["Family"]
    )

    container:Hide()

    return container
end

local function formatDistance(length)
    if ADDON.isMetric then
        length = length / 1.0936
        if length < 1000 then
            return floor(length) .. ' m';
        end
        return floor(length / 1000) .. ' km';
    else
        if length < 1760 then
            return floor(length) .. ' yd';
        end
        return floor(length / 1760) .. ' mi';
    end
end

local function parseCustomization(mountData)
    local count = 0
    local total = 0

    if mountData["quest"] then
        total = total + #mountData["quest"]
        for _, questId in ipairs(mountData["quest"]) do
            if C_QuestLog.IsQuestFlaggedCompleted(questId) then
                count = count + 1
            end
        end
    end
    if mountData["achievement"] then
        total = total + #mountData["achievement"]
        for _, achievementId in ipairs(mountData["achievement"]) do
            if select(4, GetAchievementInfo(achievementId)) then
                count = count + 1
            end
        end
    end

    return count .. "/" .. total
end

local function buildFamilyStrings(mountId)
    local result = {}

    for mainFamily, values in pairs(ADDON.DB.Family) do
        if values[mountId] then
            result[#result + 1] = ADDON.L[mainFamily] or mainFamily
        end
        local firstKey = next(values)
        if type(firstKey) == "string" then
            for subFamily, subValues in pairs(values) do
                if subValues[mountId] then
                    result[#result + 1] = (ADDON.L[mainFamily] or mainFamily) .. " / " .. (ADDON.L[subFamily] or subFamily)
                end
            end
        end
        if #result == 2 then
            break
        end
    end

    return result[1] or nil, result[2] or nil
end

local function updateContainer(mountId, container)
    local displayed = {}

    container.CustomizationCount:SetShown(ADDON.DB.Customization[mountId] ~= nil)
    if ADDON.DB.Customization[mountId] ~= nil then
        container.CustomizationCount.Text:SetText(parseCustomization(ADDON.DB.Customization[mountId]))
        displayed[#displayed + 1] = container.CustomizationCount
    end

    local useCount, lastUseTime, travelTime, travelDistance, learnedTime = ADDON:GetMountStatistics(mountId)
    if useCount ~= nil then
        container.UsedCount:SetShown(useCount > 0)
        if useCount > 0 then
            container.UsedCount.Text:SetText(useCount .. ' x')
            displayed[#displayed + 1] = container.UsedCount
        end

        container.TravelTime:SetShown(travelTime > 0)
        if travelTime > 0 then
            container.TravelTime.Text:SetText(SecondsToClock(travelTime, true))
            displayed[#displayed + 1] = container.TravelTime
        end

        container.TravelDistance:SetShown(travelDistance > 0)
        if travelDistance > 0 then
            container.TravelDistance.Text:SetText(formatDistance(travelDistance))
            displayed[#displayed + 1] = container.TravelDistance
        end

        container.LearnedDate:SetShown(learnedTime)
        if learnedTime then
            local data = date('*t', learnedTime)
            container.LearnedDate.Text:SetText(FormatShortDate(data.day, data.month, data.year))
            displayed[#displayed + 1] = container.LearnedDate
        end
    end

    container.Rarity:SetShown(false)
    if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
        LibMountsRarity = LibMountsRarity or LibStub("MountsRarity-2.0")
        local rarity = LibMountsRarity:GetRarityByID(mountId)
        if rarity ~= nil then
            container.Rarity:SetShown(true)
            container.Rarity.Text:SetText(string.format("%.2f %%", rarity))
            displayed[#displayed + 1] = container.Rarity
        end
    end

    local mountFamily1, mountFamily2 = buildFamilyStrings(mountId)
    container.Family1:SetShown(mountFamily1 ~= nil)
    if mountFamily1 then
        container.Family1.Text:SetText(mountFamily1)
        displayed[#displayed + 1] = container.Family1
    end
    container.Family2:SetShown(mountFamily2 ~= nil)
    if mountFamily2 then
        container.Family2.Text:SetText(mountFamily2)
        displayed[#displayed + 1] = container.Family2
    end

    if #displayed > 0 then
        local maxWidth = MountJournal.MountDisplay:GetWidth() - 52
        local rowWidth = 0
        local rowLead
        local rowCount = 0
        for i, stat in ipairs(displayed) do
            stat:SetWidth(stat.Text:GetUnboundedStringWidth() + 14)
            stat:ClearAllPoints()
            rowWidth = rowWidth + 7 + stat:GetWidth()
            if maxWidth < rowWidth or rowLead == nil then
                rowWidth = stat:GetWidth()
                rowCount = rowCount + 1
                rowLead = stat
            else
                stat:SetPoint("LEFT", displayed[i - 1], "RIGHT", 7, 0)
            end
            rowLead:SetPoint("TOPLEFT", container, "TOP", -(rowWidth / 2), (rowCount - 1) * -12)
        end
        container:SetHeight(12 * rowCount)
    end

    container:SetShown(#displayed > 0)
end

ADDON.Events:RegisterCallback("loadUI", function()
    local container

    local callback = function()
        if ADDON.settings.ui.showStatistics then
            if not container then
                container = setupContainer()
            end

            local selectedMount = ADDON.Api:GetSelected()
            if selectedMount then
                updateContainer(selectedMount, container)
            else
                container:Hide();
            end

        elseif container then
            container:Hide()
        end
    end
    ADDON.Events:RegisterCallback("OnUpdateMountDisplay", callback, ADDON_NAME .. 'DisplayStatistics')
end, "display statistics")