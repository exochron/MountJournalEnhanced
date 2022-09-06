local ADDON_NAME, ADDON = ...

local menuMountId
local AceGUI = LibStub("AceGUI-3.0")

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

    info = {
        notCheckable = true,
        text = "Set Note",
        func = function()
            ADDON.notes:createNotesFrame(spellId, creatureName)
        end,
    }
    
    UIDropDownMenu_AddButton(info, level)

    UIDropDownMenu_AddButton({text = CANCEL, notCheckable = true,}, level)
end

ADDON.Events:RegisterCallback("loadUI", function()
    local menu

    local tooltip  = CreateFrame("Frame", "MJENoteTooltip", UIParent)
    tooltip:SetSize(310,60)
    tooltip:SetFrameStrata("TOOLTIP")

    local tex = tooltip:CreateTexture(nil, "OVERLAY")
    tex:SetAllPoints()
    tex:SetColorTexture(0,0,0,1)

    local ttText = tooltip:CreateFontString(nil, "OVERLAY", "GameFontWhite")
    ttText:SetWordWrap(true)
    ttText:SetWidth(300)
    ttText:SetNonSpaceWrap(true)
    ttText:SetPoint("LEFT")

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
    local OnEnter = function(sender)
        local menuMountId = GetMountIDByMountButton(sender)
        local creatureName, spellId, icon, active, isUsable, sourceType, isFavorite, isFaction, faction, hideOnChar, isCollected, mountId = ADDON.Api:GetMountInfoByID(menuMountId)

        if (getNoteForMount(spellId) and (getNoteForMount(spellId) ~= "")) then
            tooltip:ClearAllPoints()
            tooltip:SetPoint("RIGHT", sender, "RIGHT", 315, 0)
            ttText:SetText(getNoteForMount(spellId))
            local textLen = ttText:GetStringWidth()
            if (textLen > 300) then
                tooltip:SetHeight(40)
            elseif (textLen > 600) then
                tooltip:SetHeight(60)
            else
                tooltip:SetHeight(20)
            end
            tooltip:Show()
        end
    end
    local OnLeave = function(sender)
        tooltip:Hide()
    end

    for _, button in pairs(MountJournal.MJE_ListScrollFrame.buttons) do
        button:HookScript("OnClick", function(sender, mouseButton)
            OnClick(sender, sender, mouseButton)
        end)
        button.DragButton:HookScript("OnClick", function(sender, mouseButton)
            OnClick(sender:GetParent(), sender, mouseButton)
        end)
        button:HookScript("OnEnter", function(sender)
            --print("Enter")
            OnEnter(sender)
        end)
        button:HookScript("OnLeave", function(sender)
            OnLeave(sender)
        end)
    end
end, "mount dropdown")