local ADDON_NAME, ADDON = ...

local COLLECTION_ACHIEVEMENT_CATEGORY = 15246
local MOUNT_ACHIEVEMENT_CATEGORY = 15248
local MOUNT_COUNT_STATISTIC = 339
local EXPANSIONS = { "Classic", "The Burning Crusade", "Wrath of the Lich King", "Cataclysm", "Mists of Pandaria", "Warlords of Draenor", "Legion", "Battle for Azeroth" }
local SOURCE_INDEX_ORDER = { "Drop", "Quest", "Vendor", "Profession", "Instance", "Reputation", "Achievement", "Island Expedition", "Garrison", "PVP", "Class", "World Event", "Black Market", "Shop", "Promotion"}

local L = ADDON.L
local MountJournalEnhancedFamily = ADDON.MountJournalEnhancedFamily
local MountJournalEnhancedSource = ADDON.MountJournalEnhancedSource
local MountJournalEnhancedExpansion = ADDON.MountJournalEnhancedExpansion
local MountJournalEnhancedType = ADDON.MountJournalEnhancedType
local MountJournalEnhancedIgnored = ADDON.MountJournalEnhancedIgnored

local initialState = {
    settings = {
        debugMode = false,
        showShopButton = false,
        favoritePerCharacter = true,
        favoredMounts = {},
        hiddenMounts = { },
        filter = {
            collected = true,
            notCollected = true,
            onlyFavorites = false,
            onlyUsable = false,
            source = { },
            faction = {
                alliance = true,
                horde = true,
                noFaction = true,
            },
            mountType = {
                ground = true,
                flying = true,
                waterWalking = true,
                underwater = true,
                transform = true,
                repair = true,
                passenger = true,
            },
            family = { },
			expansion = { },
            hidden = false,
        },
    },
}
for categoryName, _ in pairs(MountJournalEnhancedSource) do
    initialState.settings.filter.source[categoryName] = true
end
for categoryName, _ in pairs(MountJournalEnhancedFamily) do
    initialState.settings.filter.family[categoryName] = true
end
for expansionName, _ in pairs(MountJournalEnhancedExpansion) do
    initialState.settings.filter.expansion[expansionName] = true
end
local defaultFilterStates = CopyTable(initialState.settings.filter)
local dependencies = {
    function() return MountJournal or LoadAddOn("Blizzard_Collections") end,
}
local private = CoreFramework:GetModule("Addon", "1.0"):NewAddon(ADDON_NAME, initialState, dependencies)

private.hooks = { }
private.mountInfoCache = nil
private.indexMap = { }

function private:LoadUI()
    -- reset default filter settings
	C_MountJournal.SetCollectedFilterSetting(LE_MOUNT_JOURNAL_FILTER_COLLECTED, true)
	C_MountJournal.SetCollectedFilterSetting(LE_MOUNT_JOURNAL_FILTER_NOT_COLLECTED, true)
	C_MountJournal.SetCollectedFilterSetting(LE_MOUNT_JOURNAL_FILTER_UNUSABLE, true)
    C_MountJournal.SetAllSourceFilters(true)

    PetJournal:HookScript("OnShow", function() if (not PetJournalPetCard.petID) then PetJournal_ShowPetCard(1) end end)

    self:Hook(C_MountJournal, "GetNumDisplayedMounts", function() return self:C_MountJournal_GetNumDisplayedMounts() end)
    self:Hook(C_MountJournal, "GetDisplayedMountInfo", function(index) return self:C_MountJournal_GetDisplayedMountInfo(index) end)
    self:Hook(C_MountJournal, "Pickup", function(index) self:C_MountJournal_Pickup(index) end)
    self:Hook(C_MountJournal, "SetIsFavorite", function(index, isFavorited) self:C_MountJournal_SetIsFavorite(index, isFavorited) end)
    self:Hook(C_MountJournal, "GetIsFavorite", function(index) return self:C_MountJournal_GetIsFavorite(index) end)
    self:Hook(C_MountJournal, "GetDisplayedMountInfoExtra", function(index) return self:C_MountJournal_GetDisplayedMountInfoExtra(index) end)

    hooksecurefunc("MountJournal_UpdateMountList", function() self:MountJournal_UpdateMountList() end)

    MountJournalSearchBox:SetScript("OnTextChanged", function(sender) self:MountJournal_OnSearchTextChanged(sender) end)
    
    hooksecurefunc(MountJournal.mountOptionsMenu, "initialize", function(sender, level) UIDropDownMenu_InitializeHelper(sender) self:MountOptionsMenu_Init(sender, level) end)
    hooksecurefunc(MountJournalFilterDropDown, "initialize", function(sender, level) UIDropDownMenu_InitializeHelper(sender) self:MountJournalFilterDropDown_Initialize(sender, level) end)
    hooksecurefunc("MountJournal_UpdateMountDisplay", function(sender, level) self:ToggleShopButton() end)

    local buttons = MountJournal.ListScrollFrame.buttons
    for buttonIndex = 1, #buttons do
        local button = buttons[buttonIndex]
        button:HookScript("OnClick", function(sender, mouseButton) self:MountListItem_OnClick(sender, sender, mouseButton) end)
        button:SetScript("OnDoubleClick", function(sender, mouseButton) self:MountListItem_OnDoubleClick(sender, mouseButton) end)
        button.DragButton:HookScript("OnClick", function(sender, mouseButton) self:MountListItem_OnClick(sender:GetParent(), sender, mouseButton) end)
        button.DragButton.IsHidden = button.DragButton:CreateTexture(nil, "OVERLAY")
        button.DragButton.IsHidden:SetTexture("Interface\\BUTTONS\\UI-GroupLoot-Pass-Up")
        button.DragButton.IsHidden:SetSize(36, 36)
        button.DragButton.IsHidden:SetPoint("CENTER", button.DragButton, "CENTER", 0, 0)
        button.DragButton.IsHidden:SetDrawLayer("OVERLAY", 1)
        button.DragButton.IsHidden:SetShown(false)
    end
   
    self:CreateCharacterMountCountFrame()
    self:CreateAchievementFrame()
    self:CreateShopButton()

    self:UpdateMountInfoCache()
    MountJournal_UpdateMountList()
end

function private:CreateCharacterMountCountFrame()
    local frame = CreateFrame("frame", nil, MountJournal, "InsetFrameTemplate3")

    frame:ClearAllPoints()
    frame:SetPoint("TOPLEFT", MountJournal, 70, -42)
    frame:SetSize(130, 18)

    frame.staticText = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    frame.staticText:ClearAllPoints()
    frame.staticText:SetPoint("LEFT", frame, 10, 0)
    frame.staticText:SetText(CHARACTER)

    frame.uniqueCount = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    frame.uniqueCount:ClearAllPoints()
    frame.uniqueCount:SetPoint("RIGHT", frame, -10, 0)
    --frame.uniqueCount:SetText(GetNumCompanions("MOUNT"))
	local _, _, _, mountCount = GetAchievementCriteriaInfo(MOUNT_COUNT_STATISTIC, 1)
	frame.uniqueCount:SetText(mountCount)

    MountJournal.MountCount:SetPoint("TopLeft", 70, -22)
    MountJournal.MountCount:SetSize(130, 18)
    
    self.characterMountCountFrame = frame
end

function private:CreateAchievementFrame()
    local frame = CreateFrame("Button", nil, MountJournal)

    frame:ClearAllPoints()
    frame:SetPoint("TOP", MountJournal, 0, -21)
    frame:SetSize(60, 40)

    frame.bgLeft = frame:CreateTexture(nil, "BACKGROUND")
    frame.bgLeft:SetAtlas("PetJournal-PetBattleAchievementBG")
    frame.bgLeft:ClearAllPoints()
    frame.bgLeft:SetSize(46, 18)
    frame.bgLeft:SetPoint("Top", -56, -12)
    frame.bgLeft:SetVertexColor(1, 1, 1, 1)

    frame.bgRight = frame:CreateTexture(nil, "BACKGROUND")
    frame.bgRight:SetAtlas("PetJournal-PetBattleAchievementBG")
    frame.bgRight:ClearAllPoints()
    frame.bgRight:SetSize(46, 18)
    frame.bgRight:SetPoint("Top", 55, -12)
    frame.bgRight:SetVertexColor(1, 1, 1, 1)
    frame.bgRight:SetTexCoord(1, 0, 0, 1)

    frame.highlight = frame:CreateTexture(nil)
    frame.highlight:SetDrawLayer("BACKGROUND", 1)
    frame.highlight:SetAtlas("PetJournal-PetBattleAchievementGlow")
    frame.highlight:ClearAllPoints()
    frame.highlight:SetSize(210, 40)
    frame.highlight:SetPoint("CENTER", 0, 0)
    frame.highlight:SetShown(false)

    frame.icon = frame:CreateTexture(nil, "OVERLAY")
    frame.icon:SetTexture("Interface\\AchievementFrame\\UI-Achievement-Shields-NoPoints")
    frame.icon:ClearAllPoints()
    frame.icon:SetSize(30, 30)
    frame.icon:SetPoint("RIGHT", 0, -5)
    frame.icon:SetTexCoord(0, 0.5, 0, 0.5)

    frame.staticText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    frame.staticText:ClearAllPoints()
    frame.staticText:SetPoint("RIGHT", frame.icon, "LEFT", -4, 4)
    frame.staticText:SetSize(0, 0)
    frame.staticText:SetText(GetCategoryAchievementPoints(MOUNT_ACHIEVEMENT_CATEGORY, true))

    frame:SetScript("OnClick", function()
        ToggleAchievementFrame()
        local i = 1
        local button = _G["AchievementFrameCategoriesContainerButton" .. i]
        while button do
            if (button.element.id == COLLECTION_ACHIEVEMENT_CATEGORY) then
                button:Click()
                button = nil
            else
                i = i + 1
                button = _G["AchievementFrameCategoriesContainerButton" .. i]
            end
        end

        i = 1
        button = _G["AchievementFrameCategoriesContainerButton" .. i]
        while button do
            if (button.element.id == MOUNT_ACHIEVEMENT_CATEGORY) then
                button:Click()
                return
            end

            i = i + 1
            button = _G["AchievementFrameCategoriesContainerButton" .. i]
        end
    end)
    frame:SetScript("OnEnter", function() frame.highlight:SetShown(true) end)
    frame:SetScript("OnLeave", function() frame.highlight:SetShown(false) end)

    self.achievementFrame = frame
end

function private:CreateShopButton()
    local frame = CreateFrame("Button", nil, MountJournal.MountDisplay.InfoButton)

    frame:ClearAllPoints()
    frame:SetPoint("BOTTOMRIGHT", MountJournal.MountDisplay, -14, 14)
    frame:SetSize(28, 36)
    frame:SetNormalAtlas('hud-microbutton-BStore-Up', true)
    frame:SetPushedAtlas('hud-microbutton-BStore-Down', true)
    frame:SetDisabledAtlas('hud-microbutton-BStore-Disabled', true)
    frame:SetHighlightAtlas('hud-microbutton-highlight', true)

    frame:SetScript("OnClick", function()
        SetStoreUIShown(true)
    end)

    MountJournal.MountDisplay.InfoButton.Shop = frame
end

function private:ToggleShopButton()
    local frame = MountJournal.MountDisplay.InfoButton.Shop
    if (frame) then
        if (self.settings.showShopButton and MountJournal.selectedMountID) then
            local _, _, _, _, _, sourceType, _, _, _, _, isCollected = C_MountJournal.GetMountInfoByID(MountJournal.selectedMountID)
            if not isCollected and sourceType == 10 then
                frame:Show()
                return
            end
        end

        frame:Hide()
    end
end

function private:RunDebugMode()
    local mounts = {}
    local mountIDs = C_MountJournal.GetMountIDs()
    for i, mountID in ipairs(mountIDs) do
        local name, spellID, icon, active, isUsable, sourceType = C_MountJournal.GetMountInfoByID(mountID)
        mounts[spellID] = {
            name=name,
            mountID=mountID,
            sourceType=sourceType,
        }
    end

    local filterSettingsBackup = CopyTable(self.settings.filter)
    for key, _ in pairs(self.settings.filter.source) do
        self.settings.filter.source[key] = false
    end
    for key, _ in pairs(self.settings.filter.family) do
        self.settings.filter.family[key] = false
    end
    for key, _ in pairs(self.settings.filter.expansion) do
        self.settings.filter.expansion[key] = false
    end
    for key, _ in pairs(self.settings.filter.mountType) do
        self.settings.filter.mountType[key] = false
    end

    for spellID, data in pairs(mounts) do
        if not MountJournalEnhancedIgnored[spellID] then
            if self:FilterMountsBySource(spellID, data.sourceType) then
                print("[MJE] New mount: " .. data.name .. " (" .. spellID .. ")")
            end
            if self:FilterMountsByFamily(spellID) then
                print("[MJE] No family info for mount: " .. data.name .. " (" .. spellID .. ")")
            end
            if self:FilterMountsByExpansion(spellID) then
                print("[MJE] No expansion info for mount: " .. data.name .. " (" .. spellID .. ")")
            end
            if self:FilterMountsByType(spellID, data.mountID) then
                print("[MJE] New mount type for mount \"" .. data.name .. "\" (" .. spellID .. ")")
            end
        end
    end

    self.settings.filter = CopyTable(filterSettingsBackup)

    for _, familyMounts in pairs(MountJournalEnhancedFamily) do
        for id, name in pairs(familyMounts) do
            if id ~= "keywords" and not MountJournalEnhancedIgnored[id] and not mounts[id] then
                print("[MJE] Old family info for mount: " .. name .. " (" .. id .. ")")
            end
        end
    end

    for _, expansionMounts in pairs(MountJournalEnhancedExpansion) do
        for id, name in pairs(expansionMounts) do
            if id ~= "minID" and id ~= "maxID" and not MountJournalEnhancedIgnored[id] and not mounts[id] then
                print("[MJE] Old expansion info for mount: " .. name .. " (" .. id .. ")")
            end
        end
    end

    local names = { }
    for _, data in pairs(MountJournalEnhancedSource) do
        for id, name in pairs(data) do
            if id ~= "sourceType" then
                if (names[id] and names[id] ~= name) then
                    print("[MJE] Invalide mount info for mount: " .. name .. " (" .. id .. ")")
                end
                names[id] = name
            end
        end
    end

    for id, name in pairs(MountJournalEnhancedIgnored) do
        if not mounts[id] then
            print("[MJE] Old ignore entry for mount: " .. name .. " (" .. id .. ")")
        end
    end
end

--region Hooks

function private:C_MountJournal_GetNumDisplayedMounts()
    if (not self.mountInfoCache) then
        self:UpdateMountInfoCache()
    end

    return #self.mountInfoCache
end

function private:C_MountJournal_GetDisplayedMountInfo(index)
    if (not self.mountInfoCache) then
        self:UpdateMountInfoCache()
    end
    
    local mountInfo = self.mountInfoCache[index]
    if (not mountInfo) then
        return nil
    end
    
    return unpack(mountInfo)
end

function private:C_MountJournal_Pickup(index)
    if (not self.mountInfoCache) then
        self:UpdateMountInfoCache()
    end

    local displayedIndex = self.indexMap[index]
    self.hooks["Pickup"](displayedIndex)
end

function private:C_MountJournal_GetDisplayedMountInfoExtra(index)
    if (not self.mountInfoCache) then
        self:UpdateMountInfoCache()
    end

    local mountInfo = self.mountInfoCache[index]
    if (not mountInfo) then
        return nil
    end
    
    local _, _, _, _, _, _, _, _, _, _, _, mountID = unpack(mountInfo)
    return C_MountJournal.GetMountInfoExtraByID(mountID)
end

function private:C_MountJournal_SetIsFavorite(index, isFavorited)
    if (not self.mountInfoCache) then
        self:UpdateMountInfoCache()
    end

    local displayedIndex = self.indexMap[index]
    self.hooks["SetIsFavorite"](displayedIndex, isFavorited)
end

function private:C_MountJournal_GetIsFavorite(index)
    if (not self.mountInfoCache) then
        self:UpdateMountInfoCache()
    end

    local displayedIndex = self.indexMap[index]
    return self.hooks["GetIsFavorite"](displayedIndex)
end

--endregion Hooks

--region dropdown menus
function private:CreateFilterInfo(text, filterKey, subfilterKey, callback)
    local info = UIDropDownMenu_CreateInfo()
    info.keepShownOnClick = true
    info.isNotRadio = true
    info.text = text

    if filterKey then
        info.hasArrow = false
        info.notCheckable = false
        if subfilterKey then
            info.checked = function() return self.settings.filter[filterKey][subfilterKey] end
        else
            info.checked = self.settings.filter[filterKey]
        end
        info.func = function(_, _, _, value)
            if subfilterKey then
                self.settings.filter[filterKey][subfilterKey] = value
            else
                self.settings.filter[filterKey] = value
            end
            self:UpdateMountInfoCache()
            MountJournal_UpdateMountList()

            if callback then
                callback(value)
            end
        end
    else
        info.hasArrow = true
        info.notCheckable = true
    end

    return info
end

function private:AddCheckAllAndNoneInfo(filterKey, level, dropdownLevel)
    local info = self:CreateFilterInfo(CHECK_ALL)
    info.hasArrow = false
    info.func = function()
        for key, _ in pairs(self.settings.filter[filterKey]) do
            self.settings.filter[filterKey][key] = true
        end

        UIDropDownMenu_Refresh(MountJournalFilterDropDown, dropdownLevel, 2)
        self:UpdateMountInfoCache()
        MountJournal_UpdateMountList()
    end
    UIDropDownMenu_AddButton(info, level)

    info = self:CreateFilterInfo(UNCHECK_ALL)
    info.hasArrow = false
    info.func = function()
        for key, _ in pairs(self.settings.filter[filterKey]) do
            self.settings.filter[filterKey][key] = false
        end

        UIDropDownMenu_Refresh(MountJournalFilterDropDown, dropdownLevel, 2)
        self:UpdateMountInfoCache()
        MountJournal_UpdateMountList()
    end
    UIDropDownMenu_AddButton(info, level)
end

function private:MountJournalFilterDropDown_Initialize(sender, level)
    local info

    if (level == 1) then
        info = self:CreateFilterInfo(COLLECTED, "collected", nil,  function(value)
            if (value) then
                UIDropDownMenu_EnableButton(1,2)
            else
                UIDropDownMenu_DisableButton(1,2)
            end
        end)
        UIDropDownMenu_AddButton(info, level)

        info = self:CreateFilterInfo(FAVORITES_FILTER, "onlyFavorites")
        info.leftPadding = 16
        info.disabled = not self.settings.filter.collected
        UIDropDownMenu_AddButton(info, level)

        info = self:CreateFilterInfo(NOT_COLLECTED, "notCollected")
        UIDropDownMenu_AddButton(info, level)

        info = self:CreateFilterInfo(L["Only usable"], "onlyUsable")
        UIDropDownMenu_AddButton(info, level)

        info = self:CreateFilterInfo(SOURCES)
        info.value = 1
        UIDropDownMenu_AddButton(info, level)

        info = self:CreateFilterInfo(TYPE)
        info.value = 2
        UIDropDownMenu_AddButton(info, level)

        info = self:CreateFilterInfo(FACTION)
        info.value = 3
        UIDropDownMenu_AddButton(info, level)

        info = self:CreateFilterInfo(L["Family"])
        info.value = 4
        UIDropDownMenu_AddButton(info, level)

        info = self:CreateFilterInfo(L["Expansion"])
        info.value = 5
        UIDropDownMenu_AddButton(info, level)

        info = self:CreateFilterInfo(L["Hidden"], "hidden")
        UIDropDownMenu_AddButton(info, level)

        info = self:CreateFilterInfo(L["Reset filters"])
        info.keepShownOnClick = false
        info.hasArrow = false
        info.func = function(_, _, _, value)
            self.settings.filter = CopyTable(defaultFilterStates)
            self:UpdateMountInfoCache()
            MountJournal_UpdateMountList()
        end
        UIDropDownMenu_AddButton(info, level)
    elseif (UIDROPDOWNMENU_MENU_VALUE == 1) then
        self:AddCheckAllAndNoneInfo("source", level, 1)
        for _,categoryName in pairs(SOURCE_INDEX_ORDER) do
            info = self:CreateFilterInfo(L[categoryName] or categoryName, "source", categoryName)
            UIDropDownMenu_AddButton(info, level)
        end
    elseif (UIDROPDOWNMENU_MENU_VALUE == 2) then
        self:AddCheckAllAndNoneInfo("mountType", level, 2)

        info = self:CreateFilterInfo(L["Ground"], "mountType", "ground")
        UIDropDownMenu_AddButton(info, level)
        info = self:CreateFilterInfo(L["Flying"], "mountType", "flying")
        UIDropDownMenu_AddButton(info, level)
        info = self:CreateFilterInfo(L["Water Walking"], "mountType", "waterWalking")
        UIDropDownMenu_AddButton(info, level)
        info = self:CreateFilterInfo(L["Underwater"], "mountType", "underwater")
        UIDropDownMenu_AddButton(info, level)
        info = self:CreateFilterInfo(L["Transform"], "mountType", "transform")
        UIDropDownMenu_AddButton(info, level)
        info = self:CreateFilterInfo(L["Repair"], "mountType", "repair")
        UIDropDownMenu_AddButton(info, level)
        info = self:CreateFilterInfo(L["Passenger"], "mountType", "passenger")
        UIDropDownMenu_AddButton(info, level)
    elseif (UIDROPDOWNMENU_MENU_VALUE == 3) then
        info = self:CreateFilterInfo(FACTION_ALLIANCE, "faction", "alliance")
        UIDropDownMenu_AddButton(info, level)
        info = self:CreateFilterInfo(FACTION_HORDE, "faction", "horde")
        UIDropDownMenu_AddButton(info, level)
        info = self:CreateFilterInfo(NPC_NAMES_DROPDOWN_NONE, "faction", "noFaction")
        UIDropDownMenu_AddButton(info, level)
    elseif (UIDROPDOWNMENU_MENU_VALUE == 4) then
        self:AddCheckAllAndNoneInfo("family", level, 4)

        local sortedFamilies = {}
        for family, _ in pairs(MountJournalEnhancedFamily) do
            table.insert(sortedFamilies, family)
        end
        table.sort(sortedFamilies, function(a, b) return (L[a] or a) < (L[b] or b) end)

        for _, family in pairs(sortedFamilies) do
            info = self:CreateFilterInfo(L[family] or family, "family", family)
            UIDropDownMenu_AddButton(info, level)
        end

        self:MakeMultiColumnMenu(level, 20)
    elseif (UIDROPDOWNMENU_MENU_VALUE == 5) then
        self:AddCheckAllAndNoneInfo("expansion", level, 5)

        for _, expansion in pairs(EXPANSIONS) do
            info = self:CreateFilterInfo(L[expansion] or expansion, "expansion", expansion)
            UIDropDownMenu_AddButton(info, level)
        end
    end
end

function private:MakeMultiColumnMenu(level, entriesPerColumn)
    local listFrame = _G["DropDownList"..level]
    local columnWidth = listFrame.maxWidth + 25

    local listFrameName = listFrame:GetName()
    local columnIndex = 0
    for index = entriesPerColumn + 1, listFrame.numButtons do
        columnIndex = math.ceil(index / entriesPerColumn)
        local button = _G[listFrameName.."Button"..index]
        local yPos = -((button:GetID() - 1 - entriesPerColumn * (columnIndex - 1)) * UIDROPDOWNMENU_BUTTON_HEIGHT) - UIDROPDOWNMENU_BORDER_HEIGHT

        button:ClearAllPoints()
        button:SetPoint("TOPLEFT", button:GetParent(), "TOPLEFT", columnWidth * (columnIndex - 1), yPos)
        button:SetWidth(columnWidth)
    end

    listFrame:SetHeight((min(listFrame.numButtons, entriesPerColumn) * UIDROPDOWNMENU_BUTTON_HEIGHT) + (UIDROPDOWNMENU_BORDER_HEIGHT * 2))
    listFrame:SetWidth(columnWidth * columnIndex)

    self:Hook(nil, "UIDropDownMenu_OnHide", function(sender)
        self:Unhook(listFrame, "SetWidth")
        self:Unhook(nil, "UIDropDownMenu_OnHide")
        UIDropDownMenu_OnHide(sender)
    end)
    self:Hook(listFrame, "SetWidth", function() end)
end

function private:MountOptionsMenu_Init(sender, level)
	if not MountJournal.menuMountIndex then
		return
	end
    
    local info = UIDropDownMenu_CreateInfo()
    info.notCheckable = true

    local active = select(4, C_MountJournal.GetMountInfoByID(MountJournal.menuMountID))
    local needsFanfare = C_MountJournal.NeedsFanfare(MountJournal.menuMountID)
    
	if (needsFanfare) then
		info.text = UNWRAP
	elseif ( active ) then
		info.text = BINDING_NAME_DISMOUNT
	else
		info.text = MOUNT
		info.disabled = not MountJournal.menuIsUsable
	end
    
	info.func = function()
		if needsFanfare then
			MountJournal_Select(MountJournal.menuMountIndex)
		end
		MountJournalMountButton_UseMount(MountJournal.menuMountID)
	end
    
    UIDropDownMenu_AddButton(info, level)
    
    local spellId = nil
    local isCollected = false
    if (MountJournal.menuMountIndex) then
        _, spellId, _, _, _, _, _, _, _, _, isCollected = C_MountJournal.GetDisplayedMountInfo(MountJournal.menuMountIndex)
    end
    
	if not needsFanfare and isCollected then
		info.disabled = nil

		local canFavorite = false
		local isFavorite = false
		if (MountJournal.menuMountIndex) then
			 isFavorite, canFavorite = C_MountJournal.GetIsFavorite(MountJournal.menuMountIndex)
		end

		if (isFavorite) then
			info.text = BATTLE_PET_UNFAVORITE
			info.func = function()
				C_MountJournal.SetIsFavorite(MountJournal.menuMountIndex, false)
                self:UpdateMountInfoCache()
                MountJournal_UpdateMountList()
			end
		else
			info.text = BATTLE_PET_FAVORITE
			info.func = function()
				C_MountJournal.SetIsFavorite(MountJournal.menuMountIndex, true)
                self:UpdateMountInfoCache()
                MountJournal_UpdateMountList()                
			end
		end

		if (canFavorite) then
			info.disabled = false
		else
			info.disabled = true
		end

		UIDropDownMenu_AddButton(info, level)
	end
    
    if (spellId) then
        info.disabled = nil
        if (self.settings.hiddenMounts[spellId]) then
            info.text = L["Show"]
            info.func = function()
                self.settings.hiddenMounts[spellId] = false
                self:UpdateMountInfoCache()
                MountJournal_UpdateMountList()
            end
        else
            info.text = L["Hide"]
            info.func = function()
                self.settings.hiddenMounts[spellId] = true
                self:UpdateMountInfoCache()
                MountJournal_UpdateMountList()
            end
        end
        UIDropDownMenu_AddButton(info, level)
    end

    info.disabled = nil
    info.text = CANCEL
    info.func = nil
    UIDropDownMenu_AddButton(info, level)
end

-- endregion

function private:MountJournal_UpdateMountList()
    local buttons = MountJournal.ListScrollFrame.buttons
    for i = 1, #buttons do
        if (self.settings.hiddenMounts[buttons[i].spellID]) then
            buttons[i].DragButton.IsHidden:SetShown(true)
        else
            buttons[i].DragButton.IsHidden:SetShown(false)
        end
        buttons[i].DragButton:SetEnabled(true)
    end
end

--region filter functions

function private:FilterMountsByName(name, searchString)
    return string.find(string.lower(name), searchString, 1, true)
end

function private:FilterHiddenMounts(spellId)
    return self.settings.filter.hidden or not self.settings.hiddenMounts[spellId]
end

function private:FilterFavoriteMounts(isFavorite)
    return isFavorite or not self.settings.filter.onlyFavorites or not self.settings.filter.collected
end

function private:FilterUsableMounts(isUsable)
    return not self.settings.filter.onlyUsable or isUsable
end

function private:FilterCollectedMounts(collected)
    return (self.settings.filter.collected and collected) or (self.settings.filter.notCollected and not collected)
end

function private:CheckAllSettings(settings)
    local allDisabled = true
    local allEnabled = true
    for _, value in pairs(settings) do
        if (value) then
            allDisabled = false
        else
            allEnabled = false
        end
    end

    if allEnabled then
        return true
    elseif allDisabled then
        return false
    end

    return nil
end

function private:CheckMountInList(settings, sourceData, spellId)
    local isInList = false

    for setting, value in pairs(settings) do
        if sourceData[setting] and sourceData[setting][spellId] then
            if (value) then
                return true
            else
                isInList = true
            end
        end
    end

    if isInList then
        return false
    end

    return nil
end

function private:FilterMountsBySource(spellId, sourceType)

    local settingsResult = self:CheckAllSettings(self.settings.filter.source)
    if settingsResult then
        return true
    end

    local mountResult = self:CheckMountInList(self.settings.filter.source, MountJournalEnhancedSource, spellId)
    if mountResult ~= nil then
        return mountResult
    end

    for source, value in pairs(self.settings.filter.source) do
        if MountJournalEnhancedSource[source] and MountJournalEnhancedSource[source]["sourceType"]
                and tContains(MountJournalEnhancedSource[source]["sourceType"], sourceType) then
            return value
        end
    end

    return true
end

function private:FilterMountsByFaction(isFaction, faction)
    return (self.settings.filter.faction.noFaction and not isFaction or self.settings.filter.faction.alliance and faction == 1 or self.settings.filter.faction.horde and faction == 0)
end

function private:SearchInList(searchTerms, text)
    if searchTerms then
        for _, searchTerm in pairs(searchTerms) do
            if string.find(text, searchTerm, 1, true) then
                return true
            end
        end
    end

    return false
end

function private:FilterMountsByFamily(spellId)

    local settingsResult = self:CheckAllSettings(self.settings.filter.family)
    if settingsResult then
        return true
    end

    local mountResult = self:CheckMountInList(self.settings.filter.family, MountJournalEnhancedFamily, spellId)
    if mountResult then
        return true
    end

    return mountResult == nil
end

function private:FilterMountsByExpansion(spellId)

    local settingsResult = self:CheckAllSettings(self.settings.filter.expansion)
    if settingsResult then
        return true
    end

    local mountResult = self:CheckMountInList(self.settings.filter.expansion, MountJournalEnhancedExpansion, spellId)
    if mountResult ~= nil then
        return mountResult
    end

    for expansion, value in pairs(self.settings.filter.expansion) do
        if MountJournalEnhancedExpansion[expansion] and
                MountJournalEnhancedExpansion[expansion]["minID"] <= spellId and
                spellId <= MountJournalEnhancedExpansion[expansion]["maxID"]
        then
            return value
        end
    end

    return false
end

function private:FilterMountsByType(spellId, mountID)
    local settingsResult = self:CheckAllSettings(self.settings.filter.mountType)
    if settingsResult then
        return true
    end

    local mountResult = self:CheckMountInList(self.settings.filter.mountType, MountJournalEnhancedType, spellId)
    if mountResult == true then
        return true
    end

    local _, _, _, isSelfMount, mountType = C_MountJournal.GetMountInfoExtraByID(mountID)

    if (self.settings.filter.mountType.transform and isSelfMount) then
        return true
    end

    for category, value in pairs(self.settings.filter.mountType) do
        if MountJournalEnhancedType[category] and
                MountJournalEnhancedType[category].typeIDs and
                tContains(MountJournalEnhancedType[category].typeIDs, mountType) then
            return value
        end
    end

    return true
end

--endregion

function private:UpdateMountInfoCache()
    local mountInfoCache = { }
    local indexMap = { }
    indexMap[0] = 0

    local searchString = MountJournal.searchBox:GetText()
    if (not searchString or string.len(searchString) == 0) then
        searchString = nil
    else
        searchString = string.lower(searchString)
    end

    for i=1, self.hooks["GetNumDisplayedMounts"]() do
        local creatureName, spellId, icon, active, isUsable, sourceType, isFavorite, isFaction, faction, hideOnChar, isCollected, mountID = self.hooks["GetDisplayedMountInfo"](i)
    
        isUsable = isUsable and IsUsableSpell(spellId)

        if (hideOnChar ~= true and
                not MountJournalEnhancedIgnored[spellId] and
                (searchString and self:FilterMountsByName(creatureName, searchString) or
                        (not searchString and
                        self:FilterHiddenMounts(spellId) and
                        self:FilterFavoriteMounts(isFavorite) and
                        self:FilterUsableMounts(isUsable) and
                        self:FilterCollectedMounts(isCollected) and
                        self:FilterMountsBySource(spellId, sourceType) and
                        self:FilterMountsByFaction(isFaction, faction) and
                        self:FilterMountsByType(spellId, mountID) and
                        self:FilterMountsByFamily(spellId) and
                        self:FilterMountsByExpansion(spellId)))) then
            mountInfoCache[#mountInfoCache + 1] = { creatureName, spellId, icon, active, isUsable, sourceType, isFavorite, isFaction, faction, hideOnChar, isCollected, mountID }
            indexMap[#mountInfoCache] = i
        end
    end

    self.mountInfoCache = mountInfoCache
    self.indexMap = indexMap
end

function private:MountListItem_OnClick(sender, anchor, button)
    if ( button ~= "LeftButton" ) then
        local _, _, _, _, _, _, _, _, _, _, isCollected = C_MountJournal.GetDisplayedMountInfo(sender.index)
        if not isCollected then
            MountJournal_ShowMountDropdown(sender.index, anchor, 0, 0)
        end
    end
end

function private:MountListItem_OnDoubleClick(sender, button)
    if (button == "LeftButton") then
        local _, _, _, _, _, _, _, _, _, _, _, mountID = C_MountJournal.GetDisplayedMountInfo(sender.index)
        C_MountJournal.SummonByID(mountID)
    end
end

function private:MountJournal_OnSearchTextChanged(sender)
    SearchBoxTemplate_OnTextChanged(sender)
    
    self:UpdateMountInfoCache()
    MountJournal_UpdateMountList()
end

function private:Hook(obj, name, func)
    local hook = self.hooks[name]
    if (hook ~= nil) then
        return false
    end

    if (obj == nil) then
        self.hooks[name] = _G[name]
        _G[name] = func
    else
        self.hooks[name] = obj[name]
        obj[name] = func
    end

    return true
end

function private:Unhook(obj, name)
    local hook = self.hooks[name]
    if (hook == nil) then
        return false
    end

    if (obj == nil) then
        _G[name] = hook
    else
        obj[name] = hook
    end
    self.hooks[name] = nil

    return true
end

function private:Load()
    self:LoadUI()
    if self.settings.debugMode then
        self:RunDebugMode()
    end

    self:AddEventHandler("COMPANION_LEARNED", function() self:OnMountsUpdated() end)
    self:AddEventHandler("ACHIEVEMENT_EARNED", function() self:OnMountsUpdated() end)
    self:AddEventHandler("ACHIEVEMENT_EARNED", function() self:OnAchievement() end)
    self:AddEventHandler("SPELL_UPDATE_USABLE", function() self:OnSpellUpdated() end)

    self:AddSlashCommand("MOUNTJOURNALENHANCED", function(...) private:OnSlashCommand(...) end, 'mountjournalenhanced', 'mje')
end

function private:OnMountsUpdated()
    self:UpdateMountInfoCache()

    self.characterMountCountFrame.uniqueCount:SetText(GetNumCompanions("MOUNT"))
end

function private:OnAchievement()
    self.achievementFrame.staticText:SetText(GetCategoryAchievementPoints(MOUNT_ACHIEVEMENT_CATEGORY, true))
end

function private:OnSpellUpdated()
    if (CollectionsJournal:IsShown()) then
        self:UpdateMountInfoCache()
        MountJournal_UpdateMountList()
    end
end

function private:OnSlashCommand(command, parameter1, parameter2)
    if (command == "debug") then
        if (parameter1 == "on") then
            self.settings.debugMode = true
            print("MountJournalEnhanced: Debug mode activated.")
            self:RunDebugMode()
        elseif (parameter1 == "off") then
            self.settings.debugMode = false
            print("MountJournalEnhanced: Debug mode deactivated.")
        end
    elseif (command == "shop") then
        if (parameter1 == "on") then
            self.settings.showShopButton = true
            print("MountJournalEnhanced: shop button activated.")
            self:ToggleShopButton()
        elseif (parameter1 == "off") then
            self.settings.showShopButton = false
            print("MountJournalEnhanced: shop button deactivated.")
            self:ToggleShopButton()
        end
    else
        print("Syntax:")
        print("/mje shop (on | off)")
        print("/mje debug (on | off)")
    end
end