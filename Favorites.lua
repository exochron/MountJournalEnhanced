local _, ADDON = ...

local TICKER_INTERVAL = 0.3333
local backgroundTimer

local function IsFavorite(mountId)
    local _, _, _, _, _, _, isFavorite = C_MountJournal.GetMountInfoByID(mountId)
    return isFavorite
end

local function collectFavoredByApi(keepIndex)
    ADDON:ResetIngameFilter()

    local c = 0
    local favoredMounts = {}

    local count = C_MountJournal.GetNumDisplayedMounts()
    for index = C_MountJournal.GetNumMountsNeedingFanfare() + 1, count do
        local mountId = C_MountJournal.GetDisplayedMountID(index)
        if IsFavorite(mountId) then
            if keepIndex then
                c = index
            else
                c = c + 1
            end
            favoredMounts[c] = mountId
        else
            break
        end
    end

    return favoredMounts
end

local function processQueue(queue, favorTarget, eventIdentifier, endQueueHandler)
    if not TableIsEmpty(queue) then
        local lastTickMount, tickTryMount = 0, 0
        local tickHandler = function()
            local queueIndex, data = next(queue)
            if data then
                local displayIndex, mountId = unpack(data)
                if lastTickMount == mountId and tickTryMount >= 3 then
                    queue[queueIndex] = nil
                else
                    if lastTickMount == mountId then
                        tickTryMount = tickTryMount + 1
                    else
                        lastTickMount = mountId
                        tickTryMount = 1
                    end

                    if IsFavorite(mountId) == favorTarget then
                        queue[queueIndex] = nil
                    else
                        C_MountJournal.SetIsFavorite(displayIndex, favorTarget)
                    end
                end
            end

            if TableIsEmpty(queue) then
                endQueueHandler()
            end
        end

        ADDON.Events:RegisterFrameEventAndCallback("MOUNT_JOURNAL_SEARCH_UPDATED", function()
            local queueIndex, data = next(queue)
            if data and IsFavorite(data[2]) == favorTarget then
                queue[queueIndex] = nil
            end

            if TableIsEmpty(queue) then
                endQueueHandler()
            end
        end, eventIdentifier)

        backgroundTimer = C_Timer.NewTicker(TICKER_INTERVAL, tickHandler)
    end
end

local function cancelUnfavorBackgroundTask()
    if backgroundTimer then
        backgroundTimer:Cancel()
    end
    ADDON.Events:UnregisterFrameEventAndCallback("MOUNT_JOURNAL_SEARCH_UPDATED", 'cleanup-unfavorite-background')
end
local function cancelFavorBackgroundTask()
    if backgroundTimer then
        backgroundTimer:Cancel()
    end
    ADDON.Events:UnregisterFrameEventAndCallback("MOUNT_JOURNAL_SEARCH_UPDATED", 'cleanup-favorite-background')
end

local function startFavoring(mountIdsToFavor)
    if backgroundTimer then
        backgroundTimer:Cancel()
    end

    ADDON:ResetIngameFilter()

    local favorQueue = {}
    local queueCount = 0

    local count = C_MountJournal.GetNumDisplayedMounts()
    for index = C_MountJournal.GetNumMountsNeedingFanfare() + 1, count do
        local mountId = C_MountJournal.GetDisplayedMountID(index)
        local _, _, _, _, _, _, isFavorite, _, _, _, isCollected = C_MountJournal.GetMountInfoByID(mountId)
        if mountIdsToFavor[mountId] and not isFavorite then
            queueCount = queueCount + 1
            favorQueue[queueCount] = {[1] = index, [2] = mountId}
        elseif not isCollected then
            break
        end
    end

    processQueue(favorQueue, true, 'cleanup-favorite-background', cancelFavorBackgroundTask)
end
local function UpdateFavoritesInBackground()
    cancelFavorBackgroundTask()
    cancelUnfavorBackgroundTask()

    local numFanfareCount = C_MountJournal.GetNumMountsNeedingFanfare()
    local _, _ , favorites = ADDON.Api:GetFavoriteProfile()
    favorites = tFilter(favorites, function(mountId)
        local _, _, _, _, _, _, _, _, _, shouldHideOnChar = C_MountJournal.GetMountInfoByID(mountId)
        if not shouldHideOnChar and (numFanfareCount == 0 or not C_MountJournal.NeedsFanfare(mountId)) then
            return true
        end

        return false
    end, true)

    local flippedFavorites = {}
    for _, v in pairs(favorites) do -- CopyValuesAsKeys() somehow created faulty list
        flippedFavorites[v] = true
    end
    favorites = nil

    local favoredByApi = collectFavoredByApi(true)
    local unfavorQueue = {}
    local unfavorCount = 0

    for displayIndex, mountId in pairs(favoredByApi) do
        if flippedFavorites[mountId] then
            flippedFavorites[mountId] = nil
        else
            unfavorCount = unfavorCount + 1
            unfavorQueue[unfavorCount] = {[1]=displayIndex, [2]=mountId}
        end
    end
    favoredByApi = nil

    if unfavorCount > 0 then
        -- reverse order of unfavorQueue
        local halfQueueCount = math.floor(unfavorCount/2)
        for leftIndex = 1, halfQueueCount do
            local rightIndex = unfavorCount - leftIndex
            local tmp = unfavorQueue[rightIndex]
            unfavorQueue[rightIndex] = unfavorQueue[leftIndex]
            unfavorQueue[leftIndex] = tmp
        end

        processQueue(unfavorQueue, false, 'cleanup-unfavorite-background', function()
            cancelUnfavorBackgroundTask()
            startFavoring(flippedFavorites)
        end)
    else
        startFavoring(flippedFavorites)
    end
end

ADDON.Events:RegisterCallback("OnNewMount", function(_, mountId)
    local currentProfile = ADDON.Api:GetFavoriteProfile()

    local tInsert = table.insert
    for index, profileData in pairs(ADDON.settings.favorites.profiles) do
        if profileData and profileData.autoFavor then
            if index == currentProfile then
                ADDON.Api:SetIsFavoriteByID(mountId, true)
            elseif not tContains(profileData.mounts, mountId) then
                tInsert(profileData.mounts, mountId)
            end
        end
    end
end, "autoFavor")

ADDON.Events:RegisterCallback("OnLogin", function()
    local profileIndex, _ , favorites = ADDON.Api:GetFavoriteProfile()
    -- initial scan for account profile
    if 1 == profileIndex and not ADDON.settings.favorites.profiles[1].initialScan then
        ADDON.settings.favorites.profiles[1].initialScan = true
        if 0 == #favorites then
            ADDON.Api:SetBulkIsFavorites(collectFavoredByApi())
        end
    else
        UpdateFavoritesInBackground()
    end
end, "favorite hooks")

ADDON.Events:RegisterCallback("OnFavoritesChanged", function()
    ADDON.Api:GetDataProvider():Sort()

    UpdateFavoritesInBackground()
end, "sort dataprovider")