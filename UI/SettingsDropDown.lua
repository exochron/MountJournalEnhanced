local ADDON_NAME, ADDON = ...

local function CreateTitle()
    local title = GetAddOnMetadata(ADDON_NAME, "Title")
    return {
        isTitle = 1,
        text = title,
        notCheckable = 1,
    }
end

local function CreateCheck(text, setting)
    return {
        keepShownOnClick = true,
        isNotRadio = true,
        hasArrow = false,
        text = text,
        notCheckable = false,
        checked = ADDON.settings.ui[setting],
        func = function(_, _, _, value)
            ADDON:ApplySetting(setting, value)
        end,
    }
end

local function InitializeDropDown(menu, level)
    UIDropDownMenu_AddButton(CreateTitle(), level)

    local uiLabels, _ = ADDON:GetSettingLabels()
    for _, labelData in ipairs(uiLabels) do
        local setting, label = labelData[1], labelData[2]
        if (ADDON.settings.ui[setting] ~= nil) then
            UIDropDownMenu_AddButton(CreateCheck(label, setting), level)
        end
    end
end

local function BuildWheelButton()
    local button = CreateFrame("Button", nil, MountJournal, "UIMenuButtonStretchTemplate")
    button:SetWidth(24)
    button:SetHeight(24)

    if CollectionsJournalPortrait:IsShown() and CollectionsJournalPortrait:GetAlpha() > 0.0 then
        button:SetPoint("TOPLEFT", MountJournal, "TOPLEFT", 56, 1)
    else
        -- ElvUI hack
        button:SetPoint("TOPLEFT", MountJournal, "TOPLEFT", 3, -1)
    end

    local tex = button:CreateTexture(nil, "ARTWORK")
    tex:SetPoint("TOPLEFT", button, "TOPLEFT", 3, -3)
    tex:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -3, 3)
    tex:SetAtlas("mechagon-projects")
    tex:SetDesaturated(true)

    button:SetHighlightAtlas("mechagon-projects", "ADD")
    tex = button:GetHighlightTexture()
    tex:SetPoint("TOPLEFT", button, "TOPLEFT", 3, -3)
    tex:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -3, 3)
    tex:SetAlpha(0.35)
    tex:SetBlendMode("ADD")

    return button
end

ADDON:RegisterLoadUICallback(function()
    local button = BuildWheelButton()

    local menu = CreateFrame("Frame", ADDON_NAME .. "SettingsMenu", MountJournal, "UIDropDownMenuTemplate")
    UIDropDownMenu_Initialize(menu, InitializeDropDown, "MENU")
    button:HookScript("OnClick", function(sender)
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        ToggleDropDownMenu(1, nil, menu, button, 0, 0)
    end)
end)
