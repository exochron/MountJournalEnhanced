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
    head:SetHeight(35)
    parent:AddChild(head)

    return head
end

local function BuildMainFrame(uiLabels, behaviourLabels)
    local title = GetAddOnMetadata(ADDON_NAME, "Title")
    local frame = AceGUI:Create("BlizOptionsGroup")
    frame:SetName(title)
    frame:SetTitle(title)
    frame:SetLayout("List")
    frame.content:SetPoint("TOPLEFT", 20, -50)
    frame.content:SetPoint("BOTTOMRIGHT", -20, 10)

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

local function BildAbout()

    local copybox
    local frame = AceGUI:Create("BlizOptionsGroup")
    frame:SetName(ADDON.L["SETTING_HEAD_ABOUT"], GetAddOnMetadata(ADDON_NAME, "Title"))
    frame:SetTitle(ADDON.L["SETTING_HEAD_ABOUT"])
    frame:SetLayout("List")
    frame.content:SetPoint("TOPLEFT", 20, -50)
    frame.content:SetPoint("BOTTOMRIGHT", -20, 10)

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
        copybox:HighlightText(0, -1)
    end
    local link = function(url, text, icon)
        icon = icon and "|TInterface\\Addons\\MountJournalEnhanced\\UI\\icons\\" .. icon .. ":0|t " or ""

        return "|cff56B0FF|H" .. url .. "|h" .. icon .. "[" .. text .. "]|h|r"
    end

    local buildLabel = function(text)
        local label = AceGUI:Create("InteractiveLabel")
        label:SetFontObject(GameFontHighlight)
        label:SetText(text)
        label:SetFullWidth(true)
        label.frame:SetHyperlinksEnabled(true)
        label.frame:HookScript("OnHyperlinkClick", copyHandle)

        frame:AddChild(label)
    end

    buildLabel("|cffffd100" .. GAME_VERSION_LABEL .. ":|r " .. GetAddOnMetadata(ADDON_NAME, "Version") .. "\n\n")
    buildLabel("|cffffd100" .. ADDON.L["SETTING_ABOUT_AUTHOR"] .. ":|r " .. GetAddOnMetadata(ADDON_NAME, "Author") .. "\n\n")
    buildLabel("Have you found any bug or do you have some suggestions? Please let me know in the issue tracker on "
            .. link("https://www.curseforge.com/wow/addons/mount-journal-enhanced/issues", "Curseforge") .. " or "
            .. link("https://github.com/exochron/MountJournalEnhanced/issues", "GitHub") .. ".")
    buildLabel("Is your language still missing some texts? You can help to localize this addon into your language on "
            .. link("https://www.curseforge.com/wow/addons/mount-journal-enhanced/localization", "Curseforge"))

    BuildHeading(frame, "Acknowledgments")
    buildLabel("First of all I would like to thank my dear friend. He initially started Mount Journal Enhanced. This addon wouldn't exist without him." .. "\n\n")
    buildLabel("Furthermore I'd like to thank all contributors, translators, feedback and idea givers. Your help is really very much appreciated." .. "\n\n")

    buildLabel("Besides, it is important to give a special thank you to some community projects and websites. Without whose preliminary work it would be much harder to develop this addon.\n\n")
    buildLabel("- " .. link("https://rarityraider.com/", "Rarity Raider", "rarityraider") .. " for kindly providing their mount rarity percentages.")
    buildLabel("- " .. link("https://www.warcraftmounts.com/", "Warcraft Mounts", "warcraftmounts") .. " for their comprehensive family gallery.")
    buildLabel("- " .. link("https://www.townlong-yak.com/framexml/live", "Townlong Yak", "townlong_yak") .. ", "
            .. link("https://wow.tools/", "WoW.tools", "wow_tools")
            .. " and the " .. link("https://wowdev.wiki/", "WoWDev wiki", "wowdev")
            .. " for their awesome developer resources.")
    buildLabel("- foxlit for " .. link("https://www.townlong-yak.com/addons/taintless", "TaintLess") .. ". This great little library is (sadly) essential for any bugless addon or client.")
    buildLabel("- The Team of " .. link("https://www.wowace.com/projects/ace3", "Ace3") .. " for their developer friendly framework.")
    buildLabel("- " .. link("https://www.wowace.com/projects/herebedragons", "HereBeDragons") .. " for providing a nice api to keep track of the player position.")
    buildLabel("- The " .. link("https://github.com/BigWigsMods/packager/", "packager by BigWigsMods") .. " which makes releasing new versions as simple as possible.")

    buildLabel("\n" .. "Last but not least I'd like to thank YOU for using Mount Journal Enhanced. If you like it, you should show it to your friends and guild mates. So they can enjoy it as well. :-)")
    buildLabel("\n\n\n") -- add some space for copybox

    return frame
end

ADDON.Events:RegisterCallback("OnLogin", function()
    local uiLabels, behaviourLabels = ADDON:GetSettingLabels()

    local group = BuildMainFrame(uiLabels, behaviourLabels)
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

    InterfaceOptions_AddCategory(BildAbout().frame)
end, "settings panel")