local ADDON_NAME, ADDON = ...

local menuMountIndex

local function InitializeMountOptionsMenu(sender, level)

    if not menuMountIndex then
        return
    end

    local creatureName, spellId, icon, active, isUsable, sourceType, isFavorite, isFaction, faction, hideOnChar, isCollected, mountId = C_MountJournal.GetDisplayedMountInfo(menuMountIndex)

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
            MountJournal_Select(menuMountIndex)
        end
        MountJournalMountButton_UseMount(mountId)
    end

    UIDropDownMenu_AddButton(info, level)

    if not needsFanfare and isCollected then
        local isFavorite, canFavorite = C_MountJournal.GetIsFavorite(menuMountIndex)
        info = {notCheckable = true, disabled = not canFavorite }

        if isFavorite then
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

        UIDropDownMenu_AddButton(info, level)
    end

    if spellId then
        if ADDON.settings.hiddenMounts[spellId] then
            info = {
                notCheckable = true,
                text = SHOW,
                func = function()
                    ADDON.settings.hiddenMounts[spellId] = nil
                    ADDON:UpdateIndex()
                    MountJournal_UpdateMountList()
                end
            }
        else
            info = {
                notCheckable = true,
                text = HIDE,
                func = function()
                    ADDON.settings.hiddenMounts[spellId] = true
                    ADDON:UpdateIndex()
                    MountJournal_UpdateMountList()
                end,
            }
        end
        UIDropDownMenu_AddButton(info, level)
    end

    UIDropDownMenu_AddButton({text = CANCEL, notCheckable = true,}, level)
end

local function OnClick(sender, anchor, button)
    if button ~= "LeftButton" and sender.index then
        menuMountIndex = sender.index;
        ToggleDropDownMenu(1, nil, _G[ADDON_NAME .. "MountOptionsMenu"], anchor, 0, 0)
    end
end

ADDON:RegisterLoadUICallback(function()
    local menu = CreateFrame("Frame", ADDON_NAME .. "MountOptionsMenu", MountJournal, "UIDropDownMenuTemplate")
    UIDropDownMenu_Initialize(menu, InitializeMountOptionsMenu, "MENU")

    local buttons = MountJournal.ListScrollFrame.buttons
    for buttonIndex = 1, #buttons do
        local button = buttons[buttonIndex]
        button:HookScript("OnClick", function(sender, mouseButton)
            OnClick(sender, sender, mouseButton)
        end)
        button.DragButton:HookScript("OnClick", function(sender, mouseButton)
            OnClick(sender:GetParent(), sender, mouseButton)
        end)
    end
end)