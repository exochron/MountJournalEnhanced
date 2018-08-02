local ADDON_NAME, ADDON = ...

-- TODOs:
-- save favorites per character (v2.0)
-- Option: Autofavorite new mounts; even those learned during offline time
-- (Favorite Menu at SummonRandomFavoriteButton?)

local L = ADDON.L
local button

local function FetchDisplayedSpellIds()
    local spelIds = {}
    for index =1, C_MountJournal.GetNumDisplayedMounts() do
        local _, spellId, _, _, _, _, _, _, _, _, isCollected = C_MountJournal.GetDisplayedMountInfo(index)
        if isCollected then
            spelIds[#spelIds+1]=spellId
        else
            break
        end
    end
    return spelIds
end

local function FavorMounts(spellIds)
    -- appearantly Blizzard only allows ~5 requests per second

    local hasUpdate = false
    local isEmptySpellList = (#spellIds == 0)
    for index =1, ADDON.hooks["GetNumDisplayedMounts"]() do
        local _, spellId, _, _, _, _, _, _, _, _, isCollected = ADDON.hooks["GetDisplayedMountInfo"](index)
        if isCollected then
            local isFavorite, canFavorite = ADDON.hooks["GetIsFavorite"](index)
            if canFavorite then
                local shouldFavor = tContains(spellIds, spellId)
                if isFavorite and not shouldFavor then
                    ADDON.hooks["SetIsFavorite"](index, false)
                    index = index - 1
                    hasUpdate = true
                elseif not isFavorite and shouldFavor then
                    ADDON.hooks["SetIsFavorite"](index, true)
                    hasUpdate = true
                elseif not isFavorite and isEmptySpellList then
                    break
                end
            end
        else
            break
        end
    end
    ADDON:UpdateIndexMap()
    MountJournal_UpdateMountList()

    if hasUpdate then
        C_Timer.After(1, function()
            FavorMounts(spellIds)
        end)
    else
        print(L['TASK_END'])
        button:Enable()
    end
end

local function RunSetFavorites(spellIds)
    button:Disable()
    print(L['TASK_FAVOR_START'])
    FavorMounts(spellIds)
end

local function InitializeDropDown(menu, level)
    local info = UIDropDownMenu_CreateInfo()
    info.keepShownOnClick = false
    info.isNotRadio = true
    info.notCheckable = true
    info.hasArrow = false

    if level == 1 then
        info.text = L['FAVOR_DISPLAYED']
        info.func = function()
            RunSetFavorites(FetchDisplayedSpellIds())
        end
        UIDropDownMenu_AddButton(info, level)

        info.text = UNCHECK_ALL
        info.func = function()
            RunSetFavorites({})
        end
        UIDropDownMenu_AddButton(info, level)
    end
end

local function BuildStarButton()

    local menu = CreateFrame("Button", nil, MountJournal, "UIDropDownMenuTemplate")
    UIDropDownMenu_Initialize(menu, InitializeDropDown, "MENU")

    button = CreateFrame("Button", nil, MountJournal)
    button:SetPoint("TOPLEFT", MountJournal.LeftInset, "TOPLEFT", 0, -7)
    button:SetSize(25, 25)
    button:SetNormalAtlas("PetJournal-FavoritesIcon", true)
    button:SetScript("OnEnter", function(sender)
        GameTooltip:SetOwner(sender, "ANCHOR_NONE")
        GameTooltip:SetPoint("BOTTOM", sender, "TOP", 0, -4)
        GameTooltip:SetText(FAVORITES)
        GameTooltip:Show()
    end);
    button:SetScript("OnLeave", function(sender)
        GameTooltip:Hide()
    end);
    button:SetScript("OnClick", function()
        ToggleDropDownMenu(1, nil, menu, button, 0, 10)
    end)

    local searchBox = MountJournal.searchBox
    searchBox:ClearAllPoints()
    searchBox:SetPoint("TOPLEFT", MountJournal.LeftInset, "TOPLEFT", 27, -9)
    searchBox:SetSize(133, 20)
end
hooksecurefunc(ADDON, "LoadUI", BuildStarButton)