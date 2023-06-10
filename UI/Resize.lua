local ADDON_NAME, ADDON = ...

function ADDON.UI:RestoreWindowSize()
    ADDON.settings.ui.windowSize = { 0, 0 }
    if not InCombatLockdown() then
        ADDON.UI:RestoreSize(CollectionsJournal)
        ADDON.UI:RestorePoint(CollectionsJournal)
    end
end

local function BuildResizeButton()
    local button = CreateFrame("Button", nil, MountJournal)
    button:SetSize(20, 20)
    button:SetPoint("BOTTOMRIGHT", -2, -2)
    button:SetNormalTexture('Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up')
    button:SetHighlightTexture('Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight')
    button:SetPushedTexture('Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down')
    button:SetDontSavePosition(true)

    local ticker
    button:SetScript("OnMouseDown", function()
        --CollectionsJournal:StartSizing("BOTTOMRIGHT") -- doesn't work since 9.1.5
        local lastX, lastY = GetCursorPosition()
        ticker = C_Timer.NewTicker(0.05, function()
            local currentX, currentY = GetCursorPosition()
            local w, h = CollectionsJournal:GetSize()
            local minW, minH = CollectionsJournal:GetResizeBounds()
            CollectionsJournal:SetSize(max(w - lastX + currentX, minW), max(h + lastY - currentY, minH))
            lastX = currentX
            lastY = currentY
        end)
    end)
    button:SetScript("OnMouseUp", function()
        --CollectionsJournal:StopMovingOrSizing()
        if ticker then
            ticker:Cancel()
        end
    end)

    return button
end

ADDON.Events:RegisterCallback("loadUI", function()
    local CJ = CollectionsJournal
    local button = BuildResizeButton()

    ADDON.UI:SaveSize(CJ)
    ADDON.UI:SavePoint(CJ)
    CJ:SetResizeBounds(CJ:GetWidth(), CJ:GetHeight())
    CJ:SetClampedToScreen(true)

    local handler = function(_, activate)
        button:SetShown(activate)

        if activate and not InCombatLockdown() and CJ.selectedTab == COLLECTIONS_JOURNAL_TAB_INDEX_MOUNTS then
            local setting = ADDON.settings.ui.windowSize
            if setting[1] > 0 and setting[2] > 0 then
                CJ:SetSize(setting[1], setting[2])
                ADDON.UI:RestorePoint(CJ)
            end
        elseif not activate and not InCombatLockdown() then
            ADDON.UI:RestoreSize(CJ)
            ADDON.UI:RestorePoint(CJ)
        end
    end

    hooksecurefunc(CJ, "SetResizable", handler)
    handler(CJ, CJ:IsResizable())

    CJ:HookScript("OnSizeChanged", function(_, width, height)
        if CJ:IsResizable() and CJ.selectedTab == COLLECTIONS_JOURNAL_TAB_INDEX_MOUNTS then
            ADDON.settings.ui.windowSize = { width, height }
        end
    end)
end, "Resize")

EventRegistry:RegisterCallback("MountJournal.OnShow", function()
    if CollectionsJournal.selectedTab == COLLECTIONS_JOURNAL_TAB_INDEX_MOUNTS then
        CollectionsJournal:SetResizable(true)
    end
end, ADDON_NAME .. '_Resize')
EventRegistry:RegisterCallback("MountJournal.OnHide", function()
    CollectionsJournal:SetResizable(false)
end, ADDON_NAME .. '_Resize')

ADDON.Events:RegisterFrameEventAndCallback("PLAYER_REGEN_DISABLED", function()
    if CollectionsJournal then
        CollectionsJournal:SetResizable(false)
    end
end, ADDON_NAME .. '_Resize')
ADDON.Events:RegisterFrameEventAndCallback("PLAYER_REGEN_ENABLED", function()
    if CollectionsJournal and CollectionsJournal.selectedTab == COLLECTIONS_JOURNAL_TAB_INDEX_MOUNTS then
        CollectionsJournal:SetResizable(true)
    end
end, ADDON_NAME .. '_Resize')