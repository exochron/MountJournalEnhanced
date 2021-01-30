local ADDON_NAME, ADDON = ...

--region callbacks
local loginCallbacks, loadUICallbacks = {}, {}
function ADDON:RegisterLoginCallback(func)
    table.insert(loginCallbacks, func)
end
function ADDON:RegisterLoadUICallback(func)
    table.insert(loadUICallbacks, func)
end
local function FireCallbacks(callbacks)
    for _, callback in pairs(callbacks) do
        callback()
    end
end
--endregion

local function LoadUI()
    ADDON:UpdateIndex()

    local frame = CreateFrame("frame");
    frame:RegisterEvent("ZONE_CHANGED")
    frame:RegisterEvent("ZONE_CHANGED_INDOORS")
    frame:RegisterEvent("MOUNT_JOURNAL_USABILITY_CHANGED")
    frame:RegisterEvent("MOUNT_JOURNAL_SEARCH_UPDATED")
    frame:SetScript("OnEvent", function(sender, ...)
        if CollectionsJournal:IsShown() then
            ADDON:UpdateIndex(true)
            ADDON:UpdateMountList()
        end
    end);

    MountJournal.searchBox:SetScript("OnTextChanged", function()
        SearchBoxTemplate_OnTextChanged(MountJournal.searchBox)
        ADDON:UpdateIndex(true)
        ADDON:UpdateMountList()
    end)
end

local function ResetIngameFilter()
    -- reset default filter settings
    C_MountJournal.SetCollectedFilterSetting(LE_MOUNT_JOURNAL_FILTER_COLLECTED, true)
    C_MountJournal.SetCollectedFilterSetting(LE_MOUNT_JOURNAL_FILTER_NOT_COLLECTED, true)
    C_MountJournal.SetCollectedFilterSetting(LE_MOUNT_JOURNAL_FILTER_UNUSABLE, true)
    C_MountJournal.SetAllSourceFilters(true)
    C_MountJournal.SetSearch("")
end
ResetIngameFilter()

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function(self, event, arg1)
    ResetIngameFilter()
    FireCallbacks(loginCallbacks)
end)

EventRegistry:RegisterCallback("MountJournal.OnShow", function()
    EventRegistry:UnregisterCallback("MountJournal.OnShow", ADDON_NAME .. ".init")
    LoadUI()
    FireCallbacks(loadUICallbacks)
    ADDON.initialized = true
end, ADDON_NAME .. ".init")