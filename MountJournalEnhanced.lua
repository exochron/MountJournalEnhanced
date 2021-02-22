local ADDON_NAME, ADDON = ...

-- see: https://www.townlong-yak.com/framexml/ptr/CallbackRegistry.lua
ADDON.Events = CreateFromMixins(CallbackRegistryMixin)
ADDON.Events:OnLoad()
ADDON.Events:SetUndefinedEventsAllowed(true)

local function LoadUI()
    ADDON.Api:UpdateIndex()

    local frame = CreateFrame("frame");
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
        ADDON.Events:TriggerEvent("checkTaint", "pre-init")
        ADDON.Events:TriggerEvent("OnInit")
        ADDON.Events:TriggerEvent("checkTaint", "pre-login")
        ADDON.Events:TriggerEvent("OnLogin")
        ADDON.Events:TriggerEvent("checkTaint", "post-login")
    elseif event == "NEW_MOUNT_ADDED" then
        ADDON.Api:UpdateIndex()
        ADDON.Events:TriggerEvent("checkTaint", "pre-newMount")
        ADDON.Events:TriggerEvent("OnNewMount", ...)
        ADDON.Events:TriggerEvent("checkTaint", "post-newMount")
    end
end)

hooksecurefunc(EventRegistry, "TriggerEvent", function(self, event)
    if event == "MountJournal.OnShow" then
        -- MountJournal gets always initially shown before switching to the actual tab.
        if CollectionsJournal.selectedTab == 1 and not ADDON.initialized then
            LoadUI()
            ADDON.initialized = true

            ADDON.Events:TriggerEvent("checkTaint", "pre preloadUI")
            ADDON.Events:TriggerEvent("preloadUI")
            ADDON.Events:TriggerEvent("checkTaint", "pre loadUI")
            ADDON.Events:TriggerEvent("loadUI")
            ADDON.Events:TriggerEvent("checkTaint", "pre postloadUI")
            ADDON.Events:TriggerEvent("postloadUI")
            ADDON.Events:TriggerEvent("checkTaint", "post postloadUI")

            if ADDON.Api:GetSelected() == nil then
                ADDON.Api:SetSelected(select(12, ADDON.Api:GetDisplayedMountInfo(1)))
            end
        end
    end
end)
-- Why not to use EventRegistry:RegisterCallback() :
-- Every third party Handler will introduce taint in the subsequent process. Although the event is triggered at the end
-- of OnShow, there can still be an automatic mount selection or something else, which will be tainted as well.