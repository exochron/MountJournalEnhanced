local ADDON_NAME, ADDON = ...

local AceGUI = LibStub("AceGUI-3.0")

function ADDON:OpenOptions()
    local title = GetAddOnMetadata(ADDON_NAME, "Title")
    InterfaceOptionsFrame_OpenToCategory(title)
    InterfaceOptionsFrame_OpenToCategory(title)

    for _, button in ipairs(InterfaceOptionsFrameAddOns.buttons) do
        local element = button.element
        if element and element.collapsed and element.hasChildren and element.name == title then
            InterfaceOptionsListButton_ToggleSubCategories(button)
            break
        end
    end
end

local function BuildCheckBox(parent, text)
    local button = AceGUI:Create("CheckBox")
    button:SetLabel(text)
    button:SetFullWidth(true)
    parent:AddChild(button)

    return button
end
local function BuildHeading(parent, text)
    local head = AceGUI:Create("Heading")
    head:SetText(text)
    head:SetFullWidth(true)
    parent:AddChild(head)

    return head
end

local function BuildFrame(uiLabels, behaviourLabels)
    local title = GetAddOnMetadata(ADDON_NAME, "Title")
    local frame = AceGUI:Create("BlizOptionsGroup")
    frame:SetName(title)
    frame:SetTitle(title)
    frame:SetLayout("List")
    frame.checks = {}

    BuildHeading(frame, UIOPTIONS_MENU)

    for _, labelData in ipairs(uiLabels) do
        local setting, label = labelData[1], labelData[2]
        if (ADDON.settings.ui[setting] ~= nil) then
            frame.checks[setting] = BuildCheckBox(frame, label)
        end
    end

    BuildHeading(frame, ADDON.L.SETTING_HEAD_BEHAVIOUR)

    for _, labelData in ipairs(behaviourLabels) do
        local setting, label = labelData[1], labelData[2]
        if (ADDON.settings[setting] ~= nil) then
            frame.checks[setting] = BuildCheckBox(frame, label)
        end
    end

    return frame
end

local function buildLabel(text, hyperlinkHandler)
    local label = AceGUI:Create("InteractiveLabel")
    label:SetFontObject(GameFontHighlight)
    label:SetText(text)
    label:SetFullWidth(true)
    if hyperlinkHandler then
        label.frame:SetHyperlinksEnabled(true)
        label.frame:HookScript("OnHyperlinkClick", hyperlinkHandler)
    end

    return label
end

local function buildAbout()

    local copybox
    local frame = AceGUI:Create("BlizOptionsGroup")
    frame:SetName("About", GetAddOnMetadata(ADDON_NAME, "Title"))
    frame:SetTitle("About")
    frame:SetLayout("List")

    local copyHandle = function(_, text)
        if not copybox then
            copybox = AceGUI:Create("EditBox")
            copybox:SetLabel("press ctrl + c to copy")
            copybox:SetFullWidth(true)
            copybox:DisableButton(true)
            copybox.label:SetJustifyH("CENTER")
            copybox.editbox:SetJustifyH("CENTER")
            frame:AddChild(copybox)
        end

        copybox:SetText(text)
        copybox:SetFocus()
        copybox:HighlightText(0,-1)
    end
    local link = function(url, text, icon)
        icon = icon and "|TInterface\\Addons\\MountJournalEnhanced\\UI\\icons\\" .. icon .. ":0|t " or ""

        return "|cffffff00|H" .. url .. "|h" .. icon .."[".. text .. "]|h|r"
    end

    BuildHeading(frame, "Acknowledgments")

    frame:AddChild(buildLabel("First of all I would like to thank my dear friend. He initially started Mount Journal Enhanced. This addon wouldn't exist without him." .. "\n\n"))
    frame:AddChild(buildLabel("Furthermore I'd like to thank all contributors, translators, feedback and idea givers. Your help is really very much appreciated." .. "\n\n"))

    frame:AddChild(buildLabel("Besides, it is important to give a special thank you to some community projects and websites. Without whose preliminary work it would be much harder to develop this addon.\n\n"))
    frame:AddChild(buildLabel("- " .. link("https://rarityraider.com/", "Rarity Raider", "rarityraider") .. " for kindly providing their mount rarities.", copyHandle))
    frame:AddChild(buildLabel("- " .. link("https://www.warcraftmounts.com/", "Warcraft Mounts", "warcraftmounts") .. " for their comprehensive family gallery.", copyHandle))
    frame:AddChild(buildLabel("- " .. link("https://www.townlong-yak.com/framexml/live", "Townlong Yak", "townlong_yak") .. ", "
            .. link("https://wow.tools/", "WoW.tools", "wow_tools")
            .. " and " .. link("https://wowdev.wiki/", "WoWDev wiki", "wowdev")
            .. " for their awesome developer resources.", copyHandle))
    frame:AddChild(buildLabel("- foxlit for " .. link("https://www.townlong-yak.com/addons/taintless", "TaintLess") .. ". This great little library is (sadly) essential for any bugless addon or client.", copyHandle))
    frame:AddChild(buildLabel("- The Team of " .. link("https://www.wowace.com/projects/ace3", "Ace3") .. " for their developer friendly framework.", copyHandle))
    frame:AddChild(buildLabel("- " .. link("https://www.wowace.com/projects/herebedragons", "HereBeDragons") .. " for providing a nice api to track player position.", copyHandle))
    frame:AddChild(buildLabel("- The " .. link("https://github.com/BigWigsMods/packager/", "packager by BigWigsMods") .. " which really makes releasing new addon versions as simple as possible.", copyHandle))

    frame:AddChild(buildLabel("\n" .. "Last but not least I'd like to thank YOU for using Mount Journal Enhanced. If you like it, you should show it to your friends and guild mates. So they can enjoy it as well. :)"))

    frame:AddChild(buildLabel("\n\n\n"))

    return frame
end

ADDON.Events:RegisterCallback("OnLogin", function()
    local uiLabels, behaviourLabels = ADDON:GetSettingLabels()

    local group = BuildFrame(uiLabels, behaviourLabels)
    group:SetCallback("refresh", function(frame)
        for _, labelData in ipairs(uiLabels) do
            local setting = labelData[1]
            if (frame.checks[setting]) then
                frame.checks[setting]:SetValue(ADDON.settings.ui[setting])
            end
        end
        for _, labelData in ipairs(behaviourLabels) do
            local setting = labelData[1]
            if (frame.checks[setting]) then
                frame.checks[setting]:SetValue(ADDON.settings[setting])
            end
        end
    end)
    group:SetCallback("okay", function(frame)
        for _, labelData in ipairs(uiLabels) do
            local setting = labelData[1]
            if (frame.checks[setting]) then
                ADDON:ApplySetting(setting, frame.checks[setting]:GetValue())
            end
        end
        for _, labelData in ipairs(behaviourLabels) do
            local setting = labelData[1]
            if (frame.checks[setting]) then
                ADDON:ApplySetting(setting, frame.checks[setting]:GetValue())
            end
        end
    end)
    group:SetCallback("default", ADDON.ResetSettings)
    InterfaceOptions_AddCategory(group.frame)

    InterfaceOptions_AddCategory(buildAbout().frame)
end, "settings panel")