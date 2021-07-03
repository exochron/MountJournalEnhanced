local ADDON_NAME, ADDON = ...

-- see: https://www.townlong-yak.com/framexml/ptr/CallbackRegistry.lua
ADDON.Events = CreateFromMixins(CallbackRegistryMixin)
ADDON.Events:OnLoad()
ADDON.Events:SetUndefinedEventsAllowed(true)

local function InitUI()
    ADDON.Api:UpdateIndex()

    local frame = CreateFrame("frame")
    frame:RegisterEvent("ZONE_CHANGED")
    frame:RegisterEvent("ZONE_CHANGED_INDOORS")
    frame:RegisterEvent("MOUNT_JOURNAL_USABILITY_CHANGED")
    frame:RegisterEvent("MOUNT_JOURNAL_SEARCH_UPDATED")
    frame:SetScript("OnEvent", function()
        if CollectionsJournal:IsShown() then
            ADDON.Api:UpdateIndex(true)
            ADDON.UI:UpdateMountList()
        end
    end);

    MountJournal.searchBox:SetScript("OnTextChanged", function()
        SearchBoxTemplate_OnTextChanged(MountJournal.searchBox)
        ADDON.Api:UpdateIndex(true)
        ADDON.UI:UpdateMountList()
    end)
end

function ADDON:ResetIngameFilter()
    -- reset default filter settings
    C_MountJournal.SetCollectedFilterSetting(LE_MOUNT_JOURNAL_FILTER_COLLECTED, true)
    C_MountJournal.SetCollectedFilterSetting(LE_MOUNT_JOURNAL_FILTER_NOT_COLLECTED, true)
    C_MountJournal.SetCollectedFilterSetting(LE_MOUNT_JOURNAL_FILTER_UNUSABLE, true)
    C_MountJournal.SetAllSourceFilters(true)
    C_MountJournal.SetSearch("")
end
ADDON:ResetIngameFilter()

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("NEW_MOUNT_ADDED")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(_, event, ...)
    if MountJournal then
        frame:UnregisterEvent("ADDON_LOADED")
        ADDON.Events:TriggerEvent("OnJournalLoaded")
        ADDON.Events:UnregisterEvents({"OnJournalLoaded"})
    end

    if event == "PLAYER_LOGIN" then
        ADDON:ResetIngameFilter()
        ADDON.Events:TriggerEvent("OnInit")
        ADDON.Events:TriggerEvent("OnLogin")
        ADDON.Events:UnregisterEvents({"OnInit", "OnLogin"})
    elseif event == "NEW_MOUNT_ADDED" then
        local param1, param2, param3 = ...
        C_Timer.After(1, function() -- mount infos are not properly updated in current frame
            ADDON.Events:TriggerEvent("OnNewMount", param1, param2, param3)
            ADDON.Api:UpdateIndex()
        end)
    end
end)

EventRegistry:RegisterCallback("MountJournal.OnShow", function()
    -- MountJournal gets always initially shown before switching to the actual tab.
    if CollectionsJournal.selectedTab == 1 and not ADDON.initialized then
        EventRegistry:UnregisterCallback("MountJournal.OnShow", ADDON_NAME)
        InitUI()
        ADDON.initialized = true

        ADDON.Events:TriggerEvent("preloadUI")
        ADDON.Events:TriggerEvent("loadUI")
        ADDON.Events:TriggerEvent("postloadUI")
        ADDON.Events:UnregisterEvents({"preloadUI", "loadUI", "postloadUI"})

        if ADDON.Api:GetSelected() == nil then
            ADDON.Api:SetSelected(select(12, ADDON.Api:GetDisplayedMountInfo(1)))
        end
    end
end, ADDON_NAME)
