local _, ADDON = ...

local activeMount, activeAuraId

function ADDON:IsPlayerMounted()
    return activeMount ~= nil
end

local function checkAuraData(data, isOnLogin)
    local mountId = C_MountJournal.GetMountFromSpell(data.spellId)
    if mountId then
        activeMount = mountId
        activeAuraId = data.auraInstanceID
        ADDON.Events:TriggerEvent("OnMountUp", activeMount, isOnLogin)
        return true
    end
end

local function scanAuras(isOnLogin)
    local continuationToken, aura1, aura2, aura3, aura4, aura5
    repeat
        continuationToken, aura1, aura2, aura3, aura4, aura5 = C_UnitAuras.GetAuraSlots("player", "HELPFUL|CANCELABLE", 5, continuationToken)
        if aura1 and checkAuraData(C_UnitAuras.GetAuraDataBySlot("player", aura1), isOnLogin) then
            break
        end
        if aura2 and checkAuraData(C_UnitAuras.GetAuraDataBySlot("player", aura2), isOnLogin) then
            break
        end
        if aura3 and checkAuraData(C_UnitAuras.GetAuraDataBySlot("player", aura3), isOnLogin) then
            break
        end
        if aura4 and checkAuraData(C_UnitAuras.GetAuraDataBySlot("player", aura4), isOnLogin) then
            break
        end
        if aura5 and checkAuraData(C_UnitAuras.GetAuraDataBySlot("player", aura5), isOnLogin) then
            break
        end
    until continuationToken == nil
end

ADDON.Events:RegisterCallback("OnLogin", function()
    scanAuras(true)

    ADDON.Events:RegisterFrameEventAndCallback("UNIT_AURA", function(_, target, updateInfo)
        if target == "player" then
            if updateInfo.isFullUpdate then
                scanAuras(false)
            end
            if updateInfo.addedAuras then
                for _, addedAuraData in pairs(updateInfo.addedAuras) do
                    if checkAuraData(addedAuraData) then
                        break
                    end
                end
            end
            if updateInfo.removedAuraInstanceIDs and tContains(updateInfo.removedAuraInstanceIDs, activeAuraId) then
                local mountId = activeMount
                activeMount = nil
                activeAuraId = nil
                ADDON.Events:TriggerEvent("OnMountDown", mountId)
            end
        end
    end, 'external events')

    ADDON.Events:RegisterFrameEventAndCallback("NEW_MOUNT_ADDED", function(_, ...)
        local param1, param2, param3 = ...
        C_Timer.After(1, function() -- mount infos are not properly updated in current frame
            ADDON:FilterMounts()
            ADDON.Events:TriggerEvent("OnNewMount", param1, param2, param3)
        end)
    end, 'external events')
end, 'external events')