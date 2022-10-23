local _, ADDON = ...

local AceGUI = LibStub("AceGUI-3.0")

function ADDON.UI:CreateNotesFrame(mountId)

    local note = AceGUI:Create("Window")

    -- Create frame
    note:SetTitle(SET_NOTE)
    note:SetHeight(150)
    note:SetWidth(400)
    note:SetCallback("OnClose", function(widget)
        AceGUI:Release(widget)
    end)
    note:SetLayout("List")
    note:EnableResize(false)

    -- Create Edit Box
    local editbox = AceGUI:Create("MultiLineEditBox")
    editbox:SetLabel("")
    editbox:SetWidth(375)
    editbox:SetText(ADDON.settings.notes[mountId] or "")
    editbox:DisableButton(true)
    note:AddChild(editbox)

    -- Create button
    local button = AceGUI:Create("Button")
    button:SetText(SAVE)
    button:SetWidth(375)
    button:SetCallback("OnClick", function()
        ADDON.settings.notes[mountId] = editbox:GetText()
        note:Hide()
    end)
    note:AddChild(button)

    -- Display
    note:SetPoint("CENTER", 0, 0)
    note:Show()
    editbox:SetFocus()
end

local function getLabelText(mountId)
    local text = ''
    local note = ADDON.settings.notes[mountId]
    if note then
        text = NORMAL_FONT_COLOR:WrapTextInColorCode(NOTE_COLON) .. " " .. HIGHLIGHT_FONT_COLOR:WrapTextInColorCode(note)
    end

    return text
end

-- show notes in mount tooltips
ADDON.Events:RegisterCallback("OnLogin", function()
    hooksecurefunc(GameTooltip, "SetMountBySpellID", function(tooltip, spellId)
        local mountId = C_MountJournal.GetMountFromSpell(spellId)
        if mountId then
            local text = getLabelText(mountId)
            if text then
                tooltip:AddLine(text)
                tooltip:Show()
            end
        end
    end)
end, "notes")

-- show notes also in display
local function setupFontString()
    local frame = MountJournal.MountDisplay.InfoButton

    local text = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    text:SetPoint("TOPLEFT", frame.Lore, "BOTTOMLEFT", 0, -6)
    text:SetSize(345, 0)
    text:SetJustifyH("LEFT")

    return text
end
ADDON.Events:RegisterCallback("loadUI", function()
    local notesText = setupFontString()

    local callback = function()
        local mountId = ADDON.Api:GetSelected()
        if mountId and notesText then
            notesText:SetText(getLabelText(mountId))
        end
    end
    ADDON.Events:RegisterCallback("OnUpdateMountDisplay", callback, 'DisplayNotes')
end, "display notes")
