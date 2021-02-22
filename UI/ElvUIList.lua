local ADDON_NAME, ADDON = ...

local doCheckOverhaul = false

local E, L, V, P, G

-- should be called during load of Blizzard_Collections
ADDON.UI:RegisterUIOverhaulCallback(function(self)
    if self == MountJournal then
        doCheckOverhaul = true
    end
end)

local function petNameColor()
end

--region shameless copy of ElvUI (https://git.tukui.org/elvui/elvui/-/blob/development/ElvUI/Modules/Skins/Blizzard/Collectables.lua)
-- apparently that's their way to do so: https://git.tukui.org/elvui/elvui/-/issues/2375

local function mountNameColor(self)
    local button = self:GetParent()
    local name = button.name

    if name:GetFontObject() == _G.GameFontDisable then
        name:SetTextColor(0.4, 0.4, 0.4)
    else
        if button.background then
            local _, g, b = button.background:GetVertexColor()
            if g == 0 and b == 0 then
                name:SetTextColor(0.9, 0.3, 0.3)
                return
            end
        end

        name:SetTextColor(0.9, 0.9, 0.9)
    end
end

local function selectedTextureSetShown(texture, shown) -- used sets list
    local parent = texture:GetParent()
    local icon = parent.icon or parent.Icon
    if shown then
        parent.backdrop:SetBackdropBorderColor(1, .8, .1)
        icon.backdrop:SetBackdropBorderColor(1, .8, .1)
    else
        local r, g, b = unpack(E.media.bordercolor)
        parent.backdrop:SetBackdropBorderColor(r, g, b)
        icon.backdrop:SetBackdropBorderColor(r, g, b)
    end
end

local function selectedTextureShow(texture) -- used for pets/mounts
    local parent = texture:GetParent()
    parent.backdrop:SetBackdropBorderColor(1, .8, .1)
    parent.icon.backdrop:SetBackdropBorderColor(1, .8, .1)
end

local function selectedTextureHide(texture) -- used for pets/mounts
    local parent = texture:GetParent()
    if not parent.hovered then
        local r, g, b = unpack(E.media.bordercolor)
        parent.backdrop:SetBackdropBorderColor(r, g, b)
        parent.icon.backdrop:SetBackdropBorderColor(r, g, b)
    end

    if parent.petList then
        petNameColor(parent.iconBorder, parent.iconBorder:GetVertexColor())
    end
end


local function buttonOnEnter(button)
    local r, g, b = unpack(E.media.rgbvaluecolor)
    local icon = button.icon or button.Icon
    button.backdrop:SetBackdropBorderColor(r, g, b)
    icon.backdrop:SetBackdropBorderColor(r, g, b)
    button.hovered = true
end

local function buttonOnLeave(button)
    local icon = button.icon or button.Icon
    if button.selected or (button.SelectedTexture and button.SelectedTexture:IsShown()) then
        button.backdrop:SetBackdropBorderColor(1, .8, .1)
        icon.backdrop:SetBackdropBorderColor(1, .8, .1)
    else
        local r, g, b = unpack(E.media.bordercolor)
        button.backdrop:SetBackdropBorderColor(r, g, b)
        icon.backdrop:SetBackdropBorderColor(r, g, b)
    end
    button.hovered = nil
end


local function JournalScrollButtons(frame)
    for i, bu in ipairs(frame.buttons) do
        bu:StripTextures()
        bu:CreateBackdrop('Transparent', nil, nil, true, nil, nil, true, true)
        bu:Size(210, 42)

        local point, relativeTo, relativePoint, xOffset, yOffset = bu:GetPoint()
        bu:ClearAllPoints()

        if i == 1 then
            bu:Point(point, relativeTo, relativePoint, 44, yOffset)
        else
            bu:Point(point, relativeTo, relativePoint, xOffset, -2)
        end

        local icon = bu.icon or bu.Icon
        icon:Size(40)
        icon:Point('LEFT', -43, 0)
        icon:SetTexCoord(unpack(E.TexCoords))
        icon:CreateBackdrop(nil, nil, nil, true)

        bu:HookScript('OnEnter', buttonOnEnter)
        bu:HookScript('OnLeave', buttonOnLeave)

        local highlight = _G[bu:GetName()..'Highlight']
        if highlight then
            highlight:SetColorTexture(1, 1, 1, 0.3)
            highlight:SetBlendMode('ADD')
            highlight:SetAllPoints(bu.icon)
        end

        if bu.ProgressBar then
            bu.ProgressBar:SetTexture(E.media.normTex)
            bu.ProgressBar:SetVertexColor(0.251, 0.753, 0.251, 1) -- 0.0118, 0.247, 0.00392
        end

        if frame:GetParent() == _G.WardrobeCollectionFrame.SetsCollectionFrame then
            bu.setList = true
            bu.Favorite:SetAtlas('PetJournal-FavoritesIcon', true)
            bu.Favorite:Point('TOPLEFT', bu.Icon, 'TOPLEFT', -8, 8)

            hooksecurefunc(bu.SelectedTexture, 'SetShown', selectedTextureSetShown)
        else
            bu.selectedTexture:SetTexture()
            hooksecurefunc(bu.selectedTexture, 'Show', selectedTextureShow)
            hooksecurefunc(bu.selectedTexture, 'Hide', selectedTextureHide)

            if frame:GetParent() == _G.PetJournal then
                bu.petList = true
                bu.petTypeIcon:Point('TOPRIGHT', -1, -1)
                bu.petTypeIcon:Point('BOTTOMRIGHT', -1, 1)

                bu.dragButton.ActiveTexture:SetTexture(E.Media.Textures.White8x8)
                bu.dragButton.ActiveTexture:SetVertexColor(0.9, 0.8, 0.1, 0.3)
                bu.dragButton.levelBG:SetTexture()

                S:HandleIconBorder(bu.iconBorder, nil, petNameColor)
            elseif frame:GetParent() == _G.MountJournal then
                bu.mountList = true
                bu.factionIcon:SetDrawLayer('OVERLAY')
                bu.factionIcon:Point('TOPRIGHT', -1, -1)
                bu.factionIcon:Point('BOTTOMRIGHT', -1, 1)

                bu.DragButton.ActiveTexture:SetTexture(E.Media.Textures.White8x8)
                bu.DragButton.ActiveTexture:SetVertexColor(0.9, 0.8, 0.1, 0.3)

                bu.favorite:SetTexture([[Interface\COMMON\FavoritesIcon]])
                bu.favorite:Point('TOPLEFT', bu.DragButton, 'TOPLEFT' , -8, 8)
                bu.favorite:Size(32, 32)

                hooksecurefunc(bu.name, 'SetFontObject', mountNameColor)
                hooksecurefunc(bu.background, 'SetVertexColor', mountNameColor)
            end
        end
    end
end
--endregion

function ADDON.UI:StyleListWithElvUI(scrollFrame)
    if doCheckOverhaul and ElvUI then
        E, L, V, P, G = unpack(ElvUI)
        local S = E:GetModule('Skins')
        S:HandleScrollBar(scrollFrame.scrollBar)
        JournalScrollButtons(scrollFrame)
    end
end