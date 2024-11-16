local _, ADDON = ...

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

local function AddIcon(menuButton, family, subfamily)
    local sourceDb = subfamily and ADDON.DB.Family[family][subfamily] or ADDON.DB.Family[family]
    local mountId = TableUtil.FindMin(GetKeysArray(sourceDb), function(v) return v end)
    local _, _, icon = C_MountJournal.GetMountInfoByID(mountId)
    ADDON.UI.FDD:AddIcon(menuButton, icon)
end

function ADDON.UI.FDD:AddFamilyMenu(root)
    local L = ADDON.L
    local tInsert = table.insert

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
        tInsert(sortedFamilies, family)
    end
    table.sort(sortedFamilies, function(a, b)
        return (L[a] or a) < (L[b] or b)
    end)

    for _, family in pairs(sortedFamilies) do
        if hasSubFamilies[family] then
            local subMenu = root:CreateCheckbox(L[family] or family, function()
                local settingHasTrue = CheckSetting(settings[family])

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
                        local dash
                        if button.leftTexture2 then
                            -- mainline style
                            dash = button.leftTexture2
                            dash:SetPoint("CENTER", button.leftTexture1, "CENTER", 0, 1)
                        else
                            -- classic style
                            dash = button:AttachTexture()
                            dash:SetPoint("CENTER", button.leftTexture1)
                            button.leftTexture1:SetAtlas("common-dropdown-ticksquare-classic", true)
                        end

                        dash:SetAtlas("voicechat-icon-loudnessbar-2", true)
                        dash:SetTexCoord(1, 0, 0, 0, 1, 1, 0, 1)
                        dash:SetSize(16, 16)
                    end
                end
            end)
            AddIcon(subMenu, family, next(ADDON.DB.Family[family]))
            local sortedSubFamilies = {}
            for subfamily, _ in pairs(ADDON.DB.Family[family]) do
                tInsert(sortedSubFamilies, subfamily)
            end
            table.sort(sortedSubFamilies, function(a, b)
                return (L[a] or a) < (L[b] or b)
            end)
            for _, subfamily in pairs(sortedSubFamilies) do
                AddIcon(ADDON.UI.FDD:CreateFilter(subMenu, L[subfamily] or subfamily, subfamily, settings[family], settings), family, subfamily)
            end

        else
            AddIcon(ADDON.UI.FDD:CreateFilter(root, L[family] or family, family, settings, true), family)
        end
    end
end