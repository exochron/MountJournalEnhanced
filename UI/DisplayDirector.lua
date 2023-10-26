local _, ADDON = ...

-- MountJournal.MountDisplay.ModelScene:GetActorByTag("unwrapped"):SetAnimation(X)
--0=idle
--1=dying
--4=walking
--5=running
--6=lying
--13=walking backwards
--17=attack
--18=attack
--38=falling
--39=landing
--41=flying still
--42=flying forward
--94=mountspecial
--118=eat
--618=MountSelfIdle -- for isSelfMount
--636=mountspecial

local helpTooltip
local buttons = {}

local function UpdateContainer()
    local activeButtons = 0
    local controlFrame = MountJournal.MountDisplay.ModelScene.ControlFrame
    local hPadding = controlFrame.buttonHorizontalPadding or 0
    local buttonWidth = 0

    for _, button in ipairs(buttons) do
        if button:IsShown() then
            buttonWidth = button:GetWidth()
            if activeButtons == 0 then
                button:SetPoint("LEFT", 0, 0)
            else
                button:SetPoint("LEFT", activeButtons * (buttonWidth + hPadding), 0)
            end
            activeButtons = activeButtons + 1
        end
    end

    controlFrame:SetWidth((activeButtons * (buttonWidth + hPadding)) - hPadding)
end

local function HideOriginalElements()
    local scene = MountJournal.MountDisplay.ModelScene
    if scene.RotateLeftButton then
        scene.RotateLeftButton:Hide()
    end
    if scene.RotateRightButton then
        scene.RotateRightButton:Hide()
    end
    scene.TogglePlayer:Hide()
end

-- Switching mounts still starts the Animationkit. So we have to stop it.
local function SetupModelActor()
    local callback = function()
        local actor = MountJournal.MountDisplay.ModelScene:GetActorByTag("unwrapped")
        if actor then
            actor:StopAnimationKit()
        end
    end
    ADDON.Events:RegisterCallback("OnUpdateMountDisplay", callback, 'DisplayDirector')
end

local function BuildControlContainer()
    local frame = CreateFrame("Frame", nil, MountJournal.MountDisplay.ModelScene)
    frame:SetSize(32,32)
    frame:SetPoint("BOTTOM", 0, 10)
    frame:SetFrameLevel(500)
    frame:SetAlpha(0.5)
    frame:Hide()
    frame.buttonHorizontalPadding = -6
    frame.UpdateLayout = function()
    end
    frame.GetRotateIncrement = function()
        return 0.05
    end
    frame:SetScript("OnShow", function()
        frame:UpdateLayout()
    end)
    frame:SetScript("OnEnter", function()
        frame:SetAlpha(1)
    end)
    frame:SetScript("OnLeave", function()
        frame:SetAlpha(0.5)
    end)

    MountJournal.MountDisplay.ModelScene.ControlFrame = frame
    MountJournal.MountDisplay.ModelScene:HookScript("OnEnter", function()
        frame:Show()
    end)
    MountJournal.MountDisplay.ModelScene:HookScript("OnLeave", function()
        if not frame:IsMouseOver() then
            frame:Hide()
        end
    end)

    return frame
end

local function InitButton(button, tooltip, tooltipText)
    -- overwrite default tooltip handling (which might cause taint)
    button:SetScript("OnEnter", function()
        button:GetParent():SetAlpha(1);
        helpTooltip:SetOwner(button, "ANCHOR_BOTTOM")
        helpTooltip:SetText(tooltip or button.tooltip, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
        if tooltipText or button.tooltipText then
            helpTooltip:AddLine(tooltipText or button.tooltipText, _, _, _, 1, 1)
        end
        helpTooltip:Show()
    end)
    button:SetScript("OnLeave", function()
        button:GetParent():SetAlpha(0.5);
        helpTooltip:Hide()
    end)

    table.insert(buttons, button)
end

local function BuildButton(tooltip, tooltipText)
    local _, button = xpcall(
            function()
                return CreateFrame("Button", nil, MountJournal.MountDisplay.ModelScene.ControlFrame, "ModelSceneControlButtonTemplate")
            end,
            function()
                local frame =  CreateFrame("Button", nil, MountJournal.MountDisplay.ModelScene.ControlFrame, "MJE_ModelSceneControlButtonTemplate")
                frame:HookScript("OnMouseDown", function() frame.Icon:AdjustPointsOffset(1, -1) end)
                frame:HookScript("OnMouseUp", function() frame.Icon:AdjustPointsOffset(-1, 1) end)
                return frame
            end
    )
    InitButton(button, tooltip, tooltipText)
    button:HookScript("OnMouseDown", function()
        PlaySound(SOUNDKIT.IG_INVENTORY_ROTATE_CHARACTER)
    end)

    return button
end

local function CheckButtonStatus(self)
    self.Icon:SetPoint("CENTER")
    if self:GetChecked() then
        self.Icon:AdjustPointsOffset(1, -1);
    end
end

local function BuildCheckButton(tooltip, tooltipText, OnInitShow)
    local _, button = xpcall(
            function()
                return CreateFrame("CheckButton", nil, MountJournal.MountDisplay.ModelScene.ControlFrame, "ModelSceneControlButtonTemplate")
            end,
            function()
                local frame =  CreateFrame("CheckButton", nil, MountJournal.MountDisplay.ModelScene.ControlFrame, "MJE_ModelSceneControlButtonTemplate")
                frame:HookScript("OnMouseDown", function() frame.Icon:AdjustPointsOffset(1, -1) end)
                frame:HookScript("OnMouseUp", function() frame.Icon:AdjustPointsOffset(-1, 1) end)
                return frame
            end
    )
    button:RegisterForClicks("AnyUp")
    InitButton(button, tooltip, tooltipText)
    button:HookScript("OnShow", OnInitShow)
    button:HookScript("OnShow", CheckButtonStatus)
    button:HookScript("OnClick", CheckButtonStatus)
    button:HookScript("OnMouseDown", function()
        PlaySound(SOUNDKIT.IG_INVENTORY_ROTATE_CHARACTER)
    end)

    return button
end

local function BuildRotateButton(tooltip, icon, direction)
    local button = BuildButton(tooltip, ROTATE_TOOLTIP)
    button.Icon:SetAtlas("common-icon-" .. icon)
    button:HookScript("OnMouseDown", function()
        MountJournal.MountDisplay.ModelScene:AdjustCameraYaw(direction, button:GetParent():GetRotateIncrement())
    end)
    button:HookScript("OnMouseUp", function()
        MountJournal.MountDisplay.ModelScene:StopCameraYaw()
    end)

    return button
end

local function BuildCameraPanel()
    local L = ADDON.L

    local container = MountJournal.MountDisplay.ModelScene.ControlFrame or BuildControlContainer()

    helpTooltip = CreateFrame("GameTooltip", "MJEDisplayHelpToolTip", container, "SharedNoHeaderTooltipTemplate")

    container.specialButton = BuildButton("/mountspecial")
    container.specialButton.Icon:SetTexture("Interface/GossipFrame/CampaignGossipIcons") -- from atlas: campaignavailablequesticon
    container.specialButton.Icon:SetTexCoord(0.1875, 0.421875, 0.37, 0.85)
    container.specialButton:HookScript("OnClick", function()
        local actor = MountJournal.MountDisplay.ModelScene:GetActorByTag("unwrapped")
        if actor then
            actor:SetAnimationBlendOperation(LE_MODEL_BLEND_OPERATION_ANIM)
            actor:PlayAnimationKit(1371)
            actor:PlayAnimationKit(1371) -- animation gets sometimes canceled. second call is to enforce it.
        end
    end)

    container.togglePlayerButton = BuildCheckButton(MOUNT_JOURNAL_PLAYER, nil, function(self)
        PlayerPreviewToggle.OnShow(self)
    end)
    container.togglePlayerButton.Icon:SetTexture(386865) -- interface/friendsframe/ui-toast-toasticons.blp
    container.togglePlayerButton.Icon:SetTexCoord(0.05, 0.2, 0.6, 0.9)
    container.togglePlayerButton.Icon:SetVertexColor(1, 0.7, 0.1)
    container.togglePlayerButton:HookScript("OnClick", function(self)
        if self:GetChecked() then
            SetCVar("mountJournalShowPlayer", 1)
        else
            SetCVar("mountJournalShowPlayer", 0)
        end
        MountJournal_UpdateMountDisplay(true)
    end)

    container.cycleColorButton = BuildButton(L.TOGGLE_COLOR)
    container.cycleColorButton.Icon:SetAtlas("colorblind-colorwheel")
    container.cycleColorButton:HookScript("OnClick", function()
        local mountID, mountVariation = ADDON.Api:GetSelected()
        local creatureData = C_MountJournal.GetMountAllCreatureDisplayInfoByID(mountID)
        if nil == mountVariation then
            local creatureDisplayID = C_MountJournal.GetMountInfoExtraByID(mountID)
            for i, d in ipairs(creatureData) do
                if d.creatureDisplayID == creatureDisplayID then
                    mountVariation = i
                    break
                end
            end
        end
        mountVariation = mountVariation or 1

        if #creatureData >= mountVariation + 1 then
            ADDON.Api:SetSelected(mountID, mountVariation + 1)
        else
            ADDON.Api:SetSelected(mountID, 1)
        end
    end)

    if container.zoomInButton then
        InitButton(container.zoomInButton)
    else
        container.zoomInButton = BuildButton(ZOOM_IN, KEY_MOUSEWHEELUP)
        container.zoomInButton.Icon:SetAtlas("common-icon-zoomin")
        container.zoomInButton:HookScript("OnClick", function()
            MountJournal.MountDisplay.ModelScene:OnMouseWheel(1)
        end)
    end

    if container.zoomOutButton then
        InitButton(container.zoomOutButton)
    else
        container.zoomOutButton = BuildButton(ZOOM_OUT, KEY_MOUSEWHEELDOWN)
        container.zoomOutButton.Icon:SetAtlas("common-icon-zoomout")
        container.zoomOutButton:HookScript("OnClick", function()
            MountJournal.MountDisplay.ModelScene:OnMouseWheel(-1)
        end)
    end

    container.toggleAutoRotateButton = BuildCheckButton(ADDON.L.AUTO_ROTATE, nil, function(self)
        self:SetChecked(ADDON.settings.ui.autoRotateModel)
    end)
    container.toggleAutoRotateButton.Icon:SetTexture("Interface/Animations/PowerSwirlAnimation")
    container.toggleAutoRotateButton.Icon:SetTexCoord(0.810547, 0.947266, 0.00195312, 0.138672)
    container.toggleAutoRotateButton:HookScript("OnClick", function(self)
        ADDON.settings.ui.autoRotateModel = self:GetChecked()
    end)

    if container.rotateLeftButton then
        InitButton(container.rotateLeftButton)
    else
        container.rotateLeftButton = BuildRotateButton(ROTATE_LEFT, "rotateleft", "left")
    end
    if container.rotateRightButton then
        InitButton(container.rotateRightButton)
    else
        container.rotateRightButton = BuildRotateButton(ROTATE_RIGHT, "rotateright", "right")
    end

    container.rotateUpButton = BuildRotateButton(L.ROTATE_UP, "rotateleft", "up")
    container.rotateUpButton.Icon:SetRotation(-math.pi / 2)

    container.rotateDownButton = BuildRotateButton(L.ROTATE_DOWN, "rotateright", "down")
    container.rotateDownButton.Icon:SetRotation(-math.pi / 2)

    if container.resetButton then
        InitButton(container.resetButton)
    else
        container.resetButton = BuildButton(RESET_POSITION)
        container.resetButton.Icon:SetAtlas("common-icon-undo")
        container.resetButton:HookScript("OnClick", function()
            local cam = MountJournal.MountDisplay.ModelScene:GetActiveCamera()
            if cam then
                local info = cam.modelSceneCameraInfo
                cam:SetPitch(info.pitch)
                cam:SetYaw(info.yaw)
                cam:SetZoomDistance(info.zoomDistance)
            end
        end)
    end

    hooksecurefunc(container, "UpdateLayout", UpdateContainer)
    UpdateContainer()
end

ADDON.Events:RegisterCallback("loadUI", function()
    HideOriginalElements()
    SetupModelActor()
    BuildCameraPanel()

    -- fix display rotation and adds up and down as possibilities
    MountJournal.MountDisplay.ModelScene:SetScript("OnUpdate", function(self, elapsed)
        if self.activeCamera then
            local yawDirection = self.yawDirection;
            local increment = self.increment;
            if yawDirection == "left" then
                self.activeCamera:AdjustYaw(-1, 0, increment);
            elseif yawDirection == "right" then
                self.activeCamera:AdjustYaw(1, 0, increment);
            elseif yawDirection == "up" then
                self.activeCamera:AdjustYaw(0, -1, increment);
            elseif yawDirection == "down" then
                self.activeCamera:AdjustYaw(0, 1, increment);
            end

            self.activeCamera:OnUpdate(elapsed);
        end
    end);

    MountJournal.MountDisplay.ModelScene:HookScript("OnUpdate", function(self, elapsed)
        if ADDON.settings.ui.autoRotateModel then
            self:GetActiveCamera():HandleMouseMovement(ORBIT_CAMERA_MOUSE_MODE_YAW_ROTATION, elapsed * -0.8, false)
        end
    end);
end, "display director")

local function updateVisibility()
    local mountID = ADDON.Api:GetSelected()
    if mountID then
        local controlFrame = MountJournal.MountDisplay.ModelScene.ControlFrame
        if controlFrame.togglePlayerButton then
            local _, _, _, isSelfMount = C_MountJournal.GetMountInfoExtraByID(mountID)
            controlFrame.togglePlayerButton:SetShown(not isSelfMount)
        end
        if controlFrame.cycleColorButton then
            local creatureData = C_MountJournal.GetMountAllCreatureDisplayInfoByID(mountID)
            controlFrame.cycleColorButton:SetShown(#creatureData > 1)
        end

        UpdateContainer()
    end
end

ADDON.Events:RegisterCallback("OnUpdateMountDisplay", function()
    if #buttons < 3 then
        -- might be just bad timing, so lets delay by a frame to be sure
        C_Timer.After(0, updateVisibility)
    else
        updateVisibility()
    end
end, "display director")