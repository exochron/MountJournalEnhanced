local ADDON_NAME, ADDON = ...

local RIDING_ALONG_NODE_ID = 100167
local WHIRLING_SURGE_NODE_ID = 100168

EventRegistry:RegisterCallback(
        "MountJournal.OnShow",
        function()
            if MountJournal.ToggleDynamicFlightFlyoutButton then
                MountJournal.ToggleDynamicFlightFlyoutButton:Hide()
            end
        end,
        ADDON_NAME..'-skyriding'
)

local function UpdateToggleTrait(self)
    self.spellId = nil
    local configId = C_Traits.GetConfigIDBySystemID(Constants.MountDynamicFlightConsts.TRAIT_SYSTEM_ID)
    if configId then
        local nodeInfo = C_Traits.GetNodeInfo(configId, self.nodeId)
        if nodeInfo and nodeInfo.activeEntry then
            local entryInfo = C_Traits.GetEntryInfo(configId, nodeInfo.activeEntry.entryID)
            local definitionInfo = C_Traits.GetDefinitionInfo(entryInfo.definitionID)
            local spellIcon = C_Spell.GetSpellTexture(definitionInfo.spellID)
            self.texture:SetTexture(spellIcon)
            self.spellId = definitionInfo.spellID
        end
    end
end

local function DisplayTooltip(self)
    if self.spellId then
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetSpellByID(self.spellId)
        GameTooltip:Show()
    end
end

local function BuildTraitToggle(nodeId)
    local button = CreateFrame("Button", nil, MountJournal, "DynamicFlightFlyoutButtonTemplate")
    button.texture = button:CreateTexture(nil, "ARTWORK")
    button.texture:SetAllPoints()

    if ElvUI then
        local E = unpack(ElvUI)
        local ElvSkin = E:GetModule('Skins')

        -- from Collectables.lua HandleDynamicFlightButton
        button:SetPushedTexture(0)
        button:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
        button:SetNormalTexture(0)

        ElvSkin:HandleIcon(button.texture)
    end

    button.nodeId = nodeId
    button:HookScript("OnClick", function(self)
        local configId = C_Traits.GetConfigIDBySystemID(Constants.MountDynamicFlightConsts.TRAIT_SYSTEM_ID)

        if configId then
            local nodeInfo = C_Traits.GetNodeInfo(configId, nodeId)
            if nodeInfo and #nodeInfo.entryIDs == 2 and nodeInfo.activeEntry then
                local toggleEntryIndex = nodeInfo.entryIDs[1] == nodeInfo.activeEntry.entryID and 2 or 1

                C_Traits.SetSelection(configId, nodeId, nodeInfo.entryIDs[toggleEntryIndex])
                C_Traits.CommitConfig(configId)
                if GenericTraitFrame then
                    GenericTraitFrame:MarkNodeInfoCacheDirty(nodeId)
                end

                UpdateToggleTrait(self)
                DisplayTooltip(self)
            end
        end
    end)
    button:HookScript("OnShow", UpdateToggleTrait)
    button:HookScript("OnEnter", DisplayTooltip)
    button:HookScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    UpdateToggleTrait(button)

    return button
end

local function checkInitialTraitSelection()
    local configId = C_Traits.GetConfigIDBySystemID(Constants.MountDynamicFlightConsts.TRAIT_SYSTEM_ID)
    local hasUpdate = false

    if configId then
        local nodeInfo = C_Traits.GetNodeInfo(configId, RIDING_ALONG_NODE_ID)
        if nodeInfo and not nodeInfo.activeEntry then
            C_Traits.SetSelection(configId, RIDING_ALONG_NODE_ID, nodeInfo.entryIDs[1])
            hasUpdate = true
        end

        nodeInfo = C_Traits.GetNodeInfo(configId, WHIRLING_SURGE_NODE_ID)
        if nodeInfo and not nodeInfo.activeEntry then
            C_Traits.SetSelection(configId, WHIRLING_SURGE_NODE_ID, nodeInfo.entryIDs[1])
            hasUpdate = true
        end
    end

    if hasUpdate then
        C_Traits.CommitConfig(configId)
    end
end

ADDON.Events:RegisterCallback("loadUI", function()
    -- make sure first node in traits are selected
    if C_MountJournal.IsDragonridingUnlocked() then
        checkInitialTraitSelection()

        ADDON.UI:RegisterToolbarGroup(
                '05-skyriding',
                MountJournal.DynamicFlightFlyout.OpenDynamicFlightSkillTreeButton,
                MountJournal.DynamicFlightFlyout.DynamicFlightModeButton,
                BuildTraitToggle(RIDING_ALONG_NODE_ID),
                BuildTraitToggle(WHIRLING_SURGE_NODE_ID)
        )
        MountJournal.DynamicFlightFlyout.OpenDynamicFlightSkillTreeButton:SetParent(MountJournal)
        MountJournal.DynamicFlightFlyout.OpenDynamicFlightSkillTreeButton:Show()
        MountJournal.DynamicFlightFlyout.DynamicFlightModeButton:SetParent(MountJournal)
        MountJournal.DynamicFlightFlyout.DynamicFlightModeButton:Show()
    end
end, 'skyriding' )
