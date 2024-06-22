local _, ADDON = ...

if MenuUtil then -- modern style filter menu
    return
end

local swatchFrame

local function CreateSwatch()
    if not swatchFrame then
        swatchFrame = CreateFrame("ColorSelect", nil, UIParent, "UIDropDownCustomMenuEntryTemplate")
        swatchFrame:SetSize(200, 138)

        swatchFrame.wheel = swatchFrame:CreateTexture()
        swatchFrame.wheel:SetTexture("WheelTexture")
        swatchFrame.wheel:SetSize(128, 128)
        swatchFrame.wheel:SetPoint("TOPLEFT", 3, -10)
        swatchFrame:SetColorWheelTexture(swatchFrame.wheel)

        swatchFrame.wheelThumb = swatchFrame:CreateTexture()
        swatchFrame.wheelThumb:SetTexture("Interface\\Buttons\\UI-ColorPicker-Buttons")
        swatchFrame.wheelThumb:SetTexCoord(0, 0.15625, 0, 0.625)
        swatchFrame.wheelThumb:SetSize(10, 10)
        swatchFrame:SetColorWheelThumbTexture(swatchFrame.wheelThumb)

        swatchFrame.value = swatchFrame:CreateTexture()
        swatchFrame.value:SetTexture("ValueTexture")
        swatchFrame.value:SetSize(32, 128)
        swatchFrame.value:SetPoint("LEFT", swatchFrame.wheel, "RIGHT", 24, 0)
        swatchFrame:SetColorValueTexture(swatchFrame.value)

        swatchFrame.valueThumb = swatchFrame:CreateTexture()
        swatchFrame.valueThumb:SetTexture("Interface\\Buttons\\UI-ColorPicker-Buttons")
        swatchFrame.valueThumb:SetTexCoord(0.25, 1.0, 0, 0.875)
        swatchFrame.valueThumb:SetSize(48, 14)
        swatchFrame:SetColorValueThumbTexture(swatchFrame.valueThumb)

        swatchFrame:HookScript("OnColorSelect", function(_, r, g, b)
            ADDON.settings.filter.color = { r * 255, g * 255, b * 255 }
            ADDON:FilterMounts()
            ADDON.UI.FDD:UpdateResetVisibility()
        end)

        swatchFrame:HookScript("OnShow", function(self)
            local filter = ADDON.settings.filter.color
            local isSet = (#filter == 3)
            self.wheelThumb:SetShown(isSet)
            self.valueThumb:SetShown(isSet)
            if isSet then
                self:SetColorRGB(filter[1] / 255, filter[2] / 255, filter[3] / 255)
            end
        end)
        swatchFrame:HookScript("OnMouseDown", function()
            swatchFrame.wheelThumb:Show()
            swatchFrame.valueThumb:Show()
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
            ADDON.settings.filter.color = { }
            ADDON:FilterMounts()
            ADDON.UI.FDD:UpdateResetVisibility()
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