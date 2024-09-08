local ADDON_NAME, ADDON = ...

if MenuUtil then -- modern style filter menu
    return
end

ADDON.UI.FDD = {}

local SETTING_COLLECTED = "collected"
local SETTING_ONLY_FAVORITES = "onlyFavorites"
local SETTING_NOT_COLLECTED = "notCollected"
local SETTING_ONLY_USEABLE = "onlyUsable"
local SETTING_ONLY_TRADABLE = "onlyTradable"
local SETTING_ONLY_RECENT = "onlyRecent"
local SETTING_SOURCE = "source"
local SETTING_MOUNT_TYPE = "mountType"
local SETTING_FACTION = "faction"
local SETTING_FAMILY = "family"
local SETTING_EXPANSION = "expansion"
local SETTING_HIDDEN = "hidden"
local SETTING_HIDDEN_INGAME = "hiddenIngame"
local SETTING_SORT = "sort"
local SETTING_COLOR = "color"
local SETTING_RARITY = "rarity"

function ADDON.UI.FDD:UpdateResetVisibility()
    if MountJournalFilterButton.ResetButton then
        MountJournalFilterButton.ResetButton:SetShown(not ADDON.IsUsingDefaultFilters())
    end
end;

local function setAllSettings(settings, switch)
    for key, value in pairs(settings) do
        if type(value) == "table" then
            for subKey, _ in pairs(value) do
                settings[key][subKey] = switch
            end
        else
            settings[key] = switch
        end
    end
end

local onlyPool
local function AddOnlyButton(info, settings)
    if not onlyPool then
        onlyPool = CreateFramePool("Button")
    end

    local onlyButton = onlyPool:Acquire()
    if not onlyButton.initialized then
        onlyButton:SetNormalFontObject(GameFontHighlightSmallLeft)
        onlyButton:SetHighlightFontObject(GameFontHighlightSmallLeft)
        onlyButton:SetText(ADDON.L.FILTER_ONLY)

        onlyButton:SetSize(onlyButton:GetTextWidth(), UIDROPDOWNMENU_BUTTON_HEIGHT)

        onlyButton.CallParent = function(self, script, ...)
            local parent = self:GetParent()
            parent:GetScript(script)(parent, ...)
        end

        onlyButton:HookScript("OnEnter", function(self)
            self:Show()
            self:CallParent("OnEnter")
        end)
        onlyButton:HookScript("OnLeave", function(self)
            if not self:GetParent():IsMouseOver() then
                self:CallParent("OnLeave")
                if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE  then
                    self:Hide()
                end
            end
        end)

        onlyButton.initialized = true
    end

    -- overwrite every time
    onlyButton:SetScript("OnClick", function(self, ...)
        setAllSettings(settings, false)
        self:CallParent("OnClick", ...)
    end)

    -- classic doesn't has funcOnEnter and funcOnLeave yet. so we simply always show
    if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE  then
        info.funcOnEnter = function()
            onlyButton:Show()
        end
        info.funcOnLeave = function()
            if not onlyButton:IsMouseOver() then
                onlyButton:Hide()
            end
        end
    end
    info.customFrame = {
        only = onlyButton,
        button = nil,
        Show = function(self)
            self.button:Show()
            if WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE  then
                self.only:Show()
            end
        end,
        Hide = function(self)
            self.button:Hide()
            self.only:SetParent()
            onlyPool:Release(self.only)
        end,
        IsShown = function(self)
            return self.button:IsShown()
        end,
        SetOwningButton = function(self, button)
            self.button = button
            self.only:SetParent(button)
            self.only:SetPoint("RIGHT", button, "RIGHT")
            self.only:SetFrameLevel(button:GetFrameLevel()+2)
        end,
        ClearAllPoints = function() end,
        SetPoint = function() end,
        GetPreferredEntryWidth = function(self)
            local button = self.button
            local width = button:GetTextWidth() + 40
            -- Add padding if has and expand arrow or color swatch
            if ( button.hasArrow or button.hasColorSwatch ) then
                width = width + 10;
            end
            if ( button.padding ) then
                width = width + button.padding;
            end

            width = width + self.only:GetTextWidth()

            return width
        end,
        GetPreferredEntryHeight = function(self)
            self.button:Show() -- show again after SetShown(false) in default logic
            return self.button:GetHeight()
        end
    }

    return info
end

function ADDON.UI.FDD:CreateFilterInfo(text, filterKey, filterSettings, withOnly, toggleButtons)
    local info = {
        keepShownOnClick = true,
        isNotRadio = true,
        hasArrow = false,
        text = text,
    }

    if filterKey then
        if not filterSettings then
            filterSettings = ADDON.settings.filter
        end
        info.notCheckable = false
        info.checked = function()
            return filterSettings[filterKey]
        end
        info.func = function(self, _, _, value)
            filterSettings[filterKey] = value
            ADDON:FilterMounts()
            UIDropDownMenu_RefreshAll(_G[ADDON_NAME .. "FilterMenu"])
            ADDON.UI.FDD:UpdateResetVisibility()

            if toggleButtons then
                local name = self:GetName()
                local x = tonumber(string.match(name, "%d+"))
                local y = tonumber(string.match(name, "%d+$"))
                for _, toggleNext in ipairs(toggleButtons) do
                    if value then
                        UIDropDownMenu_EnableButton(x, y + toggleNext)
                    else
                        UIDropDownMenu_DisableButton(x, y + toggleNext)
                    end
                end
            end
        end
        if withOnly then
            -- accept other settings table as withOnly-Param
            info = AddOnlyButton(info, true == withOnly and filterSettings or withOnly)
        end
    else
        info.notCheckable = true
    end

    return info
end
local CreateFilterInfo = function(...)
    return ADDON.UI.FDD.CreateFilterInfo(ADDON.UI.FDD, ...)
end

local function CreateFilterCategory(text, value)
    local info = CreateFilterInfo(text)
    info.hasArrow = true
    info.value = value

    return info
end

function ADDON.UI.FDD:SetAllSubFilters(settings, switch)
    setAllSettings(settings,switch)

    UIDropDownMenu_RefreshAll(_G[ADDON_NAME .. "FilterMenu"])
    ADDON:FilterMounts()
    ADDON.UI.FDD:UpdateResetVisibility()
end

local hookedWidthButtons = {}
local function HookResizeButtonWidth(button, calcWidth)
    local name = button:GetName()
    button.arg2 = {"MJE_RESIZE", calcWidth}
    if not hookedWidthButtons[name] then
        hookedWidthButtons[name] = true
        hooksecurefunc(button, "SetWidth", function(self, width)
            if "table" == type(self.arg2) and self.arg2[1] == "MJE_RESIZE" then
                self:SetSize(self.arg2[2](width), self:GetHeight())
            end
        end)
    end
end

local function AddCheckAllAndNoneInfo(settings, level)
    local info = CreateFilterInfo(ALL)
    info.justifyH = "CENTER"
    info.func = function()
        ADDON.UI.FDD:SetAllSubFilters(settings, true)
    end
    local AllButton = UIDropDownMenu_AddButton(info, level)
    HookResizeButtonWidth(AllButton, function(w) return w/2 end)

    info = CreateFilterInfo(NONE)
    info.justifyH = "CENTER"
    info.func = function()
        ADDON.UI.FDD:SetAllSubFilters(settings, false)
    end
    local NoneButton = UIDropDownMenu_AddButton(info, level)
    NoneButton:SetPoint("TOPLEFT", AllButton, "TOPRIGHT", 0, 0)
    HookResizeButtonWidth(NoneButton, function(w) return w/2 end)
end

local function InitializeFilterDropDown(frame, level)
    local L = ADDON.L

    if level == 1 then
        local info
        UIDropDownMenu_AddButton(CreateFilterCategory(RAID_FRAME_SORT_LABEL, SETTING_SORT), level)
        UIDropDownMenu_AddSpace(level)

        info = CreateFilterInfo(COLLECTED, SETTING_COLLECTED, nil, nil, { 1, 2 })
        UIDropDownMenu_AddButton(info, level)

        info = CreateFilterInfo(FAVORITES_FILTER, SETTING_ONLY_FAVORITES)
        info.leftPadding = 16
        info.disabled = not ADDON.settings.filter.collected
        UIDropDownMenu_AddButton(info, level)
        info = CreateFilterInfo(PET_JOURNAL_FILTER_USABLE_ONLY, SETTING_ONLY_USEABLE)
        info.leftPadding = 16
        info.disabled = not ADDON.settings.filter.collected
        UIDropDownMenu_AddButton(info, level)

        info = CreateFilterInfo(NOT_COLLECTED, SETTING_NOT_COLLECTED, nil, nil, { 1 })
        UIDropDownMenu_AddButton(info, level)
        info = CreateFilterInfo(L.FILTER_SECRET, SETTING_HIDDEN_INGAME)
        info.leftPadding = 16
        info.disabled = not ADDON.settings.filter.notCollected
        UIDropDownMenu_AddButton(info, level)

        UIDropDownMenu_AddButton(CreateFilterInfo(L.FILTER_ONLY_LATEST, SETTING_ONLY_RECENT), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(L["Only tradable"], SETTING_ONLY_TRADABLE), level)

        if ADDON.settings.filter[SETTING_HIDDEN] or TableHasAnyEntries(ADDON.settings.hiddenMounts) then
            UIDropDownMenu_AddButton(CreateFilterInfo(L["Hidden"], SETTING_HIDDEN), level)
        end

        UIDropDownMenu_AddSpace(level)

        UIDropDownMenu_AddButton(CreateFilterCategory(SOURCES, SETTING_SOURCE), level)
        UIDropDownMenu_AddButton(CreateFilterCategory(MOUNT_JOURNAL_FILTER_TYPE or TYPE, SETTING_MOUNT_TYPE), level)
        UIDropDownMenu_AddButton(CreateFilterCategory(FACTION, SETTING_FACTION), level)
        UIDropDownMenu_AddButton(CreateFilterCategory(L["Family"], SETTING_FAMILY), level)
        UIDropDownMenu_AddButton(CreateFilterCategory(EXPANSION_FILTER_TEXT, SETTING_EXPANSION), level)
        UIDropDownMenu_AddButton(CreateFilterCategory(COLOR, SETTING_COLOR), level)
        if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
            UIDropDownMenu_AddButton(CreateFilterCategory(RARITY, SETTING_RARITY), level)
        end

        UIDropDownMenu_AddSpace(level)

        info = CreateFilterInfo(L["Reset filters"])
        info.justifyH = "CENTER"
        info.keepShownOnClick = false
        info.func = function()
            MountJournalFilterButton.resetFunction()
            ADDON.UI.FDD:UpdateResetVisibility()
        end
        UIDropDownMenu_AddButton(info, level)
    elseif level == 2 and UIDROPDOWNMENU_MENU_VALUE == SETTING_SOURCE then

        local serverExpansion = GetClientDisplayExpansionLevel()

        local settings = ADDON.settings.filter[SETTING_SOURCE]
        AddCheckAllAndNoneInfo(settings, level)
        UIDropDownMenu_AddButton(CreateFilterInfo(BATTLE_PET_SOURCE_1, "Drop", settings, true), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(BATTLE_PET_SOURCE_2, "Quest", settings, true), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(BATTLE_PET_SOURCE_3, "Vendor", settings, true), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(BATTLE_PET_SOURCE_4, "Profession", settings, true), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(INSTANCE, "Instance", settings, true), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(REPUTATION, "Reputation", settings, true), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(BATTLE_PET_SOURCE_6, "Achievement", settings, true), level)
        if serverExpansion >= LE_EXPANSION_SHADOWLANDS then
            UIDropDownMenu_AddButton(CreateFilterInfo(GetCategoryInfo(15441), "Covenants", settings, true), level)
        end
        if serverExpansion >= LE_EXPANSION_BATTLE_FOR_AZEROTH then
            UIDropDownMenu_AddButton(CreateFilterInfo(ISLANDS_HEADER, "Island Expedition", settings, true), level)
        end
        if serverExpansion >= LE_EXPANSION_WARLORDS_OF_DRAENOR then
            UIDropDownMenu_AddButton(CreateFilterInfo(GARRISON_LOCATION_TOOLTIP, "Garrison", settings, true), level)
        end
        UIDropDownMenu_AddButton(CreateFilterInfo(PVP, "PVP", settings, true), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(CLASS, "Class", settings, true), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(BATTLE_PET_SOURCE_7, "World Event", settings, true), level)
        if serverExpansion >= LE_EXPANSION_MISTS_OF_PANDARIA then
            UIDropDownMenu_AddButton(CreateFilterInfo(L["Black Market"], "Black Market", settings, true), level)
        end
        if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE  then
            UIDropDownMenu_AddButton(CreateFilterInfo(BATTLE_PET_SOURCE_12, "Trading Post", settings, true), level)
        end
        UIDropDownMenu_AddButton(CreateFilterInfo(BATTLE_PET_SOURCE_10, "Shop", settings, true), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(BATTLE_PET_SOURCE_8, "Promotion", settings, true), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(L.FILTER_RETIRED, "Unavailable", settings, true), level)
    elseif level == 2 and UIDROPDOWNMENU_MENU_VALUE == SETTING_MOUNT_TYPE then
        local settings = ADDON.settings.filter[SETTING_MOUNT_TYPE]
        AddCheckAllAndNoneInfo(settings, level)
        UIDropDownMenu_AddButton(CreateFilterInfo(MOUNT_JOURNAL_FILTER_FLYING, "flying", settings, true), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(MOUNT_JOURNAL_FILTER_GROUND, "ground", settings, true), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(MOUNT_JOURNAL_FILTER_AQUATIC, "underwater", settings, true), level)
        if GetClientDisplayExpansionLevel() >= LE_EXPANSION_CATACLYSM then
            UIDropDownMenu_AddButton(CreateFilterInfo(L["Transform"], "transform", settings, true), level)
        end
        UIDropDownMenu_AddButton(CreateFilterInfo(MINIMAP_TRACKING_REPAIR, "repair", settings, true), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(L["Passenger"], "passenger", settings, true), level)
    elseif level == 2 and UIDROPDOWNMENU_MENU_VALUE == SETTING_FACTION then
        local settings = ADDON.settings.filter[SETTING_FACTION]
        UIDropDownMenu_AddButton(CreateFilterInfo(FACTION_ALLIANCE, "alliance", settings), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(FACTION_HORDE, "horde", settings), level)
        UIDropDownMenu_AddButton(CreateFilterInfo(NPC_NAMES_DROPDOWN_NONE, "noFaction", settings), level)
    elseif level == 2 and UIDROPDOWNMENU_MENU_VALUE == SETTING_FAMILY then
        AddCheckAllAndNoneInfo(ADDON.settings.filter[SETTING_FAMILY], level)
        ADDON.UI.FDD:AddFamilyMenu(level)
    elseif level == 3 and ADDON.DB.Family[UIDROPDOWNMENU_MENU_VALUE] then
        ADDON.UI.FDD:AddFamilySubMenu(level, UIDROPDOWNMENU_MENU_VALUE)
    elseif level == 2 and UIDROPDOWNMENU_MENU_VALUE == SETTING_EXPANSION then
        local settings = ADDON.settings.filter[SETTING_EXPANSION]
        AddCheckAllAndNoneInfo(settings, level)
        for i = GetClientDisplayExpansionLevel(), 0,-1 do
            UIDropDownMenu_AddButton(CreateFilterInfo(_G["EXPANSION_NAME" .. i], i, settings, true), level)
        end
    elseif level == 2 and UIDROPDOWNMENU_MENU_VALUE == SETTING_COLOR then
        ADDON.UI.FDD:AddColorMenu(level)
    elseif level == 2 and UIDROPDOWNMENU_MENU_VALUE == SETTING_RARITY then
        local settings = ADDON.settings.filter[SETTING_RARITY]
        AddCheckAllAndNoneInfo(settings, level)
        local addButton = function(quality, suffix)
            local text = "|c"..select(4, GetItemQualityColor(quality)).._G["ITEM_QUALITY"..quality.."_DESC"].."|r".." ("..suffix..")"
            UIDropDownMenu_AddButton(CreateFilterInfo(text, quality, settings, true), level)
        end
        addButton(Enum.ItemQuality.Legendary, "<2%")
        addButton(Enum.ItemQuality.Epic, "<10%")
        addButton(Enum.ItemQuality.Rare, "<20%")
        addButton(Enum.ItemQuality.Uncommon, "<50%")
        addButton(Enum.ItemQuality.Common, ">=50%")
    elseif level == 2 and UIDROPDOWNMENU_MENU_VALUE == SETTING_SORT then
        ADDON.UI.FDD:AddSortMenu(level)
    end

    UIDropDownMenu_Refresh(frame, nil, level)
end

ADDON.Events:RegisterCallback("loadUI", function()
    local menu

    MountJournalFilterButton:SetScript("OnMouseDown", function(sender, button)
        UIMenuButtonStretchMixin.OnMouseDown(sender, button);
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)

        if menu == nil then
            menu = CreateFrame("Frame", ADDON_NAME .. "FilterMenu", MountJournalFilterButton, "UIDropDownMenuTemplate")
            UIDropDownMenu_Initialize(menu, InitializeFilterDropDown, "MENU")
        end

        ToggleDropDownMenu(1, nil, menu, sender, 74, 15)
    end)
    MountJournalFilterButton.resetFunction = function()
        ADDON:ResetFilterSettings()
        ADDON:FilterMounts()
    end
    ADDON.UI.FDD:UpdateResetVisibility()
end, "filter dropdown")