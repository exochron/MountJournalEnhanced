local ADDON_NAME = ...;

local COLLECTION_ACHIEVEMENT_CATEGORY = 15246;
local MOUNT_ACHIEVEMENT_CATEGORY = 15248;
local MOUNT_COUNT_STATISTIC = 339;
local EXPANSIONS = { "Classic", "The Burning Crusade", "Wrath of the Lich King", "Cataclysm", "Mists of Pandaria", "Warlords of Draenor", "Legion" };

local L = CoreFramework:GetModule("Localization", "1.1"):GetLocalization(ADDON_NAME);

local initialState = {
    settings = {
        debugMode = false,
        hiddenMounts = { },
        filter = {
            collected = true,
            notCollected = true,
            onlyFavorites = false,
            onlyUsable = false,
            source = { },
            additionalSource = {
                pvp = true,
            },
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
};
for _, category in pairs(MountJournalEnhancedSource) do
    initialState.settings.filter.source[category.Name] = true;
end
for categoryName, _ in pairs(MountJournalEnhancedFamily) do
    initialState.settings.filter.family[categoryName] = true;
end
for expansionName, _ in pairs(MountJournalEnhancedExpansion) do
    initialState.settings.filter.expansion[expansionName] = true;
end
local dependencies = {
    function() return MountJournal or LoadAddOn("Blizzard_Collections"); end,
};
local private = CoreFramework:GetModule("Addon", "1.0"):NewAddon(ADDON_NAME, initialState, dependencies);

private.hooks = { };
private.mountInfoCache = nil;
private.indexMap = { };

function private:LoadUI()
	C_MountJournal.SetCollectedFilterSetting(LE_MOUNT_JOURNAL_FILTER_COLLECTED, true);
	C_MountJournal.SetCollectedFilterSetting(LE_MOUNT_JOURNAL_FILTER_NOT_COLLECTED, true);

    PetJournal:HookScript("OnShow", function() if (not PetJournalPetCard.petID) then PetJournal_ShowPetCard(1); end end);

    self:Hook(C_MountJournal, "GetNumDisplayedMounts", function() return self:C_MountJournal_GetNumDisplayedMounts(); end);
    self:Hook(C_MountJournal, "GetDisplayedMountInfo", function(index) return self:C_MountJournal_GetDisplayedMountInfo(index); end);
    self:Hook(C_MountJournal, "Pickup", function(index) self:C_MountJournal_Pickup(index); end);
    self:Hook(C_MountJournal, "SetIsFavorite", function(index, isFavorited) self:C_MountJournal_SetIsFavorite(index, isFavorited); end);
    self:Hook(C_MountJournal, "GetIsFavorite", function(index) return self:C_MountJournal_GetIsFavorite(index); end);
    self:Hook(C_MountJournal, "GetDisplayedMountInfoExtra", function(index) return self:C_MountJournal_GetDisplayedMountInfoExtra(index); end);
    
    self:Hook(nil, "MountJournal_UpdateMountList", function() self:MountJournal_UpdateMountList(); end);
    MountJournal.ListScrollFrame.update = function() self:MountJournal_UpdateMountList() end;

    MountJournalSearchBox:SetScript("OnTextChanged", function(sender) self:MountJournal_OnSearchTextChanged(sender); end);
    
    hooksecurefunc(MountJournal.mountOptionsMenu, "initialize", function(sender, level) UIDropDownMenu_InitializeHelper(sender); self:MountOptionsMenu_Init(sender, level); end);
    hooksecurefunc(MountJournalFilterDropDown, "initialize", function(sender, level) UIDropDownMenu_InitializeHelper(sender); self:MountJournalFilterDropDown_Initialize(sender, level); end);

    self:Hook(nil, "MountListItem_OnClick", function(sender, button) self:MountListItem_OnClick(sender, button); end);
    self:Hook(nil, "MountListDragButton_OnClick", function(sender, button) self:MountListDragButton_OnClick(sender, button); end);
    
    local buttons = MountJournal.ListScrollFrame.buttons;
    for buttonIndex = 1, #buttons do
        local button = buttons[buttonIndex];
        button:SetScript("OnClick", function(sender, mouseButton) self:MountListItem_OnClick(sender, mouseButton); end);
        button:SetScript("OnDoubleClick", function(sender, mouseButton) self:MountListItem_OnDoubleClick(sender, mouseButton); end);
        button.DragButton:SetScript("OnClick", function(sender, mouseButton) self:MountListDragButton_OnClick(sender, mouseButton); end);
        button.DragButton.IsHidden = button.DragButton:CreateTexture(nil, "OVERLAY");
        button.DragButton.IsHidden:SetTexture("Interface\\BUTTONS\\UI-GroupLoot-Pass-Up");
        button.DragButton.IsHidden:SetSize(36, 36);
        button.DragButton.IsHidden:SetPoint("CENTER", button.DragButton, "CENTER", 0, 0);
        button.DragButton.IsHidden:SetDrawLayer("OVERLAY", 1);
        button.DragButton.IsHidden:SetShown(false);
    end
   
    self:CreateCharacterMountCountFrame();
    self:CreateAchievementFrame();
    
    self:UpdateMountInfoCache();
    MountJournal_UpdateMountList();
end

function private:CreateCharacterMountCountFrame()
    local frame = CreateFrame("frame", "MJECharacterMountCount", MountJournal, "InsetFrameTemplate3");

    frame:ClearAllPoints();
    frame:SetPoint("TOPLEFT", MountJournal, 70, -42);
    frame:SetSize(130, 18);

    frame.staticText = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall");
    frame.staticText:ClearAllPoints();
    frame.staticText:SetPoint("LEFT", frame, 10, 0);
    frame.staticText:SetText(CHARACTER);

    frame.uniqueCount = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
    frame.uniqueCount:ClearAllPoints();
    frame.uniqueCount:SetPoint("RIGHT", frame, -10, 0);
    --frame.uniqueCount:SetText(GetNumCompanions("MOUNT"));
	local _, _, _, mountCount = GetAchievementCriteriaInfo(MOUNT_COUNT_STATISTIC, 1);
	frame.uniqueCount:SetText(mountCount);

    MountJournal.MountCount:SetPoint("TopLeft", 70, -22);
    MountJournal.MountCount:SetSize(130, 18);
    
    self.characterMountCountFrame = frame;
end

function private:CreateAchievementFrame()
    local frame = CreateFrame("Button", "MJEMountAchievementStatus", MountJournal);

    frame:ClearAllPoints();
    frame:SetPoint("TOP", MountJournal, 0, -21);
    frame:SetSize(60, 40);

    frame.bgLeft = frame:CreateTexture(nil, "BACKGROUND");
    frame.bgLeft:SetAtlas("PetJournal-PetBattleAchievementBG");
    frame.bgLeft:ClearAllPoints();
    frame.bgLeft:SetSize(46, 18);
    frame.bgLeft:SetPoint("Top", -56, -12);
    frame.bgLeft:SetVertexColor(1, 1, 1, 1);

    frame.bgRight = frame:CreateTexture(nil, "BACKGROUND");
    frame.bgRight:SetAtlas("PetJournal-PetBattleAchievementBG");
    frame.bgRight:ClearAllPoints();
    frame.bgRight:SetSize(46, 18);
    frame.bgRight:SetPoint("Top", 55, -12);
    frame.bgRight:SetVertexColor(1, 1, 1, 1);
    frame.bgRight:SetTexCoord(1, 0, 0, 1);

    frame.highlight = frame:CreateTexture(nil);
    frame.highlight:SetDrawLayer("BACKGROUND", 1);
    frame.highlight:SetAtlas("PetJournal-PetBattleAchievementGlow");
    frame.highlight:ClearAllPoints();
    frame.highlight:SetSize(210, 40);
    frame.highlight:SetPoint("CENTER", 0, 0);
    frame.highlight:SetShown(false);

    frame.icon = frame:CreateTexture(nil, "OVERLAY");
    frame.icon:SetTexture("Interface\\AchievementFrame\\UI-Achievement-Shields-NoPoints");
    frame.icon:ClearAllPoints();
    frame.icon:SetSize(30, 30);
    frame.icon:SetPoint("RIGHT", 0, -5);
    frame.icon:SetTexCoord(0, 0.5, 0, 0.5);

    frame.staticText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge");
    frame.staticText:ClearAllPoints();
    frame.staticText:SetPoint("RIGHT", frame.icon, "LEFT", -4, 4);
    frame.staticText:SetSize(0, 0);
    frame.staticText:SetText(GetCategoryAchievementPoints(MOUNT_ACHIEVEMENT_CATEGORY, true));

    frame:SetScript("OnClick", function()
        ToggleAchievementFrame();
        local i = 1;
        local button = _G["AchievementFrameCategoriesContainerButton" .. i];
        while button do
            if (button.element.id == COLLECTION_ACHIEVEMENT_CATEGORY) then
                button:Click();
                button = nil;
            else
                i = i + 1;
                button = _G["AchievementFrameCategoriesContainerButton" .. i];
            end
        end

        i = 1;
        button = _G["AchievementFrameCategoriesContainerButton" .. i];
        while button do
            if (button.element.id == MOUNT_ACHIEVEMENT_CATEGORY) then
                button:Click();
                return;
            end

            i = i + 1;
            button = _G["AchievementFrameCategoriesContainerButton" .. i];
        end
    end);
    frame:SetScript("OnEnter", function() frame.highlight:SetShown(true); end);
    frame:SetScript("OnLeave", function() frame.highlight:SetShown(false); end);

    self.achievementFrame = frame;
end

function private:LoadDebugMode()
    if (self.settings.debugMode) then
        print("MountJournalEnhanced: Debug mode activated");

        local mounts = {};   
        local mountIDs = C_MountJournal.GetMountIDs();
        for i, mountID in ipairs(mountIDs) do
            local name, spellID = C_MountJournal.GetMountInfoByID(mountID);
            mounts[spellID] = name;
        end
        
        for id, name in pairs(mounts) do
            if (not MountJournalEnhancedIgnored[id]) then
                local contained = self:ContainsItem(MountJournalEnhancedSource, id);
                if (not contained) then
                    print("New mount: " .. name .. " (" .. id .. ")");
                end
            end
        end

        for id, name in pairs(mounts) do
            if (not MountJournalEnhancedIgnored[id]) then
                local contained = false;
                for _, familyMounts in pairs(MountJournalEnhancedFamily) do
                    if (familyMounts[id]) then
                        contained = true;
                        break;
                    end
                end
                if (not contained) then
                    print("No family info for mount: " .. name .. " (" .. id .. ")");
                end
            end
        end

        for id, name in pairs(mounts) do
            if (not MountJournalEnhancedIgnored[id]) then
                local contained = false;
                for _, expansionMounts in pairs(MountJournalEnhancedExpansion) do
                    if (expansionMounts[id]) then
                        contained = true;
                        break;
                    end
                end
                if (not contained) then
                    print("No expansion info for mount: " .. name .. " (" .. id .. ")");
                end
            end
        end
		
        for _, familyMounts in pairs(MountJournalEnhancedFamily) do
            for id, name in pairs(familyMounts) do
                if (not MountJournalEnhancedIgnored[id]) then
                    if (not mounts[id]) then
                        print("Old family info for mount: " .. name .. " (" .. id .. ")");
                    end
                end
            end
        end
		
        for _, expansionMounts in pairs(MountJournalEnhancedExpansion) do
            for id, name in pairs(expansionMounts) do
                if (not MountJournalEnhancedIgnored[id]) then
                    if (not mounts[id]) then
                        print("Old expansion info for mount: " .. name .. " (" .. id .. ")");
                    end
                end
            end
        end

        local names = { };
        for _, category in pairs(MountJournalEnhancedSource) do
            for id, name in pairs(category.Data) do
                if (names[id] and names[id] ~= name) then
                    print("Invalide mount info for mount: " .. name .. " (" .. id .. ")");
                end
                names[id] = name;
            end
        end
    end
end

function private:ContainsItem(data, spellId)
    local contained = false;

    for _, category in pairs(data) do
        for id, name in pairs(category.Data) do
            if (spellId == id) then
                contained = true;
                break;
            end
        end

        if (contained) then
            break;
        end
    end

    return contained;
end

--region Hooks

function private:C_MountJournal_GetNumDisplayedMounts()
    if (not self.mountInfoCache) then
        self:UpdateMountInfoCache();
    end

    return #self.mountInfoCache;
end

function private:C_MountJournal_GetDisplayedMountInfo(index)
    if (not self.mountInfoCache) then
        self:UpdateMountInfoCache();
    end
    
    local mountInfo = self.mountInfoCache[index];
    if (not mountInfo) then
        return nil;
    end
    
    return unpack(mountInfo);
end

function private:C_MountJournal_Pickup(index)
    if (not self.mountInfoCache) then
        self:UpdateMountInfoCache();
    end

    local displayedIndex = self.indexMap[index];
    self.hooks["Pickup"](displayedIndex);
end

function private:C_MountJournal_GetDisplayedMountInfoExtra(index)
    if (not self.mountInfoCache) then
        self:UpdateMountInfoCache();
    end

    local mountInfo = self.mountInfoCache[index];
    if (not mountInfo) then
        return nil;
    end
    
    local _, _, _, _, _, _, _, _, _, _, _, mountID = unpack(mountInfo);
    return C_MountJournal.GetMountInfoExtraByID(mountID);
end

function private:C_MountJournal_SetIsFavorite(index, isFavorited)
    if (not self.mountInfoCache) then
        self:UpdateMountInfoCache();
    end

    local displayedIndex = self.indexMap[index];
    self.hooks["SetIsFavorite"](displayedIndex, isFavorited);
end

function private:C_MountJournal_GetIsFavorite(index)
    if (not self.mountInfoCache) then
        self:UpdateMountInfoCache();
    end

    local displayedIndex = self.indexMap[index];
    return self.hooks["GetIsFavorite"](displayedIndex);
end

--endregion Hooks

function private:MountJournalFilterDropDown_Initialize(sender, level)
    local info = UIDropDownMenu_CreateInfo();
    info.keepShownOnClick = true;
    info.isNotRadio = true;
        
    if (level == 1) then
        info.text = COLLECTED
        info.func = function(_, _, _, value)
            self.settings.filter.collected = value;
            self:UpdateMountInfoCache();
            MountJournal_UpdateMountList();

            if (value) then
                UIDropDownMenu_EnableButton(1,2);
            else
                UIDropDownMenu_DisableButton(1,2);
            end;
        end
        info.checked = self.settings.filter.collected;
        UIDropDownMenu_AddButton(info, level)

        info.text = FAVORITES_FILTER;
        info.leftPadding = 16;
        info.disabled = not self.settings.filter.collected;
        info.checked = self.settings.filter.onlyFavorites;
        info.notCheckable = false;
        info.hasArrow = false;
        info.func = function(_, _, _, value)
            self.settings.filter.onlyFavorites = value;
            self:UpdateMountInfoCache();
            MountJournal_UpdateMountList();
         end
        UIDropDownMenu_AddButton(info, level);

        info.leftPadding = 0;
        info.disabled = false;

        info.text = NOT_COLLECTED
        info.func = function(_, _, _, value)
             self.settings.filter.notCollected = value;
             self:UpdateMountInfoCache();
             MountJournal_UpdateMountList();
         end
        info.checked = self.settings.filter.notCollected;
        UIDropDownMenu_AddButton(info, level)

        info.text = L["Only usable"];
        info.func = function(_, _, _, value)
            self.settings.filter.onlyUsable = value;
            self:UpdateMountInfoCache();
            MountJournal_UpdateMountList();
        end
        info.checked = self.settings.filter.onlyUsable;
        info.notCheckable = false;
        info.hasArrow = false;
        UIDropDownMenu_AddButton(info, level);

        info.text = SOURCES;
        info.checked = nil;
        info.func =  nil;
        info.hasArrow = true;
        info.notCheckable = true;
        info.value = 1;
        UIDropDownMenu_AddButton(info, level)

        info.text = TYPE;
        info.notCheckable = true;
        info.hasArrow = true;
        info.value = 2;
        UIDropDownMenu_AddButton(info, level);

        info.text = FACTION;
        info.notCheckable = true;
        info.hasArrow = true;
        info.value = 3;
        UIDropDownMenu_AddButton(info, level);

        info.text = L["Family"];
        info.notCheckable = true;
        info.hasArrow = true;
        info.value = 4;
        UIDropDownMenu_AddButton(info, level);

        info.text = L["Expansion"];
        info.notCheckable = true;
        info.hasArrow = true;
        info.value = 5;
        UIDropDownMenu_AddButton(info, level);
		
        info.text = L["Hidden"];
        info.checked = self.settings.filter.hidden;
        info.notCheckable = false;
        info.hasArrow = false;
        info.func = function(_, _, _, value)
            self.settings.filter.hidden = value;
            self:UpdateMountInfoCache();
            MountJournal_UpdateMountList();
        end
        UIDropDownMenu_AddButton(info, level);
        
        info.text = L["Reset filters"];
        info.keepShownOnClick = false;
        info.notCheckable = true;
        info.hasArrow = false;
        info.func = function(_, _, _, value)
            self.settings.filter.collected = true;
            self.settings.filter.onlyFavorites = false;
            self.settings.filter.notCollected = true;
            self.settings.filter.onlyUsable = false;
            self.settings.filter.hidden = false;
        
            for _, category in pairs(MountJournalEnhancedSource) do
                self.settings.filter.source[category.Name] = true;
            end
            
            for k, v in pairs(self.settings.filter.mountType) do
                self.settings.filter.mountType[k] = true;
            end
                
            self.settings.filter.faction.alliance = true;
            self.settings.filter.faction.horde = true;
            self.settings.filter.faction.noFaction = true;
            
            for k, v in pairs(self.settings.filter.family) do
                self.settings.filter.family[k] = true;
            end
            
            for k, v in pairs(self.settings.filter.expansion) do
                self.settings.filter.expansion[k] = true;
            end
            
            self:UpdateMountInfoCache();
            MountJournal_UpdateMountList();
        end
        UIDropDownMenu_AddButton(info, level);
    else
        if (UIDROPDOWNMENU_MENU_VALUE == 1) then
            info.hasArrow = false;
            info.isNotRadio = true;
            info.notCheckable = true;

            info.text = CHECK_ALL
            info.func = function()
                for _, category in pairs(MountJournalEnhancedSource) do
                    self.settings.filter.source[category.Name] = true;
                end

                UIDropDownMenu_Refresh(MountJournalFilterDropDown, 1, 2);
                self:UpdateMountInfoCache();
                MountJournal_UpdateMountList();
            end
            UIDropDownMenu_AddButton(info, level)

            info.text = UNCHECK_ALL
            info.func = function()
                for _, category in pairs(MountJournalEnhancedSource) do
                    self.settings.filter.source[category.Name] = false;
                end

                UIDropDownMenu_Refresh(MountJournalFilterDropDown, 1, 2);
                self:UpdateMountInfoCache();
                MountJournal_UpdateMountList();
            end
            UIDropDownMenu_AddButton(info, level)

            for _, category in pairs(MountJournalEnhancedSource) do
                info.text = L[category.Name] or category.Name;
                info.func = function(_, _, _, value)
                    self.settings.filter.source[category.Name] = value;
                    self:UpdateMountInfoCache();
                    MountJournal_UpdateMountList();
                end
                info.checked = function() return self.settings.filter.source[category.Name] ~= false; end;
                info.isNotRadio = true;
                info.notCheckable = false;
                info.hasArrow = false;
                UIDropDownMenu_AddButton(info, level);
            end
        end

        if (UIDROPDOWNMENU_MENU_VALUE == 2) then
            info.hasArrow = false;
            info.isNotRadio = true;
            info.notCheckable = true;

            info.text = CHECK_ALL
            info.func = function()
                for k, v in pairs(self.settings.filter.mountType) do
                    self.settings.filter.mountType[k] = true;
                end
                UIDropDownMenu_Refresh(MountJournalFilterDropDown, 2, 2);
                self:UpdateMountInfoCache();
                MountJournal_UpdateMountList();
            end
            UIDropDownMenu_AddButton(info, level)

            info.text = UNCHECK_ALL
            info.func = function()
                for k, v in pairs(self.settings.filter.mountType) do
                    self.settings.filter.mountType[k] = false;
                end
                UIDropDownMenu_Refresh(MountJournalFilterDropDown, 2, 2);
                self:UpdateMountInfoCache();
                MountJournal_UpdateMountList();
            end
            UIDropDownMenu_AddButton(info, level)

            info.text = L["Ground"];
            info.func = function(_, _, _, value)
                self.settings.filter.mountType.ground = value;
                self:UpdateMountInfoCache();
                MountJournal_UpdateMountList();
            end
            info.checked = function() return self.settings.filter.mountType.ground; end;
            info.isNotRadio = true;
            info.notCheckable = false;
            info.hasArrow = false;
            UIDropDownMenu_AddButton(info, level);

            info.text = L["Flying"];
            info.func = function(_, _, _, value)
                self.settings.filter.mountType.flying = value;
                self:UpdateMountInfoCache();
                MountJournal_UpdateMountList();
            end
            info.checked = function() return self.settings.filter.mountType.flying; end;
            info.isNotRadio = true;
            info.notCheckable = false;
            info.hasArrow = false;
            UIDropDownMenu_AddButton(info, level);

            info.text = L["Water Walking"];
            info.func = function(_, _, _, value)
                self.settings.filter.mountType.waterWalking = value;
                self:UpdateMountInfoCache();
                MountJournal_UpdateMountList();
            end
            info.checked = function() return self.settings.filter.mountType.waterWalking; end;
            info.isNotRadio = true;
            info.notCheckable = false;
            info.hasArrow = false;
            UIDropDownMenu_AddButton(info, level);

            info.text = L["Underwater"];
            info.func = function(_, _, _, value)
                self.settings.filter.mountType.underwater = value;
                self:UpdateMountInfoCache();
                MountJournal_UpdateMountList();
            end
            info.checked = function() return self.settings.filter.mountType.underwater; end;
            info.isNotRadio = true;
            info.notCheckable = false;
            info.hasArrow = false;
            UIDropDownMenu_AddButton(info, level);

            info.text = L["Transform"];
            info.func = function(_, _, _, value)
                self.settings.filter.mountType.transform = value;
                self:UpdateMountInfoCache();
                MountJournal_UpdateMountList();
            end
            info.checked = function() return self.settings.filter.mountType.transform; end;
            info.isNotRadio = true;
            info.notCheckable = false;
            info.hasArrow = false;
            UIDropDownMenu_AddButton(info, level);

            info.text = L["Repair"];
            info.func = function(_, _, _, value)
                self.settings.filter.mountType.repair = value;
                self:UpdateMountInfoCache();
                MountJournal_UpdateMountList();
            end
            info.checked = function() return self.settings.filter.mountType.repair; end;
            info.isNotRadio = true;
            info.notCheckable = false;
            info.hasArrow = false;
            UIDropDownMenu_AddButton(info, level);

            info.text = L["Passenger"];
            info.func = function(_, _, _, value)
                self.settings.filter.mountType.passenger = value;
                self:UpdateMountInfoCache();
                MountJournal_UpdateMountList();
            end
            info.checked = function() return self.settings.filter.mountType.passenger; end;
            info.isNotRadio = true;
            info.notCheckable = false;
            info.hasArrow = false;
            UIDropDownMenu_AddButton(info, level);
        end

        if (UIDROPDOWNMENU_MENU_VALUE == 3) then
            info.text = FACTION_ALLIANCE;
            info.func = function(_, _, _, value)
                self.settings.filter.faction.alliance = value;
                self:UpdateMountInfoCache();
                MountJournal_UpdateMountList();
            end
            info.checked = self.settings.filter.faction.alliance;
            info.isNotRadio = true;
            info.notCheckable = false;
            info.hasArrow = false;
            UIDropDownMenu_AddButton(info, level);

            info.text = FACTION_HORDE;
            info.func = function(_, _, _, value)
                self.settings.filter.faction.horde = value;
                self:UpdateMountInfoCache();
                MountJournal_UpdateMountList();
            end
            info.checked = self.settings.filter.faction.horde;
            info.isNotRadio = true;
            info.notCheckable = false;
            info.hasArrow = false;
            UIDropDownMenu_AddButton(info, level);

            info.text = NPC_NAMES_DROPDOWN_NONE;
            info.func = function(_, _, _, value)
                self.settings.filter.faction.noFaction = value;
                self:UpdateMountInfoCache();
                MountJournal_UpdateMountList();
            end
            info.checked = self.settings.filter.faction.noFaction;
            info.isNotRadio = true;
            info.notCheckable = false;
            info.hasArrow = false;
            UIDropDownMenu_AddButton(info, level);
        end

        if (UIDROPDOWNMENU_MENU_VALUE == 4) then
            info.hasArrow = false;
            info.isNotRadio = true;
            info.notCheckable = true;

            info.text = CHECK_ALL
            info.func = function()
                for k, v in pairs(self.settings.filter.family) do
                    self.settings.filter.family[k] = true;
                end
                UIDropDownMenu_Refresh(MountJournalFilterDropDown, 4, 2);
                self:UpdateMountInfoCache();
                MountJournal_UpdateMountList();
            end
            UIDropDownMenu_AddButton(info, level)

            info.text = UNCHECK_ALL
            info.func = function()
                for k, v in pairs(self.settings.filter.family) do
                    self.settings.filter.family[k] = false;
                end
                UIDropDownMenu_Refresh(MountJournalFilterDropDown, 4, 2);
                self:UpdateMountInfoCache();
                MountJournal_UpdateMountList();
            end
            UIDropDownMenu_AddButton(info, level)

            local sortedFamilies = {};
            for family, _ in pairs(MountJournalEnhancedFamily) do
                table.insert(sortedFamilies, family);
            end
            table.sort(sortedFamilies, function(a, b) return (L[a] or a) < (L[b] or b); end);

            for _, family in pairs(sortedFamilies) do
                info.text = L[family] or family;
                info.func = function(_, _, _, value)
                    self.settings.filter.family[family] = value;
                    self:UpdateMountInfoCache();
                    MountJournal_UpdateMountList();
                end
                info.checked = function() return self.settings.filter.family[family] end;
                info.isNotRadio = true;
                info.notCheckable = false;
                info.hasArrow = false;
                UIDropDownMenu_AddButton(info, level);
            end

            self:MakeMultiColumnMenu(level, 20);
        end
		
        if (UIDROPDOWNMENU_MENU_VALUE == 5) then
            info.hasArrow = false;
            info.isNotRadio = true;
            info.notCheckable = true;

            info.text = CHECK_ALL
            info.func = function()
                for k, v in pairs(self.settings.filter.expansion) do
                    self.settings.filter.expansion[k] = true;
                end
                UIDropDownMenu_Refresh(MountJournalFilterDropDown, 5, 2);
                self:UpdateMountInfoCache();
                MountJournal_UpdateMountList();
            end
            UIDropDownMenu_AddButton(info, level)

            info.text = UNCHECK_ALL
            info.func = function()
                for k, v in pairs(self.settings.filter.expansion) do
                    self.settings.filter.expansion[k] = false;
                end
                UIDropDownMenu_Refresh(MountJournalFilterDropDown, 5, 2);
                self:UpdateMountInfoCache();
                MountJournal_UpdateMountList();
            end
            UIDropDownMenu_AddButton(info, level)

			-- MountJournalEnhancedExpansion
            for _, expansion in pairs(EXPANSIONS) do
                info.text = L[expansion] or expansion;
                info.func = function(_, _, _, value)
                    self.settings.filter.expansion[expansion] = value;
                    self:UpdateMountInfoCache();
                    MountJournal_UpdateMountList();
                end
                info.checked = function() return self.settings.filter.expansion[expansion] end;
                info.isNotRadio = true;
                info.notCheckable = false;
                info.hasArrow = false;
                UIDropDownMenu_AddButton(info, level);
            end
        end
    end
end

function private:MakeMultiColumnMenu(level, entriesPerColumn)
    local listFrame = _G["DropDownList"..level];
    local columnWidth = listFrame.maxWidth + 25;

    local listFrameName = listFrame:GetName();
    local columnIndex = 0;
    for index = entriesPerColumn + 1, listFrame.numButtons do
        columnIndex = math.ceil(index / entriesPerColumn);
        local button = _G[listFrameName.."Button"..index];
        local yPos = -((button:GetID() - 1 - entriesPerColumn * (columnIndex - 1)) * UIDROPDOWNMENU_BUTTON_HEIGHT) - UIDROPDOWNMENU_BORDER_HEIGHT;

        button:ClearAllPoints();
        button:SetPoint("TOPLEFT", button:GetParent(), "TOPLEFT", columnWidth * (columnIndex - 1), yPos);
        button:SetWidth(columnWidth);
    end

    listFrame:SetHeight((min(listFrame.numButtons, entriesPerColumn) * UIDROPDOWNMENU_BUTTON_HEIGHT) + (UIDROPDOWNMENU_BORDER_HEIGHT * 2));
    listFrame:SetWidth(columnWidth * columnIndex);

    self:Hook(nil, "UIDropDownMenu_OnHide", function(sender)
        self:Unhook(listFrame, "SetWidth");
        self:Unhook(nil, "UIDropDownMenu_OnHide");
        UIDropDownMenu_OnHide(sender);
    end);
    self:Hook(listFrame, "SetWidth", function() end);
end

function private:MountOptionsMenu_Init(sender, level)
	if not MountJournal.menuMountIndex then
		return;
	end
    
    local info = UIDropDownMenu_CreateInfo();
    info.notCheckable = true;

    local needsFanfare = C_MountJournal.NeedsFanfare(MountJournal.menuMountID);
    
	if (needsFanfare) then
		info.text = UNWRAP;
	elseif ( active ) then
		info.text = BINDING_NAME_DISMOUNT;
	else
		info.text = MOUNT;
		info.disabled = not MountJournal.menuIsUsable;
	end
    
	info.func = function()
		if needsFanfare then
			MountJournal_Select(MountJournal.menuMountIndex);
		end
		MountJournalMountButton_UseMount(MountJournal.menuMountID);
	end;
    
    UIDropDownMenu_AddButton(info, level);
    
    local spellId = nil;
    local isCollected = false;
    if (MountJournal.menuMountIndex) then
        _, spellId, _, _, _, _, _, _, _, _, isCollected = C_MountJournal.GetDisplayedMountInfo(MountJournal.menuMountIndex);
    end
    
	if not needsFanfare and isCollected then
		info.disabled = nil;

		local canFavorite = false;
		local isFavorite = false;
		if (MountJournal.menuMountIndex) then
			 isFavorite, canFavorite = C_MountJournal.GetIsFavorite(MountJournal.menuMountIndex);
		end

		if (isFavorite) then
			info.text = BATTLE_PET_UNFAVORITE;
			info.func = function()
				C_MountJournal.SetIsFavorite(MountJournal.menuMountIndex, false);
                self:UpdateMountInfoCache();
                MountJournal_UpdateMountList();
			end
		else
			info.text = BATTLE_PET_FAVORITE;
			info.func = function()
				C_MountJournal.SetIsFavorite(MountJournal.menuMountIndex, true);
                self:UpdateMountInfoCache();
                MountJournal_UpdateMountList();                
			end
		end

		if (canFavorite) then
			info.disabled = false;
		else
			info.disabled = true;
		end

		UIDropDownMenu_AddButton(info, level);
	end
    
    if (spellId) then
        info.disabled = nil;
        if (self.settings.hiddenMounts[spellId]) then
            info.text = L["Show"];
            info.func = function()
                self.settings.hiddenMounts[spellId] = false;
                self:UpdateMountInfoCache();
                MountJournal_UpdateMountList();
            end;
        else
            info.text = L["Hide"];
            info.func = function()
                self.settings.hiddenMounts[spellId] = true;
                self:UpdateMountInfoCache();
                MountJournal_UpdateMountList();
            end;
        end
        UIDropDownMenu_AddButton(info, level);
    end

    info.disabled = nil;
    info.text = CANCEL
    info.func = nil
    UIDropDownMenu_AddButton(info, level)
end

function private:MountJournal_UpdateMountList()
    --self:UpdateMountInfoCache();

    self.hooks["MountJournal_UpdateMountList"]();

    local buttons = MountJournal.ListScrollFrame.buttons;
    for i = 1, #buttons do
        if (self.settings.hiddenMounts[buttons[i].spellID]) then
            buttons[i].DragButton.IsHidden:SetShown(true);
        else
            buttons[i].DragButton.IsHidden:SetShown(false);
        end
    end
end

function private:FilterMountsByName(name)
    local searchString = self:GetSearchText();
    if (not searchString or string.len(searchString) == 0) then
        return true;
    end
    
    return string.find(string.lower(name), searchString, 1, true);
end

function private:GetSearchText()
    return MountJournal.searchBox:GetText();
end

function private:FilterHiddenMounts(name, spellId)
    local searchString = self:GetSearchText();
    if (searchString and string.len(searchString) > 0) then
        return self:FilterMountsByName(name);
    end

    if (self.settings.filter.hidden) then
        return true;
    end

    return not self.settings.hiddenMounts[spellId];
end

function private:FilterFavoriteMounts(name, isFavorite)
    local searchString = self:GetSearchText();
    if (searchString and string.len(searchString) > 0) then
        return self:FilterMountsByName(name);
    end

    if (not self.settings.filter.onlyFavorites) then
        return true;
    end

    return isFavorite or not self.settings.filter.collected;
end

function private:FilterUsableMounts(name, isUsable)
    local searchString = self:GetSearchText();
    if (searchString and string.len(searchString) > 0) then
        return self:FilterMountsByName(name);
    end

    if (not self.settings.filter.onlyUsable) then
        return true;
    end

    return isUsable;
end

function private:FilterMountsBySource(name, spellId, collected, sourceType)
    local searchString = self:GetSearchText();
    if (searchString and string.len(searchString) > 0) then
        return self:FilterMountsByName(name);
    end

    if (not self.settings.filter.collected and collected) then
        return false;
    end

    if (not self.settings.filter.notCollected and not collected) then
        return false;
    end

    local notContainded = true;

    local allDisabled = true;
    local allEnabled = true;
    for k, value in pairs(self.settings.filter.source) do
        if (value) then
            allDisabled = false;
        else
            allEnabled = false;
        end
    end

    if (allEnabled) then
        return true;
    end

    for source, value in pairs(self.settings.filter.source) do
        for _, category in pairs(MountJournalEnhancedSource) do
            if (category.Name == source) then
                if (category.Data[spellId]) then
                    if (value) then
                        return true;
                    else
                        notContainded = false;
                    end
                end
                break;
            end
        end
    end

    return notContainded and (allDisabled or allEnabled);
end

function private:FilterMountsByFaction(name, isFaction, faction)
    local searchString = self:GetSearchText();
    if (searchString and string.len(searchString) > 0) then
        return self:FilterMountsByName(name);
    end

    return (self.settings.filter.faction.noFaction and not isFaction or self.settings.filter.faction.alliance and faction == 1 or self.settings.filter.faction.horde and faction == 0);
end

function private:FilterMountsByFamily(name, spellId)
    local searchString = self:GetSearchText();
    if (searchString and string.len(searchString) > 0) then
        return self:FilterMountsByName(name);
    end

    local notContainded = true;

    local allDisabled = true;
    local allEnabled = true;
    for _, value in pairs(self.settings.filter.family) do
        if (value) then
            allDisabled = false;
        else
            allEnabled = false;
        end
    end

    if (allEnabled) then
        return true;
    end

    for family, value in pairs(self.settings.filter.family) do
        if (MountJournalEnhancedFamily[family]) then
            if (MountJournalEnhancedFamily[family][spellId]) then
                if (value) then
                    return true;
                else
                    notContainded = false;
                end
            end
        end
    end

    return notContainded and (allDisabled or allEnabled);
end

function private:FilterMountsByExpansion(name, spellId)
    local searchString = self:GetSearchText();
    if (searchString and string.len(searchString) > 0) then
        return self:FilterMountsByName(name);
    end

    local notContainded = true;

    local allDisabled = true;
    local allEnabled = true;
    for _, value in pairs(self.settings.filter.expansion) do
        if (value) then
            allDisabled = false;
        else
            allEnabled = false;
        end
    end

    if (allEnabled) then
        return true;
    end

    for expansion, value in pairs(self.settings.filter.expansion) do
        if (MountJournalEnhancedExpansion[expansion]) then
            if (MountJournalEnhancedExpansion[expansion][spellId]) then
                if (value) then
                    return true;
                else
                    notContainded = false;
                end
            end
        end
    end

    return notContainded and (allDisabled or allEnabled);
end

function private:FilterMountsByType(name, spellId, mountID)
    local searchString = self:GetSearchText();
    if (searchString and string.len(searchString) > 0) then
        return self:FilterMountsByName(name);
    end

    local notContainded = true;

    local allDisabled = true;
    local allEnabled = true;
    for _, value in pairs(self.settings.filter.mountType) do
        if (value) then
            allDisabled = false;
        else
            allEnabled = false;
        end
    end

    if (allEnabled) then
        return true;
    end

    for mountType, value in pairs(MountJournalEnhancedType) do
        if (self.settings.filter.mountType[mountType]) then
            if (MountJournalEnhancedType[mountType]) then
                if (MountJournalEnhancedType[mountType][spellId]) then
                    if (value) then
                        return true;
                    else
                        notContainded = false;
                    end
                end
            end
        end
    end

    local _, _, _, isSelfMount, mountType = C_MountJournal.GetMountInfoExtraByID(mountID);
    
    -- 284: Chauffeur
    if (self.settings.filter.mountType.ground and (mountType == 230 or mountType == 231 or mountType == 241 or mountType == 269 or mountType == 284)) then
        return true;
    end

    if (self.settings.filter.mountType.flying and (mountType == 247 or mountType == 248)) then
        return true;
    end

    if (self.settings.filter.mountType.waterWalking and mountType == 269) then
        return true;
    end

    -- 64731 Sea Turtle, 30174 Riding Turtle
    if (self.settings.filter.mountType.underwater and (mountType == 232 or mountType == 254 or spellId == 64731 or spellId == 30174)) then
        return true;
     end

    if (self.settings.filter.mountType.transform and isSelfMount) then
        return true;
    end

    if (mountType ~= 230 and mountType ~= 231 and mountType ~= 241 and mountType ~= 269 and mountType ~= 247 and mountType ~= 248 and mountType ~= 232 and mountType ~= 254 and mountType ~= 284) then
        if (self.settings.debugMode) then
            print("New mount type " .. tostring(mountType) .. " for mount \"" .. name .. "\" (" .. spellId .. ")");
        end

        return true;
    end

    if (mountType == 230 or mountType == 231 or mountType == 241 or mountType == 269 or mountType == 247 or mountType == 248 or mountType == 232 or mountType == 254 or mountType == 284) then
        notContainded = false;
    end
    
    return notContainded and (allDisabled or allEnabled);
end

function private:UpdateMountInfoCache()
    local mountInfoCache = { };
    local indexMap = { };
    indexMap[0] = 0;
    
    for i=1, self.hooks["GetNumDisplayedMounts"]() do
        local creatureName, spellId, icon, active, isUsable, sourceType, isFavorite, isFaction, faction, hideOnChar, isCollected, mountID = self.hooks["GetDisplayedMountInfo"](i);
    
        isUsable = isUsable and IsUsableSpell(spellId);

        if (hideOnChar ~= true and
            not MountJournalEnhancedIgnored[spellId] and
            self:FilterHiddenMounts(creatureName, spellId) and
            self:FilterFavoriteMounts(creatureName, isFavorite) and
            self:FilterUsableMounts(creatureName, isUsable) and
            self:FilterMountsBySource(creatureName, spellId, isCollected, sourceType) and
            self:FilterMountsByFaction(creatureName, isFaction, faction) and
            self:FilterMountsByType(creatureName, spellId, mountID) and
            self:FilterMountsByFamily(creatureName, spellId) and 
			self:FilterMountsByExpansion(creatureName, spellId))
        then
            mountInfoCache[#mountInfoCache + 1] = { creatureName, spellId, icon, active, isUsable, sourceType, isFavorite, isFaction, faction, hideOnChar, isCollected, mountID };
            indexMap[#mountInfoCache] = i;
        end
    end

    self.mountInfoCache = mountInfoCache;
    self.indexMap = indexMap;
end

function private:MountListDragButton_OnClick(sender, button)
    local parent = sender:GetParent();
    if ( button ~= "LeftButton" ) then
        MountJournal_ShowMountDropdown(parent.index, sender, 0, 0);
    elseif ( IsModifiedClick("CHATLINK") ) then
        local id = parent.spellID;
        if ( MacroFrame and MacroFrame:IsShown() ) then
            local spellName = GetSpellInfo(id);
            ChatEdit_InsertLink(spellName);
        else
            local spellLink = GetSpellLink(id)
            ChatEdit_InsertLink(spellLink);
        end
    else
        C_MountJournal.Pickup(parent.index);
    end
end

function private:MountListItem_OnClick(sender, button)
    if ( button ~= "LeftButton" ) then
        MountJournal_ShowMountDropdown(sender.index, sender, 0, 0);
    elseif ( IsModifiedClick("CHATLINK") ) then
        local id = sender.spellID;
        if ( MacroFrame and MacroFrame:IsShown() ) then
            local spellName = GetSpellInfo(id);
            ChatEdit_InsertLink(spellName);
        else
            local spellLink = GetSpellLink(id)
            ChatEdit_InsertLink(spellLink);
        end
    elseif ( sender.spellID ~= MountJournal.selectedSpellID ) then
        MountJournal_Select(sender.index);
    end
end

function private:MountListItem_OnDoubleClick(sender, button)
    if (button == "LeftButton") then
        local _, _, _, _, _, _, _, _, _, _, _, mountID = C_MountJournal.GetDisplayedMountInfo(sender.index);
        C_MountJournal.SummonByID(mountID);
    end
end

function private:MountJournal_OnSearchTextChanged(sender)
    SearchBoxTemplate_OnTextChanged(sender);
    
    self:UpdateMountInfoCache();
    MountJournal_UpdateMountList();
end

function private:Hook(obj, name, func)
    local hook = self.hooks[name];
    if (hook ~= nil) then
        return false;
    end

    if (obj == nil) then
        self.hooks[name] = _G[name];
        _G[name] = func;
    else
        self.hooks[name] = obj[name];
        obj[name] = func;
    end

    return true;
end

function private:Unhook(obj, name)
    local hook = self.hooks[name];
    if (hook == nil) then
        return false;
    end

    if (obj == nil) then
        _G[name] = hook;
    else
        obj[name] = hook;
    end
    self.hooks[name] = nil;

    return true;
end

function private:SettingsCleanup()
    for source, value in pairs(self.settings.filter.source) do
        local contained = false;
        for _, category in pairs(MountJournalEnhancedSource) do
            if (category.Name == source) then
                contained = true;
                break;
            end
        end
        
        if (not contained) then
            self.settings.filter.source[source] = nil;
        end
    end
end

function private:Load()
    self:SettingsCleanup();
    self:LoadUI();
    self:LoadDebugMode();

    self:AddEventHandler("COMPANION_LEARNED", function() self:OnMountsUpdated(); end);
    self:AddEventHandler("ACHIEVEMENT_EARNED", function() self:OnMountsUpdated(); end);
    self:AddEventHandler("ACHIEVEMENT_EARNED", function() self:OnAchievement(); end);
    self:AddEventHandler("SPELL_UPDATE_USABLE", function() self:OnSpellUpdated(); end);

    self:AddSlashCommand("MOUNTJOURNALENHANCED", function(...) private:OnSlashCommand(...) end, 'mountjournalenhanced', 'mje');
end

function private:OnMountsUpdated()
    self:UpdateMountInfoCache();

    self.characterMountCountFrame.uniqueCount:SetText(GetNumCompanions("MOUNT"));
end

function private:OnAchievement()
    self.achievementFrame.staticText:SetText(GetCategoryAchievementPoints(MOUNT_ACHIEVEMENT_CATEGORY, true));
end

function private:OnSpellUpdated()
    if (CollectionsJournal:IsShown()) then
        self:UpdateMountInfoCache();
        MountJournal_UpdateMountList();
    end
end

function private:OnSlashCommand(command, parameter1, parameter2)
    if (command == "debug") then
        if (parameter1 == "on") then
            self.settings.debugMode = true;
            print("MountJournalEnhanced: Debug mode activated.");
            return;
        end

        if (parameter1 == "off") then
            self.settings.debugMode = false;
            print("MountJournalEnhanced: Debug mode deactivated.");
            return;
        end
    end

    print("Syntax:");
    print("/mje debug (on | off)");
end