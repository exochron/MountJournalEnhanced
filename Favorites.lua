local ADDON_NAME, ADDON = ...

-- TODOs:
-- Option: Auto favorite new mounts; even those learned during offline time
-- (Favorite Menu at SummonRandomFavoriteButton?)

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

    local MJ_GetNumDisplayedMounts = ADDON.hooks["GetNumDisplayedMounts"] or C_MountJournal.GetNumDisplayedMounts
    local MJ_GetDisplayedMountInfo = ADDON.hooks["GetDisplayedMountInfo"] or C_MountJournal.GetDisplayedMountInfo
    local MJ_GetIsFavorite = ADDON.hooks["GetIsFavorite"] or C_MountJournal.GetIsFavorite
    local MJ_SetIsFavorite = ADDON.hooks["SetIsFavorite"] or C_MountJournal.SetIsFavorite

    local hasUpdate
    local isEmptyIdList = (#mountIds == 0)
    for index = 1, MJ_GetNumDisplayedMounts() do
        local _, _, _, _, _, _, _, _, _, _, isCollected, mountId = MJ_GetDisplayedMountInfo(index)
        if isCollected then
            local isFavorite, canFavorite = MJ_GetIsFavorite(index)
            if canFavorite then
                local shouldFavor = tContains(mountIds, mountId)
                if isFavorite and not shouldFavor then
                    MJ_SetIsFavorite(index, false)
                    index = index - 1
                    hasUpdate = true
                elseif not isFavorite and shouldFavor then
                    MJ_SetIsFavorite(index, true)
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
            ADDON:UpdateIndex()
            MountJournal_UpdateMountList()
        end
        finishedCallback()
    end
end

--region Star Button

local function RunSetFavorites(mountIds)
    print(L['TASK_FAVOR_START'])
    FavorMounts(mountIds, function()
        print(L['TASK_END'])
    end)
end

local function FetchDisplayedMountIds()
    local mountIds = {}
    for index = 1, C_MountJournal.GetNumDisplayedMounts() do
        local _, _, _, _, _, _, _, _, _, _, isCollected, mountId = C_MountJournal.GetDisplayedMountInfo(index)
        if isCollected then
            mountIds[#mountIds + 1] = mountId
        end
    end
    return mountIds
end

local function InitializeDropDown(menu, level)
    local info = {
        keepShownOnClick = false,
        isNotRadio = true,
        notCheckable = true,
        hasArrow = false,
    }

    if level == 1 then
        info.text = L['FAVOR_DISPLAYED']
        info.func = function()
            RunSetFavorites(FetchDisplayedMountIds())
        end
        UIDropDownMenu_AddButton(info, level)

        info.text = UNCHECK_ALL
        info.func = function()
            RunSetFavorites({})
        end
        UIDropDownMenu_AddButton(info, level)

        info.text = L["FAVOR_PER_CHARACTER"]
        info.notCheckable = false
        info.checked = ADDON.settings.favoritePerChar
        info.func = function(_, _, _, value)
            ADDON:ApplySetting('favoritePerChar', not value)
        end
        UIDropDownMenu_AddButton(info, level)
    end
end

local function BuildStarButton()
    local menu = CreateFrame("Frame", ADDON_NAME .. "FavorMenu", MountJournal, "UIDropDownMenuTemplate")
    UIDropDownMenu_Initialize(menu, InitializeDropDown, "MENU")

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

    local tooltip = CreateFrame("GameTooltip", "MJEFavoritesToolTip", starButton.frame, "SharedNoHeaderTooltipTemplate")
    starButton:SetCallback("OnEnter", function()
        tooltip:SetOwner(starButton.frame, "ANCHOR_TOP")
        tooltip:SetText(FAVORITES)
        tooltip:Show()
    end)
    starButton:SetCallback("OnLeave", function()
        tooltip:Hide()
    end)
    starButton:SetCallback("OnClick", function()
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

-- resetting personal favored mounts
ADDON:RegisterLoginCallback(function()
    if ADDON.settings.favoritePerChar then
        FavorMounts(ADDON.settings.favoredMounts, function()
            -- not quite performant but so far best solution
            hooksecurefunc(C_MountJournal, "SetIsFavorite", CollectFavoredMounts)
        end)
    else
        hooksecurefunc(C_MountJournal, "SetIsFavorite", CollectFavoredMounts)
    end
end)

ADDON:RegisterLoadUICallback(BuildStarButton)