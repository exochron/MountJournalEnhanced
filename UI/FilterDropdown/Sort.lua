local ADDON_NAME, ADDON = ...
local L = ADDON.L

local function CreateFilterRadio(text, filterValue)
    local info = ADDON.UI.FDD:CreateFilterInfo(text, "by", ADDON.settings.sort)
    info.isNotRadio = false
    info.arg2 = filterValue
    info.checked = function(self)
        return self.arg1["by"] == filterValue
    end
    info.func = function(_, arg1, arg2)
        arg1["by"] = arg2
        ADDON:UpdateProviderSort()
        UIDropDownMenu_RefreshAll(_G[ADDON_NAME .. "FilterMenu"])
    end

    return info
end

local function CreateSortCheckbox(text, sortKey)
    local info = ADDON.UI.FDD:CreateFilterInfo(text, sortKey, ADDON.settings.sort)
    info.func = function(_, arg1, _, value)
        arg1[sortKey] = value
        MountJournal.ScrollBox:GetView():GetDataProvider():Sort()
        UIDropDownMenu_RefreshAll(_G[ADDON_NAME .. "FilterMenu"])
    end

    return info
end

function ADDON.UI.FDD:AddSortMenu(level)
    UIDropDownMenu_AddButton(CreateFilterRadio(NAME, 'name'), level)
    UIDropDownMenu_AddButton(CreateFilterRadio(TYPE, 'type'), level)
    UIDropDownMenu_AddButton(CreateFilterRadio(EXPANSION_FILTER_TEXT, 'expansion'), level)

    local trackingEnabled = ADDON.settings.trackUsageStats
    local info = CreateFilterRadio(L.SORT_BY_USAGE_COUNT, 'usage_count')
    info.disabled = not trackingEnabled
    UIDropDownMenu_AddButton(info, level)
    info = CreateFilterRadio(L.SORT_BY_LAST_USAGE, 'last_usage')
    info.disabled = not trackingEnabled
    UIDropDownMenu_AddButton(info, level)
    info = CreateFilterRadio(L.SORT_BY_LEARNED_DATE, 'learned_date')
    info.disabled = not trackingEnabled
    UIDropDownMenu_AddButton(info, level)
    info = CreateFilterRadio(L.SORT_BY_TRAVEL_DURATION, 'travel_duration')
    info.disabled = not trackingEnabled
    UIDropDownMenu_AddButton(info, level)
    info = CreateFilterRadio(L.SORT_BY_TRAVEL_DISTANCE, 'travel_distance')
    info.disabled = not trackingEnabled
    UIDropDownMenu_AddButton(info, level)

    UIDropDownMenu_AddSpace(level)
    UIDropDownMenu_AddButton(CreateSortCheckbox(L.SORT_REVERSE, 'descending'), level)
    UIDropDownMenu_AddButton(CreateSortCheckbox(L.SORT_FAVORITES_FIRST, 'favoritesOnTop'), level)
    UIDropDownMenu_AddButton(CreateSortCheckbox(L.SORT_UNUSABLE_BOTTOM, 'unusableToBottom'), level)
    UIDropDownMenu_AddButton(CreateSortCheckbox(L.SORT_UNOWNED_BOTTOM, 'unownedOnBottom'), level)
    UIDropDownMenu_AddSpace(level)

    info = ADDON.UI.FDD:CreateFilterInfo(NEWBIE_TOOLTIP_STOPWATCH_RESETBUTTON)
    info.justifyH = "CENTER"
    info.keepShownOnClick = false
    info.func = function()
        ADDON:ResetSortSettings()
        ADDON:UpdateProviderSort()
    end
    UIDropDownMenu_AddButton(info, level)
end