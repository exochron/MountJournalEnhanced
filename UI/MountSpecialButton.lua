local _, ADDON = ...

local button, doStrip

ADDON.UI:RegisterUIOverhaulCallback(function(frame)
    if frame ==  MountJournal then
        doStrip = true
    end
end)

local function BuildButton()

    local frame = CreateFrame("Button", "MJEMountSpecialButton", nil, "InsecureActionButtonTemplate,UIPanelButtonNoTooltipTemplate")
    local tooltip = CreateFrame("GameTooltip", "MJEMountSpecialButtonToolTip", frame, "SharedTooltipTemplate")
    frame:SetText("!")

    frame:HookScript("OnEnter", function()
        tooltip:SetOwner(frame, "ANCHOR_RIGHT")
        tooltip:SetText("/mountspecial", HIGHLIGHT_FONT_COLOR:GetRGB());
        GameTooltip_AddNormalLine(tooltip, ADDON.L.SPECIAL_TIP)
        tooltip:Show()
    end)
    frame:HookScript("OnLeave", function()
        tooltip:Hide()
    end)
    frame.tooltipText = "/mountspecial"

    frame:GetFontString():SetJustifyV("MIDDLE")
    frame:SetWidth(frame:GetFontString():GetStringWidth() + 30)
    frame:SetAttributeNoHandler("type", "macro")
    frame:SetAttributeNoHandler("typerelease", "macro")
    frame:SetAttributeNoHandler("macrotext", "/mountspecial");
    frame:SetAttributeNoHandler("pressAndHoldAction", "1");

    frame:RegisterEvent("PLAYER_REGEN_DISABLED")
    frame:RegisterEvent("PLAYER_REGEN_ENABLED")
    frame:SetScript("OnEvent", function(self, event)
        if event =="PLAYER_REGEN_DISABLED" then
            self:Disable()
        elseif event =="PLAYER_REGEN_ENABLED" and ADDON:IsPlayerMounted() then
            self:Enable()
        end
    end)
    if not ADDON:IsPlayerMounted() then
        frame:Disable()
    end

    frame:Hide()

    return frame
end

ADDON:RegisterUISetting('showMountspecialButton', true, ADDON.L.SETTING_MOUNTSPECIAL_BUTTON, function(flag)
    button:SetShown(flag)
end)

ADDON.Events:RegisterCallback("OnLogin", function()
    button = BuildButton()
    -- need that button for keybinding as well
end, "mountspecial button")

ADDON.Events:RegisterCallback("loadUI", function()
    button:SetParent(MountJournal)
    button:SetPoint("LEFT", MountJournalMountButton, "RIGHT", 3, 0)

    local ElvSkin = ADDON.UI:GetElvUI('Skins')
    if doStrip and ElvSkin then
        ElvSkin:HandleButton(frame)
    end

    ADDON:ApplySetting('showMountspecialButton', ADDON.settings.ui.showMountspecialButton)
end, "mountspecial button")

ADDON.Events:RegisterCallback("OnMountDown", function(...)
    if button then
        button:Disable()
    end
end, 'mountspecial button')

ADDON.Events:RegisterCallback("OnMountUp", function(...)
    if button and not InCombatLockdown() then
        button:Enable()
    end
end, 'mountspecial button')