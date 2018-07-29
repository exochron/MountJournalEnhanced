local ADDON_NAME, ADDON = ...

ADDON.hooks = { }
ADDON.indexMap = { }

--region Hooks
local function MapIndex(index)
    if (not ADDON.indexMap) then
        ADDON:UpdateIndexMap()
    end

    return ADDON.indexMap[index]
end

local function C_MountJournal_GetNumDisplayedMounts()
    if (not ADDON.indexMap) then
        ADDON:UpdateIndexMap()
    end

    return #ADDON.indexMap
end

local function C_MountJournal_GetDisplayedMountInfo(index)
    local creatureName, spellId, icon, active, isUsable, sourceType, isFavorite, isFaction, faction, hideOnChar, isCollected, mountID, a, b, c, d, e, f, g, h = ADDON.hooks["GetDisplayedMountInfo"](MapIndex(index))

    isUsable = isUsable and IsUsableSpell(spellId)

    return creatureName, spellId, icon, active, isUsable, sourceType, isFavorite, isFaction, faction, hideOnChar, isCollected, mountID, a, b, c, d, e, f, g, h
end

local function C_MountJournal_GetDisplayedMountInfoExtra(index)
    local _, _, _, _, _, _, _, _, _, _, _, mountId = C_MountJournal.GetDisplayedMountInfo(index)
    if (not mountId) then
        return nil
    end

    return C_MountJournal.GetMountInfoExtraByID(mountId)
end

local function RegisterMountJournalHooks()
    ADDON:Hook(C_MountJournal, "GetNumDisplayedMounts", C_MountJournal_GetNumDisplayedMounts)
    ADDON:Hook(C_MountJournal, "GetDisplayedMountInfo", C_MountJournal_GetDisplayedMountInfo)
    ADDON:Hook(C_MountJournal, "GetDisplayedMountInfoExtra", C_MountJournal_GetDisplayedMountInfoExtra)
    ADDON:Hook(C_MountJournal, "Pickup", function(index)
        return ADDON.hooks["Pickup"](MapIndex(index))
    end)
    ADDON:Hook(C_MountJournal, "SetIsFavorite", function(index, isFavorited)
        return ADDON.hooks["SetIsFavorite"](MapIndex(index), isFavorited)
    end)
    ADDON:Hook(C_MountJournal, "GetIsFavorite", function(index)
        return ADDON.hooks["GetIsFavorite"](MapIndex(index))
    end)
end
--endregion Hooks

local function UpdateMountList()
    local buttons = MountJournal.ListScrollFrame.buttons
    for i = 1, #buttons do
        if (ADDON.settings.hiddenMounts[buttons[i].spellID]) then
            buttons[i].DragButton.IsHidden:SetShown(true)
        else
            buttons[i].DragButton.IsHidden:SetShown(false)
        end
        buttons[i].DragButton:SetEnabled(true)
    end
end

local function MountListItem_OnClick(sender, anchor, button)
    if (button ~= "LeftButton") then
        local _, _, _, _, _, _, _, _, _, _, isCollected = C_MountJournal.GetDisplayedMountInfo(sender.index)
        if not isCollected then
            MountJournal_ShowMountDropdown(sender.index, anchor, 0, 0)
        end
    end
end

local function MountListItem_OnDoubleClick(sender, button)
    if (button == "LeftButton") then
        local _, _, _, _, _, _, _, _, _, _, _, mountID = C_MountJournal.GetDisplayedMountInfo(sender.index)
        C_MountJournal.SummonByID(mountID)
    end
end

local function MountJournal_OnSearchTextChanged(sender)
    SearchBoxTemplate_OnTextChanged(sender)

    ADDON:UpdateIndexMap()
    MountJournal_UpdateMountList()
end

local function LoadUI()
    -- reset default filter settings
    C_MountJournal.SetCollectedFilterSetting(LE_MOUNT_JOURNAL_FILTER_COLLECTED, true)
    C_MountJournal.SetCollectedFilterSetting(LE_MOUNT_JOURNAL_FILTER_NOT_COLLECTED, true)
    C_MountJournal.SetCollectedFilterSetting(LE_MOUNT_JOURNAL_FILTER_UNUSABLE, true)
    C_MountJournal.SetAllSourceFilters(true)

    PetJournal:HookScript("OnShow", function()
        if (not PetJournalPetCard.petID) then
            PetJournal_ShowPetCard(1)
        end
    end)

    RegisterMountJournalHooks()

    hooksecurefunc("MountJournal_UpdateMountList", UpdateMountList)

    MountJournalSearchBox:SetScript("OnTextChanged", MountJournal_OnSearchTextChanged)

    hooksecurefunc(MountJournal.mountOptionsMenu, "initialize", function(sender, level)
        UIDropDownMenu_InitializeHelper(sender)
        ADDON:MountOptionsMenu_Init(sender, level)
    end)
    hooksecurefunc(MountJournalFilterDropDown, "initialize", function(sender, level)
        UIDropDownMenu_InitializeHelper(sender)
        ADDON:MountJournalFilterDropDown_Initialize(sender, level)
    end)

    local buttons = MountJournal.ListScrollFrame.buttons
    for buttonIndex = 1, #buttons do
        local button = buttons[buttonIndex]
        button:HookScript("OnClick", function(sender, mouseButton)
            MountListItem_OnClick(sender, sender, mouseButton)
        end)
        button:SetScript("OnDoubleClick", MountListItem_OnDoubleClick)
        button.DragButton:HookScript("OnClick", function(sender, mouseButton)
            MountListItem_OnClick(sender:GetParent(), sender, mouseButton)
        end)
        button.DragButton.IsHidden = button.DragButton:CreateTexture(nil, "OVERLAY")
        button.DragButton.IsHidden:SetTexture("Interface\\BUTTONS\\UI-GroupLoot-Pass-Up")
        button.DragButton.IsHidden:SetSize(36, 36)
        button.DragButton.IsHidden:SetPoint("CENTER", button.DragButton, "CENTER", 0, 0)
        button.DragButton.IsHidden:SetDrawLayer("OVERLAY", 1)
        button.DragButton.IsHidden:SetShown(false)
    end

    ADDON:CreateCharacterMountCount()
    ADDON:CreateAchievementPoints()
    ADDON:CreateShopButton()

    ADDON:UpdateIndexMap()
    MountJournal_UpdateMountList()

    local frame = CreateFrame("frame");
    frame:RegisterEvent("SPELL_UPDATE_USABLE")
    frame:SetScript("OnEvent", function(sender, ...)
        if (CollectionsJournal:IsShown()) then
            ADDON:UpdateIndexMap()
            MountJournal_UpdateMountList()
        end
    end);
end

function ADDON:UpdateIndexMap()
    local indexMap = { }

    local searchString = MountJournal.searchBox:GetText()
    if (not searchString or string.len(searchString) == 0) then
        searchString = nil
    else
        searchString = string.lower(searchString)
    end

    for i = 1, self.hooks["GetNumDisplayedMounts"]() do
        if (ADDON:FilterMount(i, searchString)) then
            indexMap[#indexMap + 1] = i
        end
    end

    self.indexMap = indexMap
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
        LoadUI()
        if ADDON.settings.debugMode then
            ADDON:RunDebugTest()
        end
    end
end

hooksecurefunc("LoadAddOn", function(name)
    if (name == 'Blizzard_Collections') then
        Load()
    end
end)