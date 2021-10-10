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
    button:SetDontSavePosition()

    -- /tinspect CollectionsJournal
    -- /run CollectionsJournal:SetResizable(1);CollectionsJournal:StartSizing()
    button:SetScript("OnMouseDown", function()
        CollectionsJournal:StartSizing("BOTTOMRIGHT") -- TODO: doesn't work on PTR :(
    end)
    button:SetScript("OnMouseUp", function()
        CollectionsJournal:StopMovingOrSizing()
    end)

    return button
end

ADDON.Events:RegisterCallback("loadUI", function()
    local CJ = CollectionsJournal
    local button = BuildResizeButton()

    ADDON.UI:SaveSize(CJ)
    ADDON.UI:SavePoint(CJ)
    CJ:SetMinResize(CJ:GetWidth(), CJ:GetHeight())
    CJ:SetClampedToScreen(true)

    local handler = function(_, activate)
        button:SetShown(activate)

        if activate and not InCombatLockdown() and CJ.selectedTab == 1 then
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
        if CJ:IsResizable() and CJ.selectedTab == 1 then
            ADDON.settings.ui.windowSize = { width, height }
        end
    end)
end, "Resize")

EventRegistry:RegisterCallback("MountJournal.OnShow", function()
    if CollectionsJournal.selectedTab == 1 then
        CollectionsJournal:SetResizable(true)
    end
end, ADDON_NAME .. '_Resize')
EventRegistry:RegisterCallback("MountJournal.OnHide", function()
    CollectionsJournal:SetResizable(false)
end, ADDON_NAME .. '_Resize')

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_REGEN_DISABLED")
f:RegisterEvent("PLAYER_REGEN_ENABLED")
f:SetScript("OnEvent", function(_, event)
    local CJ = CollectionsJournal
    if CJ then
        if event == "PLAYER_REGEN_DISABLED" then
            CJ:SetResizable(false)
        elseif event == "PLAYER_REGEN_ENABLED" and CJ.selectedTab == 1 then
            CJ:SetResizable(true)
        end
    end
end)