local _, ADDON = ...

local activeMount

function ADDON:IsPlayerMounted()
    return activeMount ~= nil
end

local function checkAuraData(spellId)
    local mountId = C_MountJournal.GetMountFromSpell(spellId)
    if mountId then
        activeMount = mountId
        ADDON.Events:TriggerEvent("OnMountUp", mountId)
        return mountId
    end
end

local function scanAuras()
    for i = 1, 2000 do
        local spellId = select(10, UnitBuff("player", i, "HELPFUL|CANCELABLE"))
        if nil == spellId then
            return nil
        end

        local mountId = checkAuraData(spellId)
        if mountId then
            return mountId
        end
    end

    return nil
end

ADDON.Events:RegisterCallback("OnLogin", scanAuras, 'external events')

ADDON.Events:RegisterFrameEventAndCallback("UNIT_AURA", function(_, target)
    if target == "player" then
        local currentMount = activeMount
        local mountId = scanAuras()
        if currentMount and nil == mountId then
            activeMount = nil
            ADDON.Events:TriggerEvent("OnMountDown", currentMount)
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