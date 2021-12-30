local _, ADDON = ...
local L = ADDON.L

local function CreateFilterRadio(text, filterKey, filterSettings, filterValue)
    local info = ADDON.UI.FDD:CreateFilterInfo(text, filterKey, filterSettings)
    info.isNotRadio = false
    info.arg2 = filterValue
    info.checked = function(self)
        return self.arg1[filterKey] == filterValue
    end

    return info
end

function ADDON.UI.FDD:AddSortMenu(level)
    local settings = ADDON.settings.sort
    UIDropDownMenu_AddButton(CreateFilterRadio(NAME, "by", settings, 'name'), level)
    UIDropDownMenu_AddButton(CreateFilterRadio(TYPE, "by", settings, 'type'), level)
    UIDropDownMenu_AddButton(CreateFilterRadio(EXPANSION_FILTER_TEXT, "by", settings, 'expansion'), level)

    local trackingEnabled = ADDON.settings.trackUsageStats
    local info = CreateFilterRadio(L.SORT_BY_USAGE_COUNT, "by", settings, 'usage_count')
    info.disabled = not trackingEnabled
    UIDropDownMenu_AddButton(info, level)
    info = CreateFilterRadio(L.SORT_BY_LAST_USAGE, "by", settings, 'last_usage')
    info.disabled = not trackingEnabled
    UIDropDownMenu_AddButton(info, level)
    info = CreateFilterRadio(L.SORT_BY_LEARNED_DATE, "by", settings, 'learned_date')
    info.disabled = not trackingEnabled
    UIDropDownMenu_AddButton(info, level)
    info = CreateFilterRadio(L.SORT_BY_TRAVEL_DURATION, "by", settings, 'travel_duration')
    info.disabled = not trackingEnabled
    UIDropDownMenu_AddButton(info, level)
    info = CreateFilterRadio(L.SORT_BY_TRAVEL_DISTANCE, "by", settings, 'travel_distance')
    info.disabled = not trackingEnabled
    UIDropDownMenu_AddButton(info, level)

    UIDropDownMenu_AddSpace(level)
    UIDropDownMenu_AddButton(ADDON.UI.FDD:CreateFilterInfo(L.SORT_REVERSE, 'descending', settings), level)
    UIDropDownMenu_AddButton(ADDON.UI.FDD:CreateFilterInfo(L.SORT_FAVORITES_FIRST, 'favoritesOnTop', settings), level)
    UIDropDownMenu_AddButton(ADDON.UI.FDD:CreateFilterInfo(L.SORT_UNUSABLE_BOTTOM, 'unusableToBottom', settings), level)
    UIDropDownMenu_AddButton(ADDON.UI.FDD:CreateFilterInfo(L.SORT_UNOWNED_BOTTOM, 'unownedOnBottom', settings), level)
    UIDropDownMenu_AddSpace(level)

    info = ADDON.UI.FDD:CreateFilterInfo(NEWBIE_TOOLTIP_STOPWATCH_RESETBUTTON)
    info.justifyH = "CENTER"
    info.keepShownOnClick = false
    info.func = function()
        ADDON:ResetSortSettings()
        ADDON.Api:UpdateIndex()
        ADDON.UI:UpdateMountList()
    end
    UIDropDownMenu_AddButton(info, level)
end