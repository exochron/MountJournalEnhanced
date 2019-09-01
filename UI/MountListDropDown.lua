local ADDON_NAME, ADDON = ...

local menuMountIndex

local function InitializeMountOptionsMenu(sender, level)

    if not menuMountIndex then
        return
    end

    local creatureName, spellId, icon, active, isUsable, sourceType, isFavorite, isFaction, faction, hideOnChar, isCollected, mountId = C_MountJournal.GetDisplayedMountInfo(menuMountIndex)

    local info = MSA_DropDownMenu_CreateInfo()
    info.notCheckable = true

    local needsFanfare = C_MountJournal.NeedsFanfare(mountId)

    if (needsFanfare) then
        info.text = UNWRAP
    elseif (active) then
        info.text = BINDING_NAME_DISMOUNT
    else
        info.text = MOUNT
        info.disabled = not isUsable
    end

    info.func = function()
        if needsFanfare then
            MountJournal_Select(menuMountIndex)
        end
        MountJournalMountButton_UseMount(mountId)
    end

    MSA_DropDownMenu_AddButton(info, level)

    if not needsFanfare and isCollected then
        info.disabled = nil

        local isFavorite, canFavorite = C_MountJournal.GetIsFavorite(menuMountIndex)

        if (isFavorite) then
            info.text = BATTLE_PET_UNFAVORITE
            info.func = function()
                C_MountJournal.SetIsFavorite(menuMountIndex, false)
                MountJournal_UpdateMountList()
            end
        else
            info.text = BATTLE_PET_FAVORITE
            info.func = function()
                C_MountJournal.SetIsFavorite(menuMountIndex, true)
                MountJournal_UpdateMountList()
            end
        end

        if (canFavorite) then
            info.disabled = false
        else
            info.disabled = true
        end

        MSA_DropDownMenu_AddButton(info, level)
    end

    if (spellId) then
        info.disabled = nil
        if (ADDON.settings.hiddenMounts[spellId]) then
            info.text = SHOW
            info.func = function()
                ADDON.settings.hiddenMounts[spellId] = nil
                ADDON:UpdateIndexMap()
                MountJournal_UpdateMountList()
            end
        else
            info.text = HIDE
            info.func = function()
                ADDON.settings.hiddenMounts[spellId] = true
                ADDON:UpdateIndexMap()
                MountJournal_UpdateMountList()
            end
        end
        MSA_DropDownMenu_AddButton(info, level)
    end

    info.disabled = nil
    info.text = CANCEL
    info.func = nil
    MSA_DropDownMenu_AddButton(info, level)
end

local function MountListItem_OnClick(menu, sender, anchor, button)
    if (button ~= "LeftButton") then
        local _, _, _, _, _, _, _, _, _, _, isCollected = C_MountJournal.GetDisplayedMountInfo(sender.index)
        if not isCollected then
            MountJournal_ShowMountDropdown(sender.index, anchor, 0, 0)
        end
    end
end

local function ShowMountDropdown(index, anchorTo, offsetX, offsetY)
    if (index) then
        menuMountIndex = index;
    else
        return;
    end

    MSA_ToggleDropDownMenu(1, nil, _G[ADDON_NAME .. "MountOptionsMenu"], anchorTo, offsetX, offsetY)
    PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
end

ADDON:RegisterLoadUICallback(function()
    local menu = MSA_DropDownMenu_Create(ADDON_NAME .. "MountOptionsMenu", MountJournal)
    MSA_DropDownMenu_Initialize(menu, InitializeMountOptionsMenu, "MENU")

    local buttons = MountJournal.ListScrollFrame.buttons
    for buttonIndex = 1, #buttons do
        local button = buttons[buttonIndex]
        button:HookScript("OnClick", function(sender, mouseButton)
            MountListItem_OnClick(menu, sender, sender, mouseButton)
        end)
        button.DragButton:HookScript("OnClick", function(sender, mouseButton)
            MountListItem_OnClick(menu, sender:GetParent(), sender, mouseButton)
        end)
    end

    ADDON:Hook(nil, "MountJournal_ShowMountDropdown", ShowMountDropdown)
    hooksecurefunc("MountJournal_HideMountDropdown", function()
        menu:Hide()
    end)
end)