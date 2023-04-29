local ADDON_NAME, ADDON = ...

local function togglePortrait(cool)
    if cool then
        CollectionsJournal:GetPortrait():SetTexture("Interface\\Addons\\MountJournalEnhanced\\UI\\icons\\mje.png")
    else
        CollectionsJournal:SetPortraitToAsset("Interface\\Icons\\MountJournalPortrait")
    end
end

ADDON.Events:RegisterCallback("loadUI", function()
    local portrait = CollectionsJournal:GetPortrait()

    portrait:EnableMouse(true)
    portrait:HookScript("OnMouseDown", function()
        if CollectionsJournal.selectedTab == 1 then
            togglePortrait(strsub(portrait:GetTexture(),1,8) == "Portrait")
        end
    end)
end, "fun stuff")

local today = C_DateAndTime.GetCurrentCalendarTime()
if today.month == 4 and today.monthDay == 1 then
    EventRegistry:RegisterCallback("MountJournal.OnShow",function()
        togglePortrait(true)
    end, ADDON_NAME .. 'fun stuff')
end