local ADDON_NAME, ADDON = ...

-- TODO:
-- - (Favorite Menu at SummonRandomFavoriteButton?)

local L = ADDON.L
local starButton

local function CollectFavoredMounts()
    local personalFavored = {}
    if ADDON.settings.favoritePerChar then
        local mountIds = C_MountJournal.GetMountIDs()
        for _, mountId in ipairs(mountIds) do
            local _, _, _, _, _, _, isFavorite = C_MountJournal.GetMountInfoByID(mountId)
            if isFavorite then
                personalFavored[#personalFavored + 1] = mountId
            end
        end
    end

    ADDON.settings.favoredMounts = personalFavored
    MJEPersonalSettings.favoredMounts = personalFavored
end

local function FavorMounts(mountIds, finishedCallback)
    -- Apparently Blizzard only allows ~5 requests per second

    if starButton then
        starButton:Disable()
    end

    local hasUpdate
    local isEmptyIdList = (#mountIds == 0)
    for index = 1, C_MountJournal.GetNumDisplayedMounts() do
        local _, _, _, _, _, _, _, _, _, _, isCollected, mountId = C_MountJournal.GetDisplayedMountInfo(index)
        if isCollected then
            local isFavorite, canFavorite = C_MountJournal.GetIsFavorite(index)
            if canFavorite then
                local shouldFavor = tContains(mountIds, mountId)
                if isFavorite and not shouldFavor then
                    C_MountJournal.SetIsFavorite(index, false)
                    index = index - 1
                    hasUpdate = true
                elseif not isFavorite and shouldFavor then
                    C_MountJournal.SetIsFavorite(index, true)
                    hasUpdate = true
                elseif not isFavorite and isEmptyIdList then
                    break
                end
            end
        else
            break
        end
    end

    if hasUpdate then
        C_Timer.After(1, function()
            FavorMounts(mountIds, finishedCallback)
        end)
    else
        if starButton then
            starButton:Enable()
        end
        if ADDON.initialized then
            ADDON:FilterMounts()
        end
        finishedCallback()
    end
end

--region Star Button

local function RunSetFavorites(mountIds)
    print(L.TASK_FAVOR_START)
    FavorMounts(mountIds, function()
        print(L.TASK_END)
        ADDON:FilterMounts()
    end)
end

local function FetchDisplayedMountIds()
    local mountIds = {}
    ADDON.Api:GetDataProvider():ForEach(function(data)
        if select(11, C_MountJournal.GetMountInfoByID(data.mountID)) then
            mountIds[#mountIds + 1] = data.mountID
        end
    end)

    return mountIds
end

local function InitializeDDMenu(_, level)

    local button = { isTitle = 1, text = FAVORITES, notCheckable = 1, }
    UIDropDownMenu_AddButton(button, level)

    button = {
        keepShownOnClick = false,
        notCheckable = true,
        text = L.FAVOR_DISPLAYED,
        func = function()
            RunSetFavorites(FetchDisplayedMountIds())
        end
    }
    UIDropDownMenu_AddButton(button, level)

    button = {
        keepShownOnClick = false,
        notCheckable = true,
        text = UNCHECK_ALL,
        func = function()
            RunSetFavorites({})
        end
    }
    UIDropDownMenu_AddButton(button, level)

    button = {
        keepShownOnClick = true,
        isNotRadio = true,
        notCheckable = false,
        checked = ADDON.settings.favoritePerChar,
        text = L.FAVOR_PER_CHARACTER,
        func = function(_, _, _, value)
            ADDON:ApplySetting('favoritePerChar', value)
        end
    }
    UIDropDownMenu_AddButton(button, level)

    button = {
        keepShownOnClick = true,
        isNotRadio = true,
        notCheckable = false,
        checked = ADDON.settings.autoFavor,
        text = L.FAVOR_AUTO,
        func = function(_, _, _, value)
            ADDON:ApplySetting('autoFavor', value)
        end
    }
    UIDropDownMenu_AddButton(button, level)
end

local function CreateFavoritesMenu(owner, root)
    root:CreateTitle(FAVORITES)

    root:CreateButton(L.FAVOR_DISPLAYED, function()
        RunSetFavorites(FetchDisplayedMountIds())
    end)
    root:CreateButton(UNCHECK_ALL, function()
        RunSetFavorites({})
    end)
    root:CreateCheckbox(L.FAVOR_PER_CHARACTER, function()
        return ADDON.settings.favoritePerChar
    end, function()
        ADDON:ApplySetting('favoritePerChar', not ADDON.settings.favoritePerChar)
        return MenuResponse.Refresh
    end)
    root:CreateCheckbox(L.FAVOR_AUTO, function()
        return ADDON.settings.autoFavor
    end, function()
        ADDON:ApplySetting('autoFavor', not ADDON.settings.autoFavor)
        return MenuResponse.Refresh
    end)
end

local function BuildStarButton()
    starButton = CreateFrame(MenuUtil and "DropdownButton" or "Button", nil, MountJournal)

    starButton:SetPoint("TOPLEFT", MountJournal.LeftInset, "TOPLEFT", 0, -7)
    starButton:SetSize(25, 25)

    local icon = starButton:CreateTexture(nil, "ARTWORK")
    icon:SetAtlas("PetJournal-FavoritesIcon")
    icon:SetAllPoints(starButton)

    starButton:SetHighlightAtlas("PetJournal-FavoritesIcon", "ADD")
    local highlight = starButton:GetHighlightTexture()
    highlight:SetAlpha(0.4)
    highlight:SetAllPoints(icon)

    starButton:HookScript("OnMouseDown", function()
        icon:AdjustPointsOffset(1, -1)
    end)
    starButton:HookScript("OnMouseUp", function()
        icon:AdjustPointsOffset(-1, 1)
    end)

    if starButton.SetupMenu then
        starButton:SetupMenu(CreateFavoritesMenu)
    else
        local menu
        starButton:HookScript("OnClick", function()
            if menu == nil then
                menu = CreateFrame("Frame", ADDON_NAME .. "FavorMenu", MountJournal, "UIDropDownMenuTemplate")
                UIDropDownMenu_Initialize(menu, InitializeDDMenu, "MENU")
            end

            ToggleDropDownMenu(1, nil, menu, starButton, 0, 10)
        end)
    end

    starButton:Show()
    ADDON.UI.FavoriteButton = starButton

    local searchBox = MountJournal.searchBox
    searchBox:ClearAllPoints()
    searchBox:SetPoint("TOPLEFT", MountJournal.LeftInset, "TOPLEFT", 27, -9)
    searchBox:SetSize(133, 20)
end

--endregion

ADDON:RegisterBehaviourSetting('favoritePerChar', false, L.SETTING_FAVORITE_PER_CHAR, CollectFavoredMounts)

ADDON:RegisterBehaviourSetting('autoFavor', false, L.SETTING_AUTO_FAVOR)
ADDON.Events:RegisterCallback("OnNewMount", function(_, mountId)
    if ADDON.settings.autoFavor and mountId then
        ADDON.Api:SetIsFavoriteByID(mountId, true)
    end
end, "autoFavor")

-- resetting personal favored mounts
ADDON.Events:RegisterCallback("OnLogin", function()
    if ADDON.settings.favoritePerChar then
        FavorMounts(ADDON.settings.favoredMounts, function()
            -- not quite performant but so far best solution
            hooksecurefunc(C_MountJournal, "SetIsFavorite", CollectFavoredMounts)
        end)
    else
        hooksecurefunc(C_MountJournal, "SetIsFavorite", CollectFavoredMounts)
    end
end, "favorite hooks")

ADDON.Events:RegisterCallback("loadUI", BuildStarButton, "favorites")
