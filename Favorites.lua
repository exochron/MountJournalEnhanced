local ADDON_NAME, ADDON = ...

-- TODOs:
-- Option: Autofavorite new mounts; even those learned during offline time
-- (Favorite Menu at SummonRandomFavoriteButton?)

local L = ADDON.L
local starButton

function ADDON:CollectFavoredMounts()
    local personalFavored = {}
    if ADDON.settings.favoritePerChar then
        local mountIds = C_MountJournal.GetMountIDs()
        for _, mountId in ipairs(mountIds) do
            local _, _, _, _, _, _, isFavorite = C_MountJournal.GetMountInfoByID(mountId)
            if isFavorite then
                personalFavored[#personalFavored+1] = mountId
            end
        end
    end

    ADDON.settings.favoredMounts = personalFavored

    return personalFavored
end

local function FavorMounts(mountIds, finishedCallback)
    -- apparently Blizzard only allows ~5 requests per second

    if starButton then
        starButton:Disable()
    end

    local MJ_GetNumDisplayedMounts = ADDON.hooks["GetNumDisplayedMounts"] or C_MountJournal.GetNumDisplayedMounts
    local MJ_GetDisplayedMountInfo = ADDON.hooks["GetDisplayedMountInfo"] or C_MountJournal.GetDisplayedMountInfo
    local MJ_GetIsFavorite = ADDON.hooks["GetIsFavorite"] or C_MountJournal.GetIsFavorite
    local MJ_SetIsFavorite = ADDON.hooks["SetIsFavorite"] or C_MountJournal.SetIsFavorite

    local hasUpdate
    local isEmptyIdList = (#mountIds == 0)
    for index =1, MJ_GetNumDisplayedMounts() do
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
    if ADDON.initialized then
        ADDON:UpdateIndexMap()
        MountJournal_UpdateMountList()
    end

    if hasUpdate then
        C_Timer.After(1, function()
            FavorMounts(mountIds, finishedCallback)
        end)
    elseif finishedCallback then
        if starButton then
            starButton:Enable()
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
    for index =1, C_MountJournal.GetNumDisplayedMounts() do
        local _, _, _, _, _, _, _, _, _, _, isCollected, mountId = C_MountJournal.GetDisplayedMountInfo(index)
        if isCollected then
            mountIds[#mountIds +1]=mountId
        else
            break
        end
    end
    return mountIds
end

local function InitializeDropDown(menu, level)
    local info = MSA_DropDownMenu_CreateInfo()
    info.keepShownOnClick = false
    info.isNotRadio = true
    info.notCheckable = true
    info.hasArrow = false

    if level == 1 then
        info.text = L['FAVOR_DISPLAYED']
        info.func = function()
            RunSetFavorites(FetchDisplayedMountIds())
        end
        MSA_DropDownMenu_AddButton(info, level)

        info.text = UNCHECK_ALL
        info.func = function()
            RunSetFavorites({})
        end
        MSA_DropDownMenu_AddButton(info, level)

        info.text = L["FAVOR_PER_CHARACTER"]
        info.notCheckable = false
        info.checked = ADDON.settings.favoritePerChar
        info.func = function(_, _, _, value)
            ADDON.settings.favoritePerChar = not value
            ADDON:CollectFavoredMounts()
        end
        MSA_DropDownMenu_AddButton(info, level)
    end
end

local function BuildStarButton()
    local menu = MSA_DropDownMenu_Create(ADDON_NAME.."FavorMenu", MountJournal)
    MSA_DropDownMenu_Initialize(menu, InitializeDropDown, "MENU")

    starButton = CreateFrame("Button", nil, MountJournal)
    starButton:SetPoint("TOPLEFT", MountJournal.LeftInset, "TOPLEFT", 0, -7)
    starButton:SetSize(25, 25)
    starButton:SetNormalAtlas("PetJournal-FavoritesIcon", true)
    starButton:SetScript("OnEnter", function(sender)
        GameTooltip:SetOwner(sender, "ANCHOR_NONE")
        GameTooltip:SetPoint("BOTTOM", sender, "TOP", 0, -4)
        GameTooltip:SetText(FAVORITES)
        GameTooltip:Show()
    end);
    starButton:SetScript("OnLeave", function(sender)
        GameTooltip:Hide()
    end);
    starButton:SetScript("OnClick", function()
        MSA_ToggleDropDownMenu(1, nil, menu, starButton, 0, 10)
    end)

    local searchBox = MountJournal.searchBox
    searchBox:ClearAllPoints()
    searchBox:SetPoint("TOPLEFT", MountJournal.LeftInset, "TOPLEFT", 27, -9)
    searchBox:SetSize(133, 20)
end
ADDON:RegisterLoadUICallback(BuildStarButton)

--endregion

-- resetting personal favored mounts
ADDON:RegisterLoginCallback(function()
    if ADDON.settings.favoritePerChar then
        FavorMounts(ADDON.settings.favoredMounts, function()
            -- not quite performant but so far best solution
            hooksecurefunc(C_MountJournal, "SetIsFavorite", ADDON.CollectFavoredMounts)
        end)
    else
        hooksecurefunc(C_MountJournal, "SetIsFavorite", ADDON.CollectFavoredMounts)
    end
end)
