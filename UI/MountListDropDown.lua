local ADDON_NAME, ADDON = ...

local menu
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
        info = { notCheckable = true, disabled = not canFavorite }

        if isFavorite then
            info.text = BATTLE_PET_UNFAVORITE
            info.func = function()
                ADDON.Api:SetIsFavoriteByID(menuMountId, false)
                ADDON:FilterMounts()
            end
        else
            info.text = BATTLE_PET_FAVORITE
            info.func = function()
                ADDON.Api:SetIsFavoriteByID(menuMountId, true)
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

function ADDON.UI:HandleListDropDown(sender, anchor)
    if menu == nil then
        menu = CreateFrame("Frame", ADDON_NAME .. "MountOptionsMenu", MountJournal, "UIDropDownMenuTemplate")
        UIDropDownMenu_Initialize(menu, InitializeMountOptionsMenu, "MENU")
    end

    menuMountId = sender.mountID
    ToggleDropDownMenu(1, nil, menu, anchor, 0, 0)
end