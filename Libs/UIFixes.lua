-- This Lib contains some minor UI fixes by eXochron. (inspired by TaintLess)

-- The radio or check mark of a dropdown button doesn't get updated, while enabling or disabling the button.
-- The right colors are only set during initialisation.
if (tonumber(UI_DROPDOWN_ENABLE_ART_PATCH_VERSION) or 0) < 1 then
    UI_DROPDOWN_ENABLE_ART_PATCH_VERSION = 1
    local function set(region, active)
        region:SetDesaturated(not active)
        region:SetAlpha(active and 1 or 0.5)
    end
    hooksecurefunc("UIDropDownMenu_EnableButton", function(level, id)
        set(_G["DropDownList" .. level .. "Button" .. id .. "Check"], true)
        set(_G["DropDownList" .. level .. "Button" .. id .. "UnCheck"], true)
    end)
    hooksecurefunc("UIDropDownMenu_DisableButton", function(level, id)
        set(_G["DropDownList" .. level .. "Button" .. id .. "Check"], false)
        set(_G["DropDownList" .. level .. "Button" .. id .. "UnCheck"], false)
    end)
end

-- The Portrait icon in the collections window is a bit too small. You can actually see the edges of the icon within.
-- This fix makes the icon a bit bigger. So it properly fills the gaps within the circle.
if (tonumber(UI_COLLECTIONS_PORTRAIT_SIZE_VERSION) or 0) < 1 then
    UI_COLLECTIONS_PORTRAIT_SIZE_VERSION = 1
    local frame = CreateFrame("Frame")
    frame:RegisterEvent("ADDON_LOADED")
    frame:RegisterEvent("PLAYER_LOGIN")
    frame:SetScript("OnEvent", function()
        if CollectionsJournal then
            frame:UnregisterAllEvents()
            if string.format("%.0f", CollectionsJournal.portrait:GetWidth()) == "61" then
                CollectionsJournal.portrait:SetSize(63, 63)
                CollectionsJournal.portrait:SetPoint("TOPLEFT", -7, 9)
            end
        end
    end)
end