local ADDON_NAME, ADDON = ...

local menu
local currentMountId

local function InitializeUIDDM(sender, level)

    if not currentMountId then
        return
    end

    local creatureName, spellId, icon, active, isUsable, sourceType, isFavorite, isFaction, faction, hideOnChar, isCollected, mountId = ADDON.Api:GetMountInfoByID(currentMountId)

    local info = { notCheckable = true }

    local needsFanfare = C_MountJournal.NeedsFanfare(mountId)

    if needsFanfare then
        info.text = UNWRAP
    elseif (active) then
        info.text = BINDING_NAME_DISMOUNT
    else
        info.text = MOUNT
        info.disabled = not isUsable
    end

    info.func = function()
        if needsFanfare then
            ADDON.Api:SetSelected(currentMountId)
        end
        MountJournalMountButton_UseMount(mountId)
    end

    UIDropDownMenu_AddButton(info, level)

    if not needsFanfare and isCollected then
        local isFavorite, canFavorite = ADDON.Api:GetIsFavoriteByID(currentMountId)
        info = { notCheckable = true, disabled = not canFavorite }

        if isFavorite then
            info.text = BATTLE_PET_UNFAVORITE
            info.func = function()
                ADDON.Api:SetIsFavoriteByID(currentMountId, false)
                ADDON:FilterMounts()
            end
        else
            info.text = BATTLE_PET_FAVORITE
            info.func = function()
                ADDON.Api:SetIsFavoriteByID(currentMountId, true)
                ADDON:FilterMounts()
            end
        end

        UIDropDownMenu_AddButton(info, level)
    end

    if spellId then
        if ADDON.settings.hiddenMounts[spellId] then
            info = {
                notCheckable = true,
                text = SHOW,
                func = function()
                    ADDON.settings.hiddenMounts[spellId] = nil
                    ADDON:FilterMounts()
                end
            }
        else
            info = {
                notCheckable = true,
                text = HIDE,
                func = function()
                    ADDON.settings.hiddenMounts[spellId] = true
                    ADDON:FilterMounts()
                end,
            }
        end
        UIDropDownMenu_AddButton(info, level)
    end

    info = {
        notCheckable = true,
        text = SET_NOTE,
        func = function()
            ADDON.UI:CreateNotesFrame(mountId)
        end,
    }

    UIDropDownMenu_AddButton(info, level)

    UIDropDownMenu_AddButton({ text = CANCEL, notCheckable = true, }, level)
end

local function CreateContextMenu(owner, rootDescription, mountId)
    rootDescription:SetTag("MENU_MOUNT_COLLECTION_MOUNT");

    local _, spellId, _, active, isUsable, _, _, _, _, _, isCollected, menuMountID = ADDON.Api:GetMountInfoByID(mountId)

    local text;
    local checkEnabled = false;
    local needsFanfare = C_MountJournal.NeedsFanfare(menuMountID);
    if needsFanfare then
        text = UNWRAP;
    elseif active then
        text = BINDING_NAME_DISMOUNT;
    else
        text = MOUNT;
        checkEnabled = true
    end

    local mountButton = rootDescription:CreateButton(text, function()
        if needsFanfare then
            ADDON.Api:SetSelected(menuMountID)
        end
        MountJournalMountButton_UseMount(menuMountID);
    end);

    if checkEnabled then
        mountButton:SetEnabled(isUsable);
    end

    if not needsFanfare then
        local button;
        local isFavorite, canFavorite = ADDON.Api:GetIsFavoriteByID(menuMountID)
        if isFavorite then
            button = rootDescription:CreateButton(BATTLE_PET_UNFAVORITE, function()
                ADDON.Api:SetIsFavoriteByID(menuMountID, false)
                ADDON:FilterMounts()
            end);
        else
            button = rootDescription:CreateButton(BATTLE_PET_FAVORITE, function()
                ADDON.Api:SetIsFavoriteByID(menuMountID, true)
                ADDON:FilterMounts()
            end);
        end
        button:SetEnabled(isCollected and canFavorite)
    end

    if spellId then
        if ADDON.settings.hiddenMounts[spellId] then
            rootDescription:CreateButton(SHOW, function()
                ADDON.settings.hiddenMounts[spellId] = nil
                ADDON:FilterMounts()
            end)
        else
            rootDescription:CreateButton(HIDE, function()
                ADDON.settings.hiddenMounts[spellId] = true
                ADDON:FilterMounts()
            end)
        end
    end

    rootDescription:CreateButton(SET_NOTE, function()
        ADDON.UI:CreateNotesFrame(mountId)
    end)
end

function ADDON.UI:HandleListDropDown(sender, relativeTo)
    if MenuUtil then
        local anchor = CreateAnchor("TOPLEFT", relativeTo, "BOTTOMLEFT", 0, 5)
        ADDON.UI.OpenContextMenu(sender, anchor, CreateContextMenu, sender.mountID)
    else
        if menu == nil then
            menu = CreateFrame("Frame", ADDON_NAME .. "MountOptionsMenu", MountJournal, "UIDropDownMenuTemplate")
            UIDropDownMenu_Initialize(menu, InitializeUIDDM, "MENU")
        end

        currentMountId = sender.mountID
        ToggleDropDownMenu(1, nil, menu, relativeTo, 0, 0)
    end
end