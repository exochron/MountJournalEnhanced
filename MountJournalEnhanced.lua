local ADDON_NAME, ADDON = ...

-- see: https://www.townlong-yak.com/framexml/ptr/CallbackRegistry.lua
ADDON.Events = CreateFromMixins(EventRegistry)
ADDON.Events:OnLoad()
ADDON.Events:SetUndefinedEventsAllowed(true)

local function InitUI()
    local updateUI = function ()
        if CollectionsJournal:IsShown() then
            ADDON:FilterMounts()
        end
    end
    ADDON.Events:RegisterFrameEventAndCallback("ZONE_CHANGED", updateUI, 'init')
    ADDON.Events:RegisterFrameEventAndCallback("ZONE_CHANGED_INDOORS", updateUI, 'init')
    ADDON.Events:RegisterFrameEventAndCallback("MOUNT_JOURNAL_USABILITY_CHANGED", updateUI, 'init')
    ADDON.Events:RegisterFrameEventAndCallback("MOUNT_JOURNAL_SEARCH_UPDATED", updateUI, 'init')

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

local function intersectTableKeys(tbl, keysToKeep)
    local result = {}

    for key, val in pairs(tbl) do
        if type(key) == "string" and type(val) == "table" then
            local subResult = intersectTableKeys(val, keysToKeep)
            if not TableIsEmpty(subResult) then
                result[key] = subResult
            end
        elseif nil ~= keysToKeep[key] then
            result[key] = val
        end
    end

    return result
end
local function CleanupDatabase()
    local mountIds = C_MountJournal.GetMountIDs()
    mountIds = CopyValuesAsKeys(mountIds)
    ADDON.DB.Colors = intersectTableKeys(ADDON.DB.Colors, mountIds)
    ADDON.DB.Customization = intersectTableKeys(ADDON.DB.Customization, mountIds)
    ADDON.DB.Family = intersectTableKeys(ADDON.DB.Family, mountIds)
    ADDON.DB.Restrictions = intersectTableKeys(ADDON.DB.Restrictions, mountIds)
    ADDON.DB.Tradable = intersectTableKeys(ADDON.DB.Tradable, mountIds)
end

local loggedIn = false
local function initialize()
    if MountJournal then
        ADDON.Events:UnregisterFrameEvent("ADDON_LOADED")
        ADDON.Events:TriggerEvent("OnJournalLoaded")
        ADDON.Events:UnregisterEvents({"OnJournalLoaded"})
    end

    if not loggedIn and IsLoggedIn() then
        loggedIn = true
        CleanupDatabase()
        ADDON:ResetIngameFilter()
        ADDON.Events:TriggerEvent("OnInit")
        ADDON.Events:TriggerEvent("OnLogin")
        ADDON.Events:UnregisterEvents({"OnInit", "OnLogin"})
    end
end
ADDON.Events:RegisterFrameEventAndCallback("PLAYER_LOGIN", function()
    -- delay by a frame, because GetServerExpansionLevel() can return 0 on first login
    C_Timer.After(0, function()
        initialize()
        if not MountJournal then
            ADDON.Events:RegisterFrameEventAndCallback("ADDON_LOADED", initialize, 'init')
        end
    end)
end, 'init')

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

        local selected = ADDON.Api:GetSelected()
        if selected == nil or selected == select(12, C_MountJournal.GetDisplayedMountInfo(1)) then
            local dataprovider = ADDON.Api:GetDataProvider()
            if dataprovider:GetSize() > 0 then
                ADDON.Api:SetSelected(dataprovider:Find(1).mountID)
            end
        end
    end
end, ADDON_NAME)

-- skip dragonriding order helptip
if LE_FRAME_TUTORIAL_MOUNT_COLLECTION_DRAGONRIDING then
    C_CVar.SetCVarBitfield("closedInfoFrames", LE_FRAME_TUTORIAL_MOUNT_COLLECTION_DRAGONRIDING, true)
end
