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
    frame:SetScript("OnEvent", function(sender, ...)
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
frame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        ADDON:ResetIngameFilter()
        ADDON.Events:TriggerEvent("OnInit")
        --ADDON.Debug:CheckListTaint("pre-login")
        ADDON.Events:TriggerEvent("OnLogin")
        --ADDON.Debug:CheckListTaint("post-login")
        ADDON.Events:UnregisterAllCallbacksByEvent("OnInit")
        ADDON.Events:UnregisterAllCallbacksByEvent("OnLogin")
    elseif event == "NEW_MOUNT_ADDED" then
        ADDON.Api:UpdateIndex()
        --ADDON.Debug:CheckListTaint("pre-newMount")
        ADDON.Events:TriggerEvent("OnNewMount", ...)
        --ADDON.Debug:CheckListTaint("post-newMount")
    end
end)

EventRegistry:RegisterCallback("MountJournal.OnShow", function()
    -- MountJournal gets always initially shown before switching to the actual tab.
    if CollectionsJournal.selectedTab == 1 and not ADDON.initialized then
        EventRegistry:UnregisterCallback("MountJournal.OnShow", ADDON_NAME)
        InitUI()
        ADDON.initialized = true

        --ADDON.Debug:CheckListTaint("pre preloadUI")
        ADDON.Events:TriggerEvent("preloadUI")
        --ADDON.Debug:CheckListTaint("pre loadUI")
        ADDON.Events:TriggerEvent("loadUI")
        --ADDON.Debug:CheckListTaint("pre postloadUI")
        ADDON.Events:TriggerEvent("postloadUI")
        --ADDON.Debug:CheckListTaint("post postloadUI")

        ADDON.Events:UnregisterAllCallbacksByEvent("preloadUI")
        ADDON.Events:UnregisterAllCallbacksByEvent("loadUI")
        ADDON.Events:UnregisterAllCallbacksByEvent("postloadUI")

        if ADDON.Api:GetSelected() == nil then
            ADDON.Api:SetSelected(select(12, ADDON.Api:GetDisplayedMountInfo(1)))
        end
    end
end, ADDON_NAME)
