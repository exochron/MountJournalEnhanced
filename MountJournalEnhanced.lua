local ADDON_NAME, ADDON = ...

-- see: https://www.townlong-yak.com/framexml/ptr/CallbackRegistry.lua
ADDON.Events = CreateFromMixins(CallbackRegistryMixin)
ADDON.Events:OnLoad()
ADDON.Events:SetUndefinedEventsAllowed(true)

local function InitUI()
    local frame = CreateFrame("frame")
    frame:RegisterEvent("ZONE_CHANGED")
    frame:RegisterEvent("ZONE_CHANGED_INDOORS")
    frame:RegisterEvent("MOUNT_JOURNAL_USABILITY_CHANGED")
    frame:RegisterEvent("MOUNT_JOURNAL_SEARCH_UPDATED")
    frame:SetScript("OnEvent", function()
        if CollectionsJournal:IsShown() then
            ADDON:FilterMounts()
        end
    end);

    MountJournal.searchBox:SetScript("OnTextChanged", function()
        SearchBoxTemplate_OnTextChanged(MountJournal.searchBox)
        ADDON:FilterMounts()
    end)
end

function ADDON:ResetIngameFilter()
    -- reset default filter settings
    C_MountJournal.SetCollectedFilterSetting(LE_MOUNT_JOURNAL_FILTER_COLLECTED, true)
    C_MountJournal.SetCollectedFilterSetting(LE_MOUNT_JOURNAL_FILTER_NOT_COLLECTED, true)
    C_MountJournal.SetCollectedFilterSetting(LE_MOUNT_JOURNAL_FILTER_UNUSABLE, true)
    C_MountJournal.SetAllSourceFilters(true)
    C_MountJournal.SetSearch("")
    C_MountJournal.SetAllTypeFilters(true)
end
ADDON:ResetIngameFilter()

local loggedIn = false
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

    if not loggedIn and IsLoggedIn() then
        loggedIn = true
        ADDON:ResetIngameFilter()
        ADDON.Events:TriggerEvent("OnInit")
        ADDON.Events:TriggerEvent("OnLogin")
        ADDON.Events:UnregisterEvents({"OnInit", "OnLogin"})
    end

    if event == "NEW_MOUNT_ADDED" then
        local param1, param2, param3 = ...
        C_Timer.After(1, function() -- mount infos are not properly updated in current frame
            ADDON:FilterMounts()
            ADDON.Events:TriggerEvent("OnNewMount", param1, param2, param3)
        end)
    end
end)

EventRegistry:RegisterCallback("MountJournal.OnShow", function()
    -- MountJournal gets always initially shown before switching to the actual tab.
    if CollectionsJournal.selectedTab == COLLECTIONS_JOURNAL_TAB_INDEX_MOUNTS and not ADDON.initialized then
        EventRegistry:UnregisterCallback("MountJournal.OnShow", ADDON_NAME)
        InitUI()
        ADDON.initialized = true

        ADDON.Events:TriggerEvent("preloadUI")
        ADDON.Events:TriggerEvent("loadUI")
        ADDON.Events:TriggerEvent("postloadUI")
        ADDON.Events:UnregisterEvents({"preloadUI", "loadUI", "postloadUI"})

        if ADDON.Api:GetSelected() == nil then
            local dataprovider = MountJournal.ScrollBox:GetDataProvider()
            if dataprovider:GetSize() > 0 then
                ADDON.Api:SetSelected(dataprovider:Find(1).mountID)
            end
        end
    end
end, ADDON_NAME)

-- skip dragonriding order helptip
C_CVar.SetCVarBitfield("closedInfoFrames", LE_FRAME_TUTORIAL_MOUNT_COLLECTION_DRAGONRIDING, true)