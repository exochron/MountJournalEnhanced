local ADDON_NAME, ADDON = ...

local function generateMenu(_, root)
    root:SetTag(ADDON_NAME.."-LDB")
    root:SetScrollMode(GetScreenHeight() - 100)

    for index = 1, C_MountJournal.GetNumDisplayedMounts() do
        local name, _, icon, active, _, _, isFavorite, _, _, _, isCollected, mountID = C_MountJournal.GetDisplayedMountInfo(index)
        if isCollected and isFavorite then
            local clickHandler = function(_, data)
                if data.buttonName == "RightButton" then
                    SetCollectionsJournalShown(true, COLLECTIONS_JOURNAL_TAB_INDEX_MOUNTS)
                    ADDON.Api:SetSelected(mountID)
                else
                    local _, _, _, active = C_MountJournal.GetMountInfoByID(mountID)
                    if  active then
                        C_MountJournal.Dismiss()
                    else
                        C_MountJournal.SummonByID(mountID)
                    end
                end
            end

            local element = root:CreateButton("|T" .. icon .. ":0|t "..name, clickHandler)
            element:AddInitializer(function(button)
                button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
                if active then
                    button.fontString:SetTextColor(1.0, 0.82, 0)
                end
            end)
        else
            break
        end
    end

end

ADDON.Events:RegisterCallback("OnLogin", function()
    local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
    if not ldb or not MenuUtil then
        return
    end

    local function count()
        local c = 0
        local mountIDs = C_MountJournal.GetMountIDs();
        for _, mountID in ipairs(mountIDs) do
            local _, _, _, _, _, _, _, _, _, hideOnChar, isCollected = C_MountJournal.GetMountInfoByID(mountID);
            if isCollected and hideOnChar ~= true then
                c = c + 1;
            end
        end

        return c
    end

    local menu
    local closeMenu = function()
        if menu and menu.Close and not menu:IsMouseOver() then
            menu:Close()
        end
    end

    local tooltipProxy = CreateFrame("Frame")
    tooltipProxy:Hide()
    tooltipProxy:HookScript("OnShow", function()
        local point, relativeTo, relativePoint, offsetX, offsetY = tooltipProxy:GetPoint(1)
        if ADDON.Api:HasFavorites() then
            local elementDescription = MenuUtil.CreateRootMenuDescription(MenuVariants.GetDefaultContextMenuMixin())

            Menu.PopulateDescription(generateMenu, relativeTo, elementDescription)
            local anchor = CreateAnchor(point, relativeTo, relativePoint, offsetX, offsetY)
            menu = Menu.GetManager():OpenMenu(relativeTo, elementDescription, anchor)
            if menu then
                menu:HookScript("OnLeave", closeMenu) -- OnLeave gets reset every time
            end
        else
            GameTooltip:SetOwner(tooltipProxy, "ANCHOR_NONE")
            GameTooltip:SetPoint(point, relativeTo, relativePoint, offsetX, offsetY)
            GameTooltip:ClearLines()
            GameTooltip:SetText(MOUNT_JOURNAL_NO_VALID_FAVORITES, nil, nil, nil, nil, true)
            GameTooltip:Show()
        end
    end)
    tooltipProxy:HookScript("OnHide", function()
        if ADDON.Api:HasFavorites() then
            closeMenu()
        else
            GameTooltip:Hide()
        end
    end)

    local ldbDataObject = ldb:NewDataObject( ADDON_NAME.." Favorites", {
        type = "data source",
        text = count(),
        label = COLLECTED,
        icon = "Interface\\Addons\\MountJournalEnhanced\\UI\\icons\\mje.png",
        tooltip = tooltipProxy,

        OnClick = function(_, button)
            if button == "RightButton" then
                ADDON:OpenOptions()
            elseif not InCombatLockdown() then
                ToggleCollectionsJournal(COLLECTIONS_JOURNAL_TAB_INDEX_MOUNTS)
            end
        end,
    } )

    ADDON.Events:RegisterCallback("OnNewMount", function()
        ldbDataObject.text = count()
    end, "ldb-plugin")

end, "ldb-plugin")