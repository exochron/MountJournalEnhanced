local ADDON_NAME, ADDON = ...

local function InitializeDropDown(self, level)

    if level == 1 then
        local button = {
            isTitle = 1,
            text = GetAddOnMetadata(ADDON_NAME, "Title"),
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
            local setting, _, options = labelData[1], labelData[2], labelData[3]
            if ADDON.settings.ui[setting] ~= nil and options and UIDROPDOWNMENU_MENU_VALUE == setting then
                for option, label in pairs(options) do
                    local button = {
                        keepShownOnClick = true,
                        isNotRadio = false,
                        hasArrow = false,
                        text = label,
                        notCheckable = false,
                        checked = function()
                            return ADDON.settings.ui[setting] == option
                        end,
                        value = option,
                        func = function()
                            ADDON:ApplySetting(setting, option)
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

local withoutStyle = false
local function BuildWheelButton()

    local template
    if not withoutStyle then
        template = "UIMenuButtonStretchTemplate"
    end

    local button = CreateFrame("Button", nil, MountJournal, template)

    button:SetWidth(24)
    button:SetHeight(24)
    button:SetPoint("RIGHT", CollectionsJournal.CloseButton, "LEFT", 0, 0)
    button:SetFrameLevel(510)

    local tex = button:CreateTexture(nil, "ARTWORK")
    tex:SetPoint("TOPLEFT", 4, -4)
    tex:SetPoint("BOTTOMRIGHT", -4, 4)
    if GetFileIDFromPath("interface/cursor/crosshair/engineerskin") then
        tex:SetTexture(4675627) -- wrench cursor
    else
        tex:SetTexture(235498) -- wrench cursor
    end
    tex:SetDesaturated(true)

    button:SetHighlightAtlas("mechagon-projects", "ADD")
    tex = button:GetHighlightTexture()
    tex:SetPoint("TOPLEFT", button, "TOPLEFT", 3, -3)
    tex:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -3, 3)
    tex:SetAlpha(0.35)
    tex:SetBlendMode("ADD")

    return button
end

ADDON.Events:RegisterCallback("loadUI", function()
    local button = BuildWheelButton()

    local menu
    button:HookScript("OnClick", function()
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        if menu == nil then
            menu = CreateFrame("Frame", ADDON_NAME .. "SettingsMenu", MountJournal, "UIDropDownMenuTemplate")
            UIDropDownMenu_Initialize(menu, InitializeDropDown, "MENU")
        end

        ToggleDropDownMenu(1, nil, menu, button, 0, 0)
    end)
end, "settings wheel")

ADDON.UI:RegisterUIOverhaulCallback(function(frame)
    if frame == CollectionsJournal then
        withoutStyle = true
    end
end)