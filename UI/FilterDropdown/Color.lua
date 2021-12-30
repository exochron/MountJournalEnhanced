local _, ADDON = ...

local swatchFrame

local function CreateSwatch()
    if not swatchFrame then
        swatchFrame = CreateFrame("ColorSelect", nil, UIParent, "UIDropDownCustomMenuEntryTemplate")
        swatchFrame:SetSize(200, 138)

        local colorWheel = swatchFrame:CreateTexture()
        colorWheel:SetTexture("WheelTexture")
        colorWheel:SetSize(128, 128)
        colorWheel:SetPoint("TOPLEFT", 3, -10)
        swatchFrame:SetColorWheelTexture(colorWheel)
        local colorWheelThumb = swatchFrame:CreateTexture()
        colorWheelThumb:SetTexture("Interface\\Buttons\\UI-ColorPicker-Buttons")
        colorWheelThumb:SetTexCoord(0, 0.15625, 0, 0.625)
        colorWheelThumb:SetSize(10, 10)
        swatchFrame:SetColorWheelThumbTexture(colorWheelThumb)
        local colorValue = swatchFrame:CreateTexture()
        colorValue:SetTexture("ValueTexture")
        colorValue:SetSize(32, 128)
        colorValue:SetPoint("LEFT", colorWheel, "RIGHT", 24, 0)
        swatchFrame:SetColorValueTexture(colorValue)
        local colorValueThumb = swatchFrame:CreateTexture()
        colorValueThumb:SetTexture("Interface\\Buttons\\UI-ColorPicker-Buttons")
        colorValueThumb:SetTexCoord(0.25, 1.0, 0, 0.875)
        colorValueThumb:SetSize(48, 14)
        swatchFrame:SetColorValueThumbTexture(colorValueThumb)

        swatchFrame:HookScript("OnColorSelect", function(_, r, g, b)
            ADDON.settings.filter.color = { r * 255, g * 255, b * 255 }
            ADDON.Api:UpdateIndex()
            ADDON.UI:UpdateMountList()
        end)
    end

    return swatchFrame
end

function ADDON.UI.FDD:AddColorMenu(level)
    local info = {
        keepShownOnClick = false,
        isNotRadio = true,
        hasArrow = false,
        notCheckable = true,
        text = NEWBIE_TOOLTIP_STOPWATCH_RESETBUTTON,
        justifyH = "CENTER",
        func = function()
            ADDON.settings.filter.color = nil
            ADDON.Api:UpdateIndex()
            ADDON.UI:UpdateMountList()
        end,
    }
    UIDropDownMenu_AddButton(info, level)

    info = {
        keepShownOnClick = true,
        isNotRadio = true,
        hasArrow = false,
        notCheckable = true,
        customFrame = CreateSwatch(),
    }
    UIDropDownMenu_AddButton(info, level)
end