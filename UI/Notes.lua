local _, ADDON = ...

ADDON.notes = {}

local AceGUI = LibStub("AceGUI-3.0")

function ADDON.notes:createNotesFrame(spellId, creatureName)

    local note = AceGUI:Create("Window", "Set Note", UIParent)

    -- Create frame
    note:SetTitle("Note for " .. creatureName)
    note:SetHeight(80)
    note:SetWidth(310)
    note:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
    note:SetLayout("Flow")
    note:EnableResize(false)

    -- Create Edit Box
    local editbox = AceGUI:Create("EditBox")
    editbox:SetLabel("")
    editbox:SetWidth(200)
    editbox:SetMaxLetters(128)
    editbox:SetCallback("OnAcquire", function(widget, event, text)
        text = getNoteForMount(spellId)
    end)
    editbox:DisableButton(true)
    editbox:SetText(getNoteForMount(spellId))
    note:AddChild(editbox)

    -- Create button
    local button = AceGUI:Create("Button")
    button:SetText("Save")
    button:SetWidth(75)
    button:SetCallback("OnClick", function() 
        setNoteForMount(spellId, editbox:GetText())
        note:Hide()
    end)
    note:AddChild(button)

    -- Display
    note:SetPoint("CENTER",0,0)
    note:Show()

end

function getNoteForMount(spellId)
    if ADDON.settings.notes[spellId] then
        return ADDON.settings.notes[spellId]
    end
end

function setNoteForMount(spellId, note)
    ADDON.settings.notes[spellId] = note
end
