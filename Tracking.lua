local ADDON_NAME, ADDON = ...

local INDEX_USE_COUNT, INDEX_LAST_USE_TIME, INDEX_TRAVEL_TIME, INDEX_TRAVEL_DISTANCE, INDEX_LEARNED_TIME = 1, 2, 3, 4, 5

MJETrackingData = MJETrackingData or {}

local HBD = LibStub("HereBeDragons-2.0")
local currentMount, startZone, startPositionX, startPositionY, travelTicker

function ADDON:GetMountStatistics(mountId)
    local blob = MJETrackingData[mountId] or {}
    return (blob[INDEX_USE_COUNT] or 0), (blob[INDEX_LAST_USE_TIME] or nil), (blob[INDEX_TRAVEL_TIME] or 0), (blob[INDEX_TRAVEL_DISTANCE] or 0), (blob[INDEX_LEARNED_TIME] or nil)
end

local function initData(mountId)
    if not MJETrackingData[mountId] then
        MJETrackingData[mountId] = {
            [INDEX_USE_COUNT] = 0,
            [INDEX_LAST_USE_TIME] = nil,
            [INDEX_TRAVEL_TIME] = 0,
            [INDEX_TRAVEL_DISTANCE] = 0,
            [INDEX_LEARNED_TIME] = nil,
        }
    end

    return MJETrackingData[mountId]
end

local function updateDistance()
    if MJETrackingData[currentMount] then
        local blob = MJETrackingData[currentMount]
        local currentPosX, currentPosY, currentZone = HBD:GetPlayerZonePosition()
        local distance = HBD:GetZoneDistance(startZone, startPositionX, startPositionY, currentZone, currentPosX, currentPosY)
        if distance then
            blob[INDEX_TRAVEL_DISTANCE] = blob[INDEX_TRAVEL_DISTANCE] + distance
        end
        startZone, startPositionX, startPositionY = currentZone, currentPosX, currentPosY
    end
end

local function startTracking(mount)
    currentMount = mount
    local blob = initData(mount)
    blob[INDEX_LAST_USE_TIME] = GetServerTime()
    blob[INDEX_USE_COUNT] = blob[INDEX_USE_COUNT] + 1
    startPositionX, startPositionY, startZone = HBD:GetPlayerZonePosition()
    travelTicker = C_Timer.NewTicker(5, updateDistance)
end
local function stopTracking(mount)
    local blob = initData(mount)
    blob[INDEX_TRAVEL_TIME] = blob[INDEX_TRAVEL_TIME] + (GetServerTime() - blob[INDEX_LAST_USE_TIME])

    travelTicker:Cancel()
    updateDistance()
    currentMount, startZone, startPositionX, startPositionY = nil, nil, nil, nil
end

local function checkMountEvent()
    if currentMount then
        stopTracking(currentMount)
    elseif ADDON.settings.trackUsageStats then
        for i = 1, 40 do
            local spellId = select(10, UnitBuff("player", i, "HELPFUL|PLAYER|CANCELABLE"))
            if spellId then
                local mountId = C_MountJournal.GetMountFromSpell(spellId)
                if mountId then
                    startTracking(mountId)
                    break
                end
            end
        end
    end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_MOUNT_DISPLAY_CHANGED") -- player mounts or dismounts
frame:SetScript("OnEvent", checkMountEvent)

ADDON.Events:RegisterCallback("OnLogin", checkMountEvent, "tracking")
ADDON.Events:RegisterCallback("OnNewMount", function(_, mountId)
    if mountId and ADDON.settings.trackUsageStats then
        local blob = initData(mountId)
        blob[INDEX_LEARNED_TIME] = GetServerTime()
    end
end, "tracking")

ADDON:RegisterBehaviourSetting('trackUsageStats', true, ADDON.L.SETTING_TRACK_USAGE, function(flag)
    MJEGlobalSettings.trackUsageStats = flag
end)

local function parseLearnedDateFromAchievements()
    if ADDON.settings.trackUsageStats then
        local lists = { ADDON.DB.Source.Achievement, ADDON.DB.FeatsOfStrength }
        for _, list in pairs(lists) do
            for spellId, achievementIds in pairs(list) do
                if achievementIds ~= true then
                    local mountId = C_MountJournal.GetMountFromSpell(spellId)
                    if mountId and (not MJETrackingData[mountId] or not MJETrackingData[mountId][INDEX_LEARNED_TIME]) then
                        local collected = select(11, C_MountJournal.GetMountInfoByID(mountId))
                        if collected then
                            if type(achievementIds) == "number" then
                                achievementIds = { achievementIds }
                            end
                            for _, achievementId in ipairs(achievementIds) do
                                local _, _, _, completed, month, day, year = GetAchievementInfo(achievementId)
                                if completed then
                                    local blob = initData(mountId)
                                    blob[INDEX_LEARNED_TIME] = time({
                                        ["year"] = 2000 + year,
                                        ["month"] = month,
                                        ["day"] = day,
                                    })
                                    break
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
ADDON.Events:RegisterCallback("preloadUI", parseLearnedDateFromAchievements, "tracking")