local ADDON_NAME, ADDON = ...


local function updateLDB(dataObject)
    local spellInfo = C_Spell.GetSpellInfo(ADDON.Api:IsDynamicFlight() and 404464 or 404468 )
    local label, name = string.match(spellInfo.name, "^(.*)\s*: (.*)$")
    dataObject.icon = spellInfo.iconID
    dataObject.text = name
    dataObject.label = label
end

ADDON.Events:RegisterCallback("OnLogin", function()
    local ldb = LibStub("LibDataBroker-1.1", true)
    if not ldb or not C_MountJournal.IsDragonridingUnlocked() then
        return
    end

    local dataObject

    local actionButton = CreateFrame("Button", nil, nil, "InsecureActionButtonTemplate")
    actionButton:SetAttribute("pressAndHoldAction", 1)
    actionButton:SetAttribute("type", "spell")
    actionButton:SetAttribute("typerelease", "spell")
    actionButton:RegisterForClicks("AnyUp")
    actionButton:SetPropagateMouseClicks(true)
    actionButton:SetPropagateMouseMotion(true)
    actionButton:RegisterUnitEvent("UNIT_AURA", "player")
    actionButton:SetScript("OnEvent", function()
        updateLDB(dataObject)
    end)
    actionButton:HookScript("PreClick", function()
        if not InCombatLockdown() and actionButton:GetParent():IsDragging() then
            actionButton:SetAttribute("type", "")
            actionButton:SetAttribute("typerelease", "")
        end
    end)
    actionButton:HookScript("PostClick", function()
        if not InCombatLockdown() then
            actionButton:SetAttribute("type", "spell")
            actionButton:SetAttribute("typerelease", "spell")
        end
    end)
    actionButton:Hide()

    local tooltipProxy = CreateFrame("Frame")
    tooltipProxy:Hide()
    tooltipProxy:HookScript("OnShow", function()
        local point, relativeTo, relativePoint, offsetX, offsetY = tooltipProxy:GetPoint(1)

        actionButton:SetAttribute("spell", C_MountJournal.GetDynamicFlightModeSpellID())
        actionButton:SetParent(relativeTo)
        actionButton:SetAllPoints(relativeTo)
        actionButton:SetFrameStrata("DIALOG")
        actionButton:Show()

        GameTooltip:SetOwner(tooltipProxy, "ANCHOR_NONE")
        GameTooltip:SetPoint(point, relativeTo, relativePoint, offsetX, offsetY)
        GameTooltip:ClearLines()
        GameTooltip:SetSpellByID(C_MountJournal.GetDynamicFlightModeSpellID())
        GameTooltip:Show()
    end)
    tooltipProxy:HookScript("OnHide", function()
        GameTooltip:Hide()
    end)

    local spellId = C_MountJournal.GetDynamicFlightModeSpellID()
    local icon = C_Spell.GetSpellTexture(spellId)
    dataObject = ldb:NewDataObject( ADDON_NAME.." Flight Mode", {
        type = "data source",
        text = C_Spell.GetSpellName(spellId),
        icon = icon,
        tooltip = tooltipProxy,
    })
    updateLDB(dataObject)

end, "ldb-flightmode")
