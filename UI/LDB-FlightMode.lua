local ADDON_NAME, ADDON = ...


local function updateLDB(dataObject)
    local auraData = C_UnitAuras.GetPlayerAuraBySpellID(404468)
    if not auraData then
        auraData = C_UnitAuras.GetPlayerAuraBySpellID(404464)
    end

    if auraData then
        local label, name = string.match(auraData.name, "^(.*)\s*: (.*)$")
        dataObject.icon = auraData.icon
        dataObject.text = name
        dataObject.label = label
    end
end

ADDON.Events:RegisterCallback("OnLogin", function()
    local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
    if not ldb then
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
    actionButton:Hide()

    local spellId = C_MountJournal.GetDynamicFlightModeSpellID()
    local icon = C_Spell.GetSpellTexture(spellId)
    dataObject = ldb:NewDataObject( ADDON_NAME.." Flight Mode", {
        type = "data source",
        text = C_Spell.GetSpellName(spellId),
        icon = icon,

        OnEnter = function(frame)
            actionButton:SetAttribute("spell", C_MountJournal.GetDynamicFlightModeSpellID())
            actionButton:SetParent(frame)
            actionButton:SetAllPoints(frame)
            actionButton:SetFrameStrata("DIALOG")
            actionButton:Show()

            GameTooltip:SetOwner(frame, "ANCHOR_NONE")
            GameTooltip:SetPoint("TOPLEFT", frame, "BOTTOMLEFT")
            GameTooltip:ClearLines()
            GameTooltip:SetSpellByID(C_MountJournal.GetDynamicFlightModeSpellID())
            GameTooltip:Show()
        end,

        OnLeave = function()
            GameTooltip:Hide()
        end
    })
    updateLDB(dataObject)

end, "ldb-flightmode")
