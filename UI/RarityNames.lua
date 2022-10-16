local _, ADDON = ...

local hooked
local orgCollectedR, orgCollectedG, orgCollectedB, orgCollectedA
local orgGreyR, orgGreyG, orgGreyB, orgGreyA

local function DetermineQuality(rarity)
    if rarity < 1.0 then
        return Enum.ItemQuality.Legendary
    end
    if rarity >= 1.0 and rarity < 10.0 then
        return Enum.ItemQuality.Epic
    end
    if rarity >= 10.0 and rarity < 20.0 then
        return Enum.ItemQuality.Rare
    end
    if rarity >= 20.0 and rarity < 50.0 then
        return Enum.ItemQuality.Uncommon
    end
    return Enum.ItemQuality.Common
end

local function ColorNames(button, elementData)
    if ADDON.settings.ui.colorizeNameByRarity then

        local mountID = elementData.mountID
        local collected = select(11, C_MountJournal.GetMountInfoByID(mountID))

        if orgCollectedR == nil and collected then
            orgCollectedR, orgCollectedG, orgCollectedB, orgCollectedA = button.name:GetTextColor()
        elseif orgGreyR == nil and not collected then
            orgGreyR, orgGreyG, orgGreyB, orgGreyA = button.name:GetTextColor()
        end

        local rarity = ADDON.DB.Rarities[mountID] or nil
        if rarity ~= nil then
            local quality = DetermineQuality(rarity)
            local r, g, b = GetItemQualityColor(quality)
            local a = collected and 1.0 or 0.75
            button.name:SetTextColor(r, g, b, a)
        elseif collected then
            button.name:SetTextColor(orgCollectedR, orgCollectedG, orgCollectedB, orgCollectedA)
        else
            button.name:SetTextColor(orgGreyR, orgGreyG, orgGreyB, orgGreyA)
        end
    end
end

ADDON:RegisterUISetting('colorizeNameByRarity', true, ADDON.L.SETTING_COLOR_NAMES, function(flag)
    if ADDON.initialized then
        if flag then
            MountJournal.ScrollBox:ForEachFrame(function(button, elementData)
                ColorNames(button, elementData)
            end)
            if not hooked then
                hooksecurefunc("MountJournal_InitMountButton", ColorNames)
                hooked = true
            end
        elseif orgCollectedR ~= nil or orgGreyA ~= nil then
            MountJournal.ScrollBox:ForEachFrame(function(button, elementData)
                local collected = select(11, C_MountJournal.GetMountInfoByID(elementData.mountID))
                if collected and orgCollectedR ~= nil then
                    button.name:SetTextColor(orgCollectedR, orgCollectedG, orgCollectedB, orgCollectedA)
                elseif not collected and orgGreyA ~= nil then
                    button.name:SetTextColor(orgGreyR, orgGreyG, orgGreyB, orgGreyA)
                end
            end)
        end
    end
end)

ADDON.Events:RegisterCallback("loadUI", function()
    ADDON:ApplySetting('colorizeNameByRarity', ADDON.settings.ui.colorizeNameByRarity)
end, "camera")