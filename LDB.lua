local ADDON_NAME, ADDON = ...

local function generateMenu(_, root)
    root:SetTag(ADDON_NAME.."-LDB");

    for index = 1, C_MountJournal.GetNumDisplayedMounts() do
        local name, _, icon, _, _, _, isFavorite, _, _, _, isCollected, mountID = C_MountJournal.GetDisplayedMountInfo(index)
        if isCollected and isFavorite then
            root:CreateButton("|T" .. icon .. ":0|t "..name, function()
                local _, _, _, active = C_MountJournal.GetMountInfoByID(mountID)
                if  active then
                    C_MountJournal.Dismiss()
                else
                    C_MountJournal.SummonByID(mountID)
                end
            end)
        else
            break
        end
    end
end

local function InitializeDDMenu()
    for index = 1, C_MountJournal.GetNumDisplayedMounts() do
        local name, _, icon, _, _, _, isFavorite, _, _, _, isCollected, mountID = C_MountJournal.GetDisplayedMountInfo(index)
        if isCollected and isFavorite then

            UIDropDownMenu_AddButton({
                keepShownOnClick = false,
                isNotRadio = true,
                notCheckable = true,
                hasArrow = false,
                text = "|T" .. icon .. ":0|t "..name,
                func = function()
                    local _, _, _, active = C_MountJournal.GetMountInfoByID(mountID)
                    if  active then
                        C_MountJournal.Dismiss()
                    else
                        C_MountJournal.SummonByID(mountID)
                    end
                end
            }, 1)
        else
            break
        end
    end
end

ADDON.Events:RegisterCallback("OnLogin", function()
    local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
    if not ldb then
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
        elseif menu and UIDROPDOWNMENU_OPEN_MENU == menu and DropDownList1.dropdown == menu and not DropDownList1:IsMouseOver() and not menu:GetParent():IsMouseOver() then
            CloseDropDownMenus()
        end
    end

    local ldbDataObject = ldb:NewDataObject( ADDON_NAME, {
        type = "data source",
        text = count(),
        label = C_AddOns.GetAddOnMetadata(ADDON_NAME, "Title"),
        icon = "Interface\\Addons\\MountJournalEnhanced\\UI\\icons\\mje.png",

        OnClick = function(_, button)
            if button == "RightButton" then
                ADDON:OpenOptions()
            else
                ToggleCollectionsJournal(COLLECTIONS_JOURNAL_TAB_INDEX_MOUNTS)
            end
        end,

        OnEnter = function(frame)
            local _, _, _, _, _, _, isFavorite = C_MountJournal.GetDisplayedMountInfo(1)
            if isFavorite then
                if MenuUtil then
                    local elementDescription = MenuUtil.CreateRootMenuDescription(MenuVariants.GetDefaultContextMenuMixin())

                    Menu.PopulateDescription(generateMenu, frame, elementDescription)
                    local anchor = CreateAnchor("TOP", frame, "BOTTOM", 0, 0)
                    menu = Menu.GetManager():OpenMenu(frame, elementDescription, anchor)
                    if menu then
                        menu:HookScript("OnLeave", closeMenu) -- OnLeave gets reset every time
                    end
                else
                    if menu == nil then
                        menu = CreateFrame("Frame", ADDON_NAME .. "LDBMenu", frame, "UIDropDownMenuTemplate")
                        UIDropDownMenu_Initialize(menu, InitializeDDMenu, "MENU")
                        DropDownList1:HookScript("OnLeave", function()
                            if DropDownList1.dropdown == menu then
                                closeMenu()
                            end
                        end)
                    end

                    if UIDROPDOWNMENU_OPEN_MENU ~= menu then
                        ToggleDropDownMenu(1, nil, menu, frame, 0, 0)
                    end
                end
            else
                GameTooltip:SetOwner(frame, "ANCHOR_NONE")
                GameTooltip:SetPoint("TOPLEFT", frame, "BOTTOMLEFT")
                GameTooltip:ClearLines()
                GameTooltip:SetText(MOUNT_JOURNAL_NO_VALID_FAVORITES, nil, nil, nil, nil, true)
                GameTooltip:Show()
            end
        end,

        OnLeave = closeMenu
    } )

    ADDON.Events:RegisterCallback("OnNewMount", function()
        ldbDataObject.text = count()
    end, "ldb-plugin")

end, "ldb-plugin")