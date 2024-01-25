local _, ADDON = ...

local activeMount, activeAuraId

function ADDON:IsPlayerMounted()
    return activeMount ~= nil
end

local function checkAuraData(data)
    local mountId = C_MountJournal.GetMountFromSpell(data.spellId)
    if mountId then
        activeMount = mountId
        activeAuraId = data.auraInstanceID
        ADDON.Events:TriggerEvent("OnMountUp", activeMount)
        return true
    end
end

local function scanAuras()
    local continuationToken, aura1, aura2, aura3, aura4, aura5
    repeat
        continuationToken, aura1, aura2, aura3, aura4, aura5 = C_UnitAuras.GetAuraSlots("player", "HELPFUL|CANCELABLE", 5, continuationToken)
        if aura1 and checkAuraData(C_UnitAuras.GetAuraDataBySlot("player", aura1)) then
            break
        end
        if aura2 and checkAuraData(C_UnitAuras.GetAuraDataBySlot("player", aura2)) then
            break
        end
        if aura3 and checkAuraData(C_UnitAuras.GetAuraDataBySlot("player", aura3)) then
            break
        end
        if aura4 and checkAuraData(C_UnitAuras.GetAuraDataBySlot("player", aura4)) then
            break
        end
        if aura5 and checkAuraData(C_UnitAuras.GetAuraDataBySlot("player", aura5)) then
            break
        end
    until continuationToken == nil
end

ADDON.Events:RegisterCallback("OnLogin", scanAuras, 'external events')

ADDON.Events:RegisterFrameEventAndCallback("UNIT_AURA", function(_, target, updateInfo)
    if target == "player" then
        if updateInfo.isFullUpdate then
            scanAuras()
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