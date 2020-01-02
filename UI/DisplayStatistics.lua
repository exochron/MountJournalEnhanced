local ADDON_NAME, ADDON = ...

-- todo: formatting & icons

ADDON:RegisterUISetting('showUsageStatistics', true, ADDON.L.SETTING_SHOW_USAGE)

local function setupText()
    local frame = MountJournal.MountDisplay.InfoButton

    local statsText = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    statsText:SetPoint("TOPLEFT", frame.Icon, "BOTTOMLEFT", 0, -6)
    statsText:SetSize(345, 0)
    statsText:SetJustifyH("CENTER")

    frame.Source:ClearAllPoints()
    frame.Source:SetPoint("TOPLEFT", statsText, "BOTTOMLEFT", 0, 0)

    return statsText
end

ADDON:RegisterLoadUICallback(function()
    local statsText = setupText()

    hooksecurefunc("MountJournal_UpdateMountDisplay", function()
        if MountJournal.selectedMountID and statsText then
            local text = ""
            if ADDON.settings.ui.showUsageStatistics then
                local useCount, lastUseTime, travelTime, travelDistance, learnedTime = ADDON:GetMountStatistics(MountJournal.selectedMountID)
                if useCount ~= nil then
                    text = useCount
                    if lastUseTime then
                        text = text .. ' | ' .. lastUseTime
                    end
                    if travelTime > 0 then
                        text = text .. ' | ' .. travelTime .. 's'
                    end
                    if travelDistance > 0 then
                        text = text .. ' | ' .. travelDistance .. 'yd'
                    end
                    if learnedTime then
                        text = text .. ' | ' .. learnedTime
                    end
                end
            end
            statsText:SetText(text)
        end
    end)
end)