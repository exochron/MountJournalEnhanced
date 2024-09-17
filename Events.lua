local _, ADDON = ...

local activeMount, activeAuraId

function ADDON:IsPlayerMounted()
    return activeMount ~= nil
end


local function triggerEvents(unit, isOnLogin, mountId, auraInstanceID)
    if mountId then
        if unit == "player" then
            activeMount = mountId
            activeAuraId = auraInstanceID
            ADDON.Events:TriggerEvent("OnMountUp", activeMount, isOnLogin)
        elseif unit == "target" then
            ADDON.Events:TriggerEvent("OnMountUpTarget", mountId)
        end
    end
end

local function checkAuras(auras)
    for _, aura in ipairs(auras) do
        if aura then
            local mountId = C_MountJournal.GetMountFromSpell(aura.spellId)
            if mountId then
                return mountId, aura.auraInstanceID
            end
        end
    end
end

local function scanAuras(unit)
    local continuationToken, aura1, aura2, aura3, aura4, aura5
    repeat
        continuationToken, aura1, aura2, aura3, aura4, aura5 = C_UnitAuras.GetAuraSlots(unit, "HELPFUL|CANCELABLE", 5, continuationToken)
        local mountId, auraInstanceID = checkAuras({
            aura1 and C_UnitAuras.GetAuraDataBySlot(unit, aura1),
            aura2 and C_UnitAuras.GetAuraDataBySlot(unit, aura2),
            aura3 and C_UnitAuras.GetAuraDataBySlot(unit, aura3),
            aura4 and C_UnitAuras.GetAuraDataBySlot(unit, aura4),
            aura5 and C_UnitAuras.GetAuraDataBySlot(unit, aura5),
        })
        if mountId then
            return mountId, auraInstanceID
        end
    until continuationToken == nil
end

ADDON.Events:RegisterCallback("OnLogin", function()
    triggerEvents("player", true,  scanAuras("player"))

    ADDON.Events:RegisterFrameEventAndCallback("UNIT_AURA", function(_, target, updateInfo)
        if target == "player" or target == "target" then
            if updateInfo.isFullUpdate then
                triggerEvents(target, false,  scanAuras(target))
            end
            if updateInfo.addedAuras then
                triggerEvents(target, false, checkAuras(updateInfo.addedAuras))
            end
            if target == "player" and updateInfo.removedAuraInstanceIDs and tContains(updateInfo.removedAuraInstanceIDs, activeAuraId) then
                local mountId = activeMount
                activeMount = nil
                activeAuraId = nil
                ADDON.Events:TriggerEvent("OnMountDown", mountId)
            end
        end
    end, 'external events')

    ADDON.Events:RegisterFrameEventAndCallback("PLAYER_TARGET_CHANGED", function()
        C_Timer.After(0, function()
            triggerEvents("target", false,  scanAuras("target"))
        end)
    end, 'external events')

    ADDON.Events:RegisterFrameEventAndCallback("NEW_MOUNT_ADDED", function(_, ...)
        local param1, param2, param3 = ...
        C_Timer.After(1, function() -- mount infos are not properly updated in current frame
            ADDON:FilterMounts()
            ADDON.Events:TriggerEvent("OnNewMount", param1, param2, param3)
        end)
    end, 'external events')
end, 'external events')