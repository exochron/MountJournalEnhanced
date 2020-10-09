local ADDON_NAME, ADDON = ...

local function CreateTitle()
    local title = GetAddOnMetadata(ADDON_NAME, "Title")
    local info = MSA_DropDownMenu_CreateInfo()
    info.isTitle = 1
    info.text = title
    info.notCheckable = 1

    return info
end

local function CreateCheck(text, setting)
    local info = MSA_DropDownMenu_CreateInfo()
    info.keepShownOnClick = true
    info.isNotRadio = true
    info.hasArrow = false
    info.text = text
    info.notCheckable = false
    info.checked = ADDON.settings.ui[setting]
    info.func = function(_, _, _, value)
        ADDON:ApplySetting(setting, value)
    end

    return info
end

local function InitializeDropDown(menu, level)
    MSA_DropDownMenu_AddButton(CreateTitle(), level)

    local uiLabels, _ = ADDON:GetSettingLabels()
    for _, labelData in ipairs(uiLabels) do
        local setting, label = labelData[1], labelData[2]
        if (ADDON.settings.ui[setting] ~= nil) then
            MSA_DropDownMenu_AddButton(CreateCheck(label, setting), level)
        end
    end
end

local function BuildWheelButton()
    local AceGUI = LibStub("AceGUI-3.0")

    local button = AceGUI:Create("Icon")
    button:SetParent({ content = MountJournal })
    button:SetWidth(18)
    button:SetHeight(18)

    if (CollectionsJournalPortrait:IsShown() and CollectionsJournalPortrait:GetAlpha() > 0.0) then
        button:SetPoint("TOPLEFT", MountJournal, "TOPLEFT", 60, -1)
    else
        button:SetPoint("TOPLEFT", MountJournal, "TOPLEFT", 3, -1)
    end

    button.image:SetAtlas("mechagon-projects")
    button.image:SetWidth(20)
    button.image:SetHeight(20)
    button.image:SetPoint("TOP", 0, 0)

    button.frame:Show()

    return button
end

ADDON:RegisterLoadUICallback(function()
    local button = BuildWheelButton()

    local menu = MSA_DropDownMenu_Create(ADDON_NAME .. "SettingsMenu", MountJournal)
    MSA_DropDownMenu_Initialize(menu, InitializeDropDown, "MENU")
    button:SetCallback("OnClick", function(sender)
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        MSA_ToggleDropDownMenu(1, nil, menu, button.frame, 0, 0)
    end)
end)
