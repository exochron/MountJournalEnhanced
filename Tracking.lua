local ADDON_NAME, ADDON = ...

local INDEX_USE_COUNT, INDEX_USE_TIME, INDEX_TRAVEL_TIME, INDEX_TRAVEL_DISTANCE, INDEX_LEARNED_TIME = 1, 2, 3, 4, 5
local HBD = LibStub("HereBeDragons-2.0")

MJETrackingData = MJETrackingData or {}

-- todos:
--  test distance in instance

local function initData(mountId)
    if not MJETrackingData[mountId] then
        MJETrackingData[mountId] = {
            [INDEX_USE_COUNT] = 0,
            [INDEX_USE_TIME] = nil,
            [INDEX_TRAVEL_TIME] = 0,
            [INDEX_TRAVEL_DISTANCE] = 0,
            [INDEX_LEARNED_TIME] = nil,
        }
    end

    return MJETrackingData[mountId]
end

local currentMount, startZone, startPositionX, startPositionY, travelTicker

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
    blob[INDEX_USE_TIME] = GetServerTime()
    blob[INDEX_USE_COUNT] = blob[INDEX_USE_COUNT] + 1
    startPositionX, startPositionY, startZone = HBD:GetPlayerZonePosition()
    travelTicker = C_Timer.NewTicker(5, updateDistance)
end
local function stopTracking(mount)
    local blob = initData(mount)
    blob[INDEX_TRAVEL_TIME] = blob[INDEX_TRAVEL_TIME] + (GetServerTime() - blob[INDEX_USE_TIME])

    travelTicker:Cancel()
    updateDistance()
    currentMount, startZone, startPositionX, startPositionY = nil, nil, nil, nil
end

local function checkMountEvent(self, evt)
    if currentMount then
        stopTracking(currentMount)
    else
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

ADDON:RegisterLoginCallback(checkMountEvent)