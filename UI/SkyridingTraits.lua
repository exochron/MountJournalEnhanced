local ADDON_NAME, ADDON = ...

local button
local purchaseQueue = {}

local function IsSkyRidingTalentTreeOpen()
    local skyridingSystemId = Constants.MountDynamicFlightConsts and Constants.MountDynamicFlightConsts.TRAIT_SYSTEM_ID or 1

    return GenericTraitFrame:IsShown()
            and GenericTraitFrame:GetConfigID() == C_Traits.GetConfigIDBySystemID(skyridingSystemId)
end

local function processQueue()
    if #purchaseQueue == 0 or not IsSkyRidingTalentTreeOpen() then
        purchaseQueue = {}
        return
    end

    local configId = GenericTraitFrame:GetConfigID()
    for i, nodeId in ipairs(purchaseQueue) do
        local nodeInfo = C_Traits.GetNodeInfo(configId, nodeId)
        local entryId = nodeInfo.entryIDs[1]
        local canPurchase = C_Traits.CanPurchaseRank(configId, nodeId, entryId)
        if canPurchase then
            tUnorderedRemove(purchaseQueue, i)

            if #nodeInfo.entryIDs > 1 then
                GenericTraitFrame:SetSelection(nodeId, entryId)
            end
            GenericTraitFrame:PurchaseRank(nodeId)

            return
        end
    end

    purchaseQueue = {}
end

local function SpentAllPoints()
    local configId = GenericTraitFrame:GetConfigID()
    local treeId = GenericTraitFrame:GetTalentTreeID()

    local nodeIds = C_Traits.GetTreeNodes(treeId)
    purchaseQueue = tFilter(nodeIds, function(nodeId)
        local nodeInfo = C_Traits.GetNodeInfo(configId, nodeId)
        return nodeInfo.currentRank == 0
    end, true)
    processQueue()
end

local function BuildButton()
    local AceGUI = LibStub("AceGUI-3.0")

    local aceButton = AceGUI:Create("Button")
    aceButton:SetParent({ content = GenericTraitFrame })
    aceButton:SetAutoWidth(true)
    aceButton:SetText(ADDON.L.TRAITS_SPEND_ALL)
    aceButton:SetPoint("TOPRIGHT", GenericTraitFrame.Currency, "BOTTOMRIGHT", 0, -3)
    aceButton:SetCallback("OnClick", function()
        aceButton:SetDisabled(true)
        SpentAllPoints()
    end)
    aceButton.frame:SetFrameLevel(1500)

    return aceButton
end

EventRegistry:RegisterCallback("GenericTraitFrame.OnShow", function(...)
    if IsSkyRidingTalentTreeOpen() then
        if not button then
            button = BuildButton()
            ADDON.UI.SkyridingSpendAllGlyphsButton = button.frame

            local timer
            GenericTraitFrame:RegisterCallback(TalentFrameBaseMixin.Event.CommitStatusChanged, function()
                if IsSkyRidingTalentTreeOpen() and not timer then
                    timer = C_Timer.NewTicker(0.1, function()
                        if C_Traits.IsReadyForCommit() and not GenericTraitFrame:IsCommitInProgress() then
                            timer:Cancel()
                            timer = nil
                            processQueue()
                        end
                    end)
                end
            end, ADDON_NAME..'-skyriding-talent-queue')
        end

        local currencyInfo = C_Traits.GetTreeCurrencyInfo(GenericTraitFrame:GetConfigID(), GenericTraitFrame:GetTalentTreeID(), true)[1]
        button:SetDisabled(currencyInfo.quantity == 0 or currencyInfo.spent >= currencyInfo.maxQuantity)

        button.frame:Show()
    end
end, ADDON_NAME..'-skyriding-talents')
EventRegistry:RegisterCallback("GenericTraitFrame.OnHide", function(...)
    if button then
        button.frame:Hide()
    end
end, ADDON_NAME..'-skyriding-talents')