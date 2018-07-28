local ADDON_NAME, ADDON = ...

local EXPANSIONS = { "Classic", "The Burning Crusade", "Wrath of the Lich King", "Cataclysm", "Mists of Pandaria", "Warlords of Draenor", "Legion", "Battle for Azeroth" }
local SOURCE_INDEX_ORDER = { "Drop", "Quest", "Vendor", "Profession", "Instance", "Reputation", "Achievement", "Island Expedition", "Garrison", "PVP", "Class", "World Event", "Black Market", "Shop", "Promotion"}

local L = ADDON.L
local MountJournalEnhancedFamily = ADDON.MountJournalEnhancedFamily
local MountJournalEnhancedSource = ADDON.MountJournalEnhancedSource
local MountJournalEnhancedExpansion = ADDON.MountJournalEnhancedExpansion
local MountJournalEnhancedType = ADDON.MountJournalEnhancedType
local MountJournalEnhancedIgnored = ADDON.MountJournalEnhancedIgnored

ADDON.hooks = { }
ADDON.mountInfoCache = nil
ADDON.indexMap = { }

function ADDON:LoadUI()
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

    self:CreateCharacterMountCount()
    self:CreateAchievementPoints()
    self:CreateShopButton()

    self:UpdateMountInfoCache()
    MountJournal_UpdateMountList()

    local frame = CreateFrame("frame");
    frame:RegisterEvent("SPELL_UPDATE_USABLE")
    frame:SetScript("OnEvent", function(sender, ...)
        if (CollectionsJournal:IsShown()) then
            ADDON:UpdateMountInfoCache()
            MountJournal_UpdateMountList()
        end
    end);
end

--region Hooks

function ADDON:C_MountJournal_GetNumDisplayedMounts()
    if (not self.mountInfoCache) then
        self:UpdateMountInfoCache()
    end

    return #self.mountInfoCache
end

function ADDON:C_MountJournal_GetDisplayedMountInfo(index)
    if (not self.mountInfoCache) then
        self:UpdateMountInfoCache()
    end
    
    local mountInfo = self.mountInfoCache[index]
    if (not mountInfo) then
        return nil
    end
    
    return unpack(mountInfo)
end

function ADDON:C_MountJournal_Pickup(index)
    if (not self.mountInfoCache) then
        self:UpdateMountInfoCache()
    end

    local displayedIndex = self.indexMap[index]
    self.hooks["Pickup"](displayedIndex)
end

function ADDON:C_MountJournal_GetDisplayedMountInfoExtra(index)
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

function ADDON:C_MountJournal_SetIsFavorite(index, isFavorited)
    if (not self.mountInfoCache) then
        self:UpdateMountInfoCache()
    end

    local displayedIndex = self.indexMap[index]
    self.hooks["SetIsFavorite"](displayedIndex, isFavorited)
end

function ADDON:C_MountJournal_GetIsFavorite(index)
    if (not self.mountInfoCache) then
        self:UpdateMountInfoCache()
    end

    local displayedIndex = self.indexMap[index]
    return self.hooks["GetIsFavorite"](displayedIndex)
end

--endregion Hooks

--region dropdown menus
function ADDON:CreateFilterInfo(text, filterKey, subfilterKey, callback)
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

function ADDON:AddCheckAllAndNoneInfo(filterKey, level, dropdownLevel)
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

function ADDON:MountJournalFilterDropDown_Initialize(sender, level)
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
            ADDON:ResetFilterSettings();
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

function ADDON:MakeMultiColumnMenu(level, entriesPerColumn)
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

function ADDON:MountOptionsMenu_Init(sender, level)
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

function ADDON:MountJournal_UpdateMountList()
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

function ADDON:FilterMountsByName(name, searchString)
    return string.find(string.lower(name), searchString, 1, true)
end

function ADDON:FilterHiddenMounts(spellId)
    return self.settings.filter.hidden or not self.settings.hiddenMounts[spellId]
end

function ADDON:FilterFavoriteMounts(isFavorite)
    return isFavorite or not self.settings.filter.onlyFavorites or not self.settings.filter.collected
end

function ADDON:FilterUsableMounts(isUsable)
    return not self.settings.filter.onlyUsable or isUsable
end

function ADDON:FilterCollectedMounts(collected)
    return (self.settings.filter.collected and collected) or (self.settings.filter.notCollected and not collected)
end

function ADDON:CheckAllSettings(settings)
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

function ADDON:CheckMountInList(settings, sourceData, spellId)
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

function ADDON:FilterMountsBySource(spellId, sourceType)

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

function ADDON:FilterMountsByFaction(isFaction, faction)
    return (self.settings.filter.faction.noFaction and not isFaction or self.settings.filter.faction.alliance and faction == 1 or self.settings.filter.faction.horde and faction == 0)
end

function ADDON:SearchInList(searchTerms, text)
    if searchTerms then
        for _, searchTerm in pairs(searchTerms) do
            if string.find(text, searchTerm, 1, true) then
                return true
            end
        end
    end

    return false
end

function ADDON:FilterMountsByFamily(spellId)

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

function ADDON:FilterMountsByExpansion(spellId)

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

function ADDON:FilterMountsByType(spellId, mountID)
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

function ADDON:UpdateMountInfoCache()
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

function ADDON:MountListItem_OnClick(sender, anchor, button)
    if ( button ~= "LeftButton" ) then
        local _, _, _, _, _, _, _, _, _, _, isCollected = C_MountJournal.GetDisplayedMountInfo(sender.index)
        if not isCollected then
            MountJournal_ShowMountDropdown(sender.index, anchor, 0, 0)
        end
    end
end

function ADDON:MountListItem_OnDoubleClick(sender, button)
    if (button == "LeftButton") then
        local _, _, _, _, _, _, _, _, _, _, _, mountID = C_MountJournal.GetDisplayedMountInfo(sender.index)
        C_MountJournal.SummonByID(mountID)
    end
end

function ADDON:MountJournal_OnSearchTextChanged(sender)
    SearchBoxTemplate_OnTextChanged(sender)
    
    self:UpdateMountInfoCache()
    MountJournal_UpdateMountList()
end

function ADDON:Hook(obj, name, func)
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

function ADDON:Unhook(obj, name)
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

local function Load()
    if not ADDON.initialized then
        ADDON.initialized = true
        ADDON:LoadSettings()
        ADDON:LoadUI()
        if ADDON.settings.debugMode then
            ADDON:RunDebugTest()
        end
    end
end

hooksecurefunc("CollectionsJournal_LoadUI", Load)
hooksecurefunc("SetCollectionsJournalShown", Load)