local ADDON_NAME, ADDON = ...

if MenuUtil then -- modern style filter menu
    return
end

local L = ADDON.L

local function CreateSortRadio(text, sortValue)
    local sortSettings = ADDON.settings.sort
    local info = ADDON.UI.FDD:CreateFilterInfo(text, "by", sortSettings)
    info.isNotRadio = false
    info.checked = function()
        return sortSettings["by"] == sortValue
    end
    info.func = function()
        sortSettings["by"] = sortValue
        ADDON.Api:GetDataProvider():Sort()
        UIDropDownMenu_RefreshAll(_G[ADDON_NAME .. "FilterMenu"])
    end

    return info
end

local function CreateSortCheckbox(text, sortKey)
    local sortSettings = ADDON.settings.sort
    local info = ADDON.UI.FDD:CreateFilterInfo(text, sortKey, sortSettings)
    info.func = function(_, _, _, value)
        sortSettings[sortKey] = value
        ADDON.Api:GetDataProvider():Sort()
        UIDropDownMenu_RefreshAll(_G[ADDON_NAME .. "FilterMenu"])
    end

    return info
end

function ADDON.UI.FDD:AddSortMenu(level)
    UIDropDownMenu_AddButton(CreateSortRadio(NAME, 'name'), level)
    UIDropDownMenu_AddButton(CreateSortRadio(TYPE, 'type'), level)
    UIDropDownMenu_AddButton(CreateSortRadio(L.SORT_BY_FAMILY, 'family'), level)
    UIDropDownMenu_AddButton(CreateSortRadio(EXPANSION_FILTER_TEXT, 'expansion'), level)
    if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
        UIDropDownMenu_AddButton(CreateSortRadio(RARITY, 'rarity'), level)
    end

    local trackingEnabled = ADDON.settings.trackUsageStats
    local info = CreateSortRadio(L.SORT_BY_USAGE_COUNT, 'usage_count')
    info.disabled = not trackingEnabled
    UIDropDownMenu_AddButton(info, level)
    info = CreateSortRadio(L.SORT_BY_LAST_USAGE, 'last_usage')
    info.disabled = not trackingEnabled
    UIDropDownMenu_AddButton(info, level)
    info = CreateSortRadio(L.SORT_BY_LEARNED_DATE, 'learned_date')
    info.disabled = not trackingEnabled
    UIDropDownMenu_AddButton(info, level)
    info = CreateSortRadio(L.SORT_BY_TRAVEL_DURATION, 'travel_duration')
    info.disabled = not trackingEnabled
    UIDropDownMenu_AddButton(info, level)
    info = CreateSortRadio(L.SORT_BY_TRAVEL_DISTANCE, 'travel_distance')
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
        ADDON.Api:GetDataProvider():Sort()
    end
    UIDropDownMenu_AddButton(info, level)
end