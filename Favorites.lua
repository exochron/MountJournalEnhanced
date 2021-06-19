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
    -- apparently Blizzard only allows ~5 requests per second

    if starButton then
        starButton:SetDisabled(true)
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
            starButton:SetDisabled(false)
        end
        if ADDON.initialized then
            ADDON.Api:UpdateIndex()
            ADDON.UI:UpdateMountList()
        end
        finishedCallback()
    end
end

--region Star Button

local function RunSetFavorites(mountIds)
    print(L.TASK_FAVOR_START)
    FavorMounts(mountIds, function()
        print(L.TASK_END)
    end)
end

local function FetchDisplayedMountIds()
    local mountIds = {}
    for index = 1, ADDON.Api:GetNumDisplayedMounts() do
        local _, _, _, _, _, _, _, _, _, _, isCollected, mountId = ADDON.Api:GetDisplayedMountInfo(index)
        if isCollected then
            mountIds[#mountIds + 1] = mountId
        end
    end
    return mountIds
end

local function InitializeDropDown(_, level)

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

local function BuildStarButton()
    local AceGUI = LibStub("AceGUI-3.0")

    starButton = AceGUI:Create("Icon")
    starButton:SetParent({ content = MountJournal })
    starButton:SetPoint("TOPLEFT", MountJournal.LeftInset, "TOPLEFT", 0, -7)
    starButton:SetWidth(25)
    starButton:SetHeight(25)

    starButton.image:SetAtlas("PetJournal-FavoritesIcon")
    starButton.image:SetWidth(25)
    starButton.image:SetHeight(25)
    starButton.image:SetPoint("TOP", 0, 0)

    local menu
    starButton:SetCallback("OnClick", function()
        if menu == nil then
            menu = CreateFrame("Frame", ADDON_NAME .. "FavorMenu", MountJournal, "UIDropDownMenuTemplate")
            UIDropDownMenu_Initialize(menu, InitializeDropDown, "MENU")
        end

        ToggleDropDownMenu(1, nil, menu, starButton.frame, 0, 10)
    end)

    starButton.frame:Show()

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