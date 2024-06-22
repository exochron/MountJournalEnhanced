local _, ADDON = ...

if MenuUtil then -- modern style filter menu
    return
end

local L = ADDON.L

local function CheckSetting(settings)
    local hasTrue, hasFalse = false, false
    for _, v in pairs(settings) do
        if (v == true) then
            hasTrue = true
        elseif v == false then
            hasFalse = true
        end
        if hasTrue and hasFalse then
            break
        end
    end

    return hasTrue, hasFalse
end

local function RefreshCategoryButton(button, isNotRadio)
    local buttonName = button:GetName()
    local buttonCheck = _G[buttonName .. "Check"]

    if isNotRadio then
        buttonCheck:SetTexCoord(0.0, 0.5, 0.0, 0.5);
    else
        buttonCheck:SetTexCoord(0.0, 0.5, 0.5, 1.0);
    end

    button.isNotRadio = isNotRadio
end

local function CreateInfoWithMenu(text, filterKey, settings)
    local info = {
        text = text,
        value = filterKey,
        keepShownOnClick = true,
        notCheckable = false,
        hasArrow = true,
    }

    local hasTrue, hasFalse = CheckSetting(settings)
    info.isNotRadio = not hasTrue or not hasFalse

    info.checked = function(button)
        local settingHasTrue, settingHasFalse = CheckSetting(settings)
        RefreshCategoryButton(button, not settingHasTrue or not settingHasFalse)
        return settingHasTrue
    end
    info.func = function(button, _, _, value)
        if button.isNotRadio == value then
            ADDON.UI.FDD:SetAllSubFilters(settings, true)
        elseif true == button.isNotRadio and false == value then
            ADDON.UI.FDD:SetAllSubFilters(settings, false)
        end
    end

    return info
end

function ADDON.UI.FDD:AddFamilyMenu(level)
    local settings = ADDON.settings.filter.family
    local sortedFamilies, hasSubFamilies = {}, {}

    for family, mainConfig in pairs(ADDON.DB.Family) do
        hasSubFamilies[family] = false
        for _, subConfig in pairs(mainConfig) do
            if type(subConfig) == "table" then
                hasSubFamilies[family] = true
            else
                break
            end
        end
        table.insert(sortedFamilies, family)
    end
    table.sort(sortedFamilies, function(a, b)
        return (L[a] or a) < (L[b] or b)
    end)

    for _, family in pairs(sortedFamilies) do
        if hasSubFamilies[family] then
            UIDropDownMenu_AddButton(CreateInfoWithMenu(L[family] or family, family, settings[family]), level)
        else
            UIDropDownMenu_AddButton(ADDON.UI.FDD:CreateFilterInfo(L[family] or family, family, settings, true), level)
        end
    end
end

local function ShouldDisplayFamily(mountIds)
    if ADDON.settings.filter.hiddenIngame then
        return true
    end

    for mountId, _ in pairs(mountIds) do
        local _, _, _, _, _, _, _, _, _, shouldHideOnChar = C_MountJournal.GetMountInfoByID(mountId)
        if shouldHideOnChar == false then
            return true
        end
    end

    return false
end

function ADDON.UI.FDD:AddFamilySubMenu(level, filterValue)
    local settings = ADDON.settings.filter.family[filterValue]
    local sortedFamilies = {}
    for family, familyIds in pairs(ADDON.DB.Family[filterValue]) do
        if ShouldDisplayFamily(familyIds) then
            table.insert(sortedFamilies, family)
        end
    end
    table.sort(sortedFamilies, function(a, b)
        return (L[a] or a) < (L[b] or b)
    end)
    for _, family in pairs(sortedFamilies) do
        UIDropDownMenu_AddButton(ADDON.UI.FDD:CreateFilterInfo(L[family] or family, family, settings, ADDON.settings.filter.family), level)
    end
end