local _, ADDON = ...

local function save(id)
    local profile = ADDON.settings.filterProfile[id]
    profile.sort = CopyTable(ADDON.settings.sort)
    profile.filter = CopyTable(ADDON.settings.filter)
    profile.search = MountJournal.searchBox:GetText()
end

local function mergeRecursive(source, target)
    for k, v in pairs(source) do
        if target[k] ~= nil then
            if type(target[k]) == "table" and type(v) == "table" then
                mergeRecursive(v, target[k])
            else
                target[k] = v
            end
        end
    end
end

local function load(id)
    ADDON:ResetSortSettings()
    ADDON:ResetFilterSettings()

    local profile = ADDON.settings.filterProfile[id]
    mergeRecursive(profile.sort, ADDON.settings.sort)
    mergeRecursive(profile.filter, ADDON.settings.filter)

    MountJournal.searchBox:SetText(profile.search)
end

function ADDON.UI.FDD:AddProfiles(root)

    local icons = {
        456034, -- raidtarget_square
        456036, -- raidtarget_triangle
        456038, -- raidtarget_diamond
        456040, -- raidtarget_x
        456042, -- raidtarget_star
    }

    local profileButtons = {}
    local element = root:CreateTitle(ADDON.L.FILTER_PROFILE, WHITE_FONT_COLOR)
    element:AddInitializer(function(button, elementDescription, menu)

        MenuVariants.CreateHighlight(button)
        local fontHeight = button.fontString:GetHeight()

        for i = 1, 5 do
            -- checkbutton?
            local profileButton = button:AttachTemplate("WowMenuAutoHideButtonTemplate")
            profileButton.Texture:SetTexture(icons[i])
            profileButton:SetSize(fontHeight-2, fontHeight-2)

            profileButton:RegisterForClicks("AnyUp")

            profileButton:SetScript("OnClick", function(_, mouseButton)
                if mouseButton == "RightButton" then
                    save(i)
                    -- flash/animate?
                else
                    load(i)
                    ADDON:FilterMounts()
                    ADDON.Api:GetDataProvider():Sort()
                    menu:SendResponse(elementDescription, MenuResponse.Close)
                end
            end)
            profileButton:SetScript("OnEnter", function(self)
                button.highlight:ClearAllPoints()
                button.highlight:SetSize(fontHeight+2, fontHeight)
                button.highlight:SetPoint("CENTER", self, "CENTER", 0, 0)
                button.highlight:Show()
            end)
            profileButton:SetScript("OnLeave", function()
                button.highlight:Hide()
            end)

            profileButton:SetPoint("BOTTOM", button.fontString)
            profileButtons[i] = profileButton
        end

        profileButtons[5]:SetPoint("RIGHT")
        for i = 4, 1, -1 do
            profileButtons[i]:SetPoint("RIGHT", profileButtons[i+1], "LEFT", -7, 0)
        end
    end)
    element:HookOnEnter(function(frame)
        GameTooltip:SetOwner(frame, "ANCHOR_NONE")
        GameTooltip:SetPoint("LEFT", frame, "RIGHT")
        GameTooltip:ClearLines()
        GameTooltip_SetTitle(GameTooltip, ADDON.L.FILTER_PROFILE_TOOLTIP_TITLE)
        GameTooltip:AddLine(ADDON.L.FILTER_PROFILE_TOOLTIP_TEXT)
        GameTooltip:Show()
    end)
    element:AddResetter(function(self)
        self.highlight:SetSize(0, 0)
        self.highlight:SetBlendMode("DISABLE")
        self.highlight:ClearAllPoints()
        self.highlight = nil
        for _, profileButton in pairs(profileButtons) do
            profileButton.Texture:SetTexture()
            profileButton:SetSize(0,0)
            profileButton:ClearAllPoints()
            profileButton:RegisterForClicks("LeftButtonUp")
            profileButton:SetScript("OnClick", nil)
            profileButton:SetScript("OnEnter", nil)
            profileButton:SetScript("OnLeave", nil)
        end
    end)

end