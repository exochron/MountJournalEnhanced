local _, ADDON = ...

local button, doStrip

ADDON.UI:RegisterUIOverhaulCallback(function(frame)
    if frame ==  MountJournalMountButton then
        doStrip = true
    end
end)

local function BuildButton()
    local frame = CreateFrame("Button", nil, MountJournal, "InsecureActionButtonTemplate,UIPanelButtonTemplate")
    frame:SetText("!")
    frame.tooltipText = "/mountspecial"
    frame:GetFontString():SetJustifyV("MIDDLE")
    frame:SetWidth(frame:GetFontString():GetStringWidth() + 30)
    frame:SetPoint("LEFT", MountJournalMountButton, "RIGHT", 3, 0)
    frame:SetAttribute("type", "macro")
    frame:SetAttribute("typerelease", "macro")
    frame:SetAttribute("macrotext", "/mountspecial");

    if doStrip then
        frame:StripTextures()
    end

    return frame
end

ADDON:RegisterUISetting('showMountspecialButton', true, ADDON.L.SETTING_MOUNTSPECIAL_BUTTON, function(flag)
    if flag and not button then
        button = BuildButton()
    end
    if button then
        button:SetShown(flag)
    end
end)

ADDON.Events:RegisterCallback("loadUI", function()
    ADDON:ApplySetting('showMountspecialButton', ADDON.settings.ui.showMountspecialButton)
end, "mountspecial button")