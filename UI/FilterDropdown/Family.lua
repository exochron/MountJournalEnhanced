local _, ADDON = ...

if not MenuUtil then -- modern style filter menu does not exist. use legacy UIDropdownMenu instead
    return
end

local function CheckSetting(settings)
    local hasTrue, hasFalse = false, false
    for _, v in pairs(settings) do
        if v == true then
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

function ADDON.UI.FDD:AddFamilyMenu(root)
    local L = ADDON.L

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
            local subMenu = root:CreateCheckbox(L[family] or family, function()
                local settingHasTrue, settingHasFalse = CheckSetting(settings[family])

                return settingHasTrue
            end, function(...)
                local _, settingHasFalse = CheckSetting(settings[family])
                ADDON.UI.FDD:SetAllSubFilters(settings[family], settingHasFalse)

                return MenuResponse.Refresh
            end)
            subMenu:AddInitializer(function(button)
                if button.leftTexture2 then
                    local settingHasTrue, settingHasFalse = CheckSetting(settings[family])
                    if settingHasTrue and settingHasFalse then
                        -- TODO: proper indeterminate icon. like: https://css-tricks.com/indeterminate-checkboxes/
                        button.leftTexture2:SetAtlas("common-dropdown-icon-radialtick-yellow-classic", TextureKitConstants.UseAtlasSize)
                        button.leftTexture2:SetAtlas("common-dropdown-icon-radialtick-yellow", TextureKitConstants.UseAtlasSize)
                    else
                        button.leftTexture2:SetAtlas("common-dropdown-icon-checkmark-yellow-classic", TextureKitConstants.UseAtlasSize)
                        button.leftTexture2:SetAtlas("common-dropdown-icon-checkmark-yellow", TextureKitConstants.UseAtlasSize)
                    end
                end
            end)
            local sortedSubFamilies = {}
            for subfamily, familyIds in pairs(ADDON.DB.Family[family]) do
                table.insert(sortedSubFamilies, subfamily)
            end
            table.sort(sortedSubFamilies, function(a, b)
                return (L[a] or a) < (L[b] or b)
            end)
            for _, subfamily in pairs(sortedSubFamilies) do
                ADDON.UI.FDD:CreateFilter(subMenu, L[subfamily] or subfamily, subfamily, settings[family], settings)
            end

        else
            ADDON.UI.FDD:CreateFilter(root, L[family] or family, family, settings, true)
        end
    end
end