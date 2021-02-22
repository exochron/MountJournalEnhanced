local ADDON_NAME, ADDON = ...

local menuMountId

local function InitializeMountOptionsMenu(sender, level)

    if not menuMountId then
        return
    end

    local creatureName, spellId, icon, active, isUsable, sourceType, isFavorite, isFaction, faction, hideOnChar, isCollected, mountId = ADDON.Api:GetMountInfoByID(menuMountId)

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
            ADDON.Api:SetSelected(menuMountId)
        end
        MountJournalMountButton_UseMount(mountId)
    end

    UIDropDownMenu_AddButton(info, level)

    if not needsFanfare and isCollected then
        local isFavorite, canFavorite = ADDON.Api:GetIsFavoriteByID(menuMountId)
        info = {notCheckable = true, disabled = not canFavorite }

        if isFavorite then
            info.text = BATTLE_PET_UNFAVORITE
            info.func = function()
                ADDON.Api:SetIsFavoriteByID(menuMountId, false)
                ADDON.Api:UpdateIndex()
                ADDON.UI:UpdateMountList()
            end
        else
            info.text = BATTLE_PET_FAVORITE
            info.func = function()
                ADDON.Api:SetIsFavoriteByID(menuMountId, true)
                ADDON.Api:UpdateIndex()
                ADDON.UI:UpdateMountList()
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
                    ADDON.Api:UpdateIndex()
                    ADDON.UI:UpdateMountList()
                end
            }
        else
            info = {
                notCheckable = true,
                text = HIDE,
                func = function()
                    ADDON.settings.hiddenMounts[spellId] = true
                    ADDON.Api:UpdateIndex()
                    ADDON.UI:UpdateMountList()
                end,
            }
        end
        UIDropDownMenu_AddButton(info, level)
    end

    UIDropDownMenu_AddButton({text = CANCEL, notCheckable = true,}, level)
end

ADDON.Events:RegisterCallback("loadUI", function()
    local menu
    local OnClick = function(sender, anchor, button)
        if button ~= "LeftButton" then
            if menu == nil then
                menu = CreateFrame("Frame", ADDON_NAME .. "MountOptionsMenu", MountJournal, "UIDropDownMenuTemplate")
                UIDropDownMenu_Initialize(menu, InitializeMountOptionsMenu, "MENU")
            end

            menuMountId = sender.mountID;
            ToggleDropDownMenu(1, nil, menu, anchor, 0, 0)
        end
    end

    for _, button in pairs(MountJournal.MJE_ListScrollFrame.buttons) do
        button:HookScript("OnClick", function(sender, mouseButton)
            OnClick(sender, sender, mouseButton)
        end)
        button.DragButton:HookScript("OnClick", function(sender, mouseButton)
            OnClick(sender:GetParent(), sender, mouseButton)
        end)
    end
end, "mount dropdown")