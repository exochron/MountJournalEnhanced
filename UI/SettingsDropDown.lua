local ADDON_NAME, ADDON = ...

local function InitializeUIDDM(self, level)

    if level == 1 then
        local button = {
            isTitle = 1,
            text = C_AddOns.GetAddOnMetadata(ADDON_NAME, "Title"),
            notCheckable = 1,
        }
        UIDropDownMenu_AddButton(button, level)

        local uiLabels, _ = ADDON:GetSettingLabels()
        for _, labelData in ipairs(uiLabels) do
            local setting, label, options = labelData[1], labelData[2], labelData[3]
            if ADDON.settings.ui[setting] ~= nil then
                if options then
                    button = {
                        keepShownOnClick = true,
                        isNotRadio = true,
                        hasArrow = true,
                        text = label,
                        notCheckable = true,
                        value = setting,
                    }
                else
                    button = {
                        keepShownOnClick = true,
                        isNotRadio = true,
                        hasArrow = false,
                        text = label,
                        notCheckable = false,
                        checked = ADDON.settings.ui[setting],
                        func = function(_, _, _, value)
                            ADDON:ApplySetting(setting, value)
                        end,
                    }
                end
                UIDropDownMenu_AddButton(button, level)
            end
        end

        UIDropDownMenu_AddSpace(level)

        button = {
            isNotRadio = true,
            notCheckable = true,
            hasArrow = false,
            text = ADDON.L.DISPLAY_ALL_SETTINGS,
            justifyH = "CENTER",
            func = ADDON.OpenOptions,
        }
        UIDropDownMenu_AddButton(button, level)
        button = {
            isNotRadio = true,
            notCheckable = true,
            hasArrow = false,
            text = ADDON.L.RESET_WINDOW_SIZE,
            justifyH = "CENTER",
            func = function()
                ADDON.UI:RestoreWindowSize()
            end,
        }
        UIDropDownMenu_AddButton(button, level)
    elseif level == 2 then
        local uiLabels, _ = ADDON:GetSettingLabels()
        for _, labelData in ipairs(uiLabels) do
            local setting, options, isMultiSelect = labelData[1], labelData[3], labelData[4]
            if ADDON.settings.ui[setting] ~= nil and options and UIDROPDOWNMENU_MENU_VALUE == setting then
                for option, label in pairs(options) do
                    local button = {
                        keepShownOnClick = true,
                        isNotRadio = isMultiSelect,
                        disabled = ADDON:IsSettingDisabled(setting, option),
                        hasArrow = false,
                        text = label,
                        notCheckable = false,
                        checked = function()
                            if isMultiSelect then
                                return ADDON.settings.ui[setting][option]
                            end
                            return ADDON.settings.ui[setting] == option
                        end,
                        value = option,
                        func = function(_, _, _, checked)
                            if isMultiSelect then
                                ADDON:ApplySetting(setting, checked, option)
                            else
                                ADDON:ApplySetting(setting, option)
                            end
                            UIDropDownMenu_Refresh(self, nil, level)
                        end,
                    }
                    UIDropDownMenu_AddButton(button, level)
                end
                break
            end
        end
    end
end

local function CreateSettingsMenu(_, rootDescription)
    rootDescription:CreateTitle(C_AddOns.GetAddOnMetadata(ADDON_NAME, "Title"))

    local uiLabels, _ = ADDON:GetSettingLabels()
    for _, labelData in ipairs(uiLabels) do
        local setting, label, options, isMultiSelect = labelData[1], labelData[2], labelData[3], labelData[4]
        if options then
            local submenu = rootDescription:CreateButton(label)
            for option, label in pairs(options) do
                local subItem
                if isMultiSelect then
                    subItem = submenu:CreateCheckbox(label, function()
                        return ADDON.settings.ui[setting][option]
                    end, function()
                        ADDON:ApplySetting(setting, not ADDON.settings.ui[setting][option], option)
                        return MenuResponse.Refresh
                    end)
                else
                    subItem = submenu:CreateRadio(label, function()
                        return ADDON.settings.ui[setting] == option
                    end, function()
                        ADDON:ApplySetting(setting, option)
                        return MenuResponse.Refresh
                    end)
                end
                subItem:SetEnabled(function()
                    return not ADDON:IsSettingDisabled(setting, option)
                end)
            end
        else
            local item = rootDescription:CreateCheckbox(label, function()
                return ADDON.settings.ui[setting]
            end, function()
                ADDON:ApplySetting(setting, not ADDON.settings.ui[setting])
                return MenuResponse.Refresh
            end)
            item:SetEnabled(function()
                return not ADDON:IsSettingDisabled(setting)
            end)
        end
    end

    rootDescription:CreateSpacer()
    ADDON.UI:CenterDropdownButton(rootDescription:CreateButton(
        ADDON.L.DISPLAY_ALL_SETTINGS,
        function()
            ADDON.OpenOptions()
            return MenuResponse.CloseAll
        end)
    )
    if ACCESSIBILITY_LABEL and ACCESSIBILITY_MOUNT_LABEL then
        ADDON.UI:CenterDropdownButton(rootDescription:CreateButton(
            ACCESSIBILITY_LABEL,
            function()
                for _, category in ipairs(SettingsPanel:GetCategoryList():GetAllCategories()) do
                    if category:GetName() == ACCESSIBILITY_MOUNT_LABEL and category:GetCategorySet() == 1 then
                        Settings.OpenToCategory(category:GetID())
                        break
                    end
                end
                return MenuResponse.CloseAll
            end)
        )
    end
    ADDON.UI:CenterDropdownButton(rootDescription:CreateButton(
        ADDON.L.RESET_WINDOW_SIZE,
        function()
            ADDON.UI:RestoreWindowSize()
            return MenuResponse.CloseAll
        end)
    )
end

local function BuildWheelButton()

    local button = CreateFrame(MenuUtil and "DropdownButton" or "Button", nil, MountJournal, "UIMenuButtonStretchTemplate")

    button:SetWidth(24)
    button:SetHeight(24)
    button:SetPoint("RIGHT", CollectionsJournal.CloseButton, "LEFT", 0, 0)
    button:SetFrameLevel(555)

    local icon = button:CreateTexture(nil, "ARTWORK")
    icon:SetPoint("TOPLEFT", 4, -4)
    icon:SetPoint("BOTTOMRIGHT", -4, 4)
    if GetFileIDFromPath("Interface/QuestFrame/QuestlogFrame") then
        icon:SetAtlas("QuestLog-icon-setting")
    else
        icon:SetTexture(235498) -- wrench cursor
        icon:SetDesaturated(true)
    end
    button.Icon = icon

    local highlight = button:GetHighlightTexture()
    highlight:SetAtlas("QuestLog-icon-setting")
    highlight:SetAlpha(0.4)
    highlight:SetBlendMode("ADD")
    highlight:SetAllPoints(icon)

    if ElvUI and MountJournalSummonRandomFavoriteButton.IsSkinned then
        local E = unpack(ElvUI)
        E:GetModule('Skins'):HandleButton(button)
    end

    return button
end

ADDON.Events:RegisterCallback("loadUI", function()
    ADDON.UI.SettingsButton = BuildWheelButton()

    if ADDON.UI.SettingsButton.SetupMenu then
        ADDON.UI.SettingsButton:SetupMenu(CreateSettingsMenu)
    else
        local menu
        ADDON.UI.SettingsButton:HookScript("OnClick", function(self)
            PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
            if menu == nil then
                menu = CreateFrame("Frame", ADDON_NAME .. "SettingsMenu", MountJournal, "UIDropDownMenuTemplate")
                UIDropDownMenu_Initialize(menu, InitializeUIDDM, "MENU")
            end

            ToggleDropDownMenu(1, nil, menu, self, 0, 0)
        end)
    end
end, "settings wheel")
