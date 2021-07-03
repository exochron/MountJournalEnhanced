local ADDON_NAME, ADDON = ...

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

local function HideOriginalElements()
    local scene = MountJournal.MountDisplay.ModelScene
    scene.RotateLeftButton:Hide()
    scene.RotateRightButton:Hide()
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
    ADDON.Events:RegisterCallback("OnUpdateMountDisplay", callback, ADDON_NAME .. 'DisplayDirector')
end

local function BuildControlContainer(width)
    local frame = CreateFrame("Frame", nil, MountJournal.MountDisplay)
    frame:SetSize(width, 23)
    frame:SetAlpha(0.5)
    frame:Hide()
    local rightTexture = frame:CreateTexture(nil, "BACKGROUND")
    rightTexture:SetPoint("RIGHT", 0, 0)
    rightTexture:SetTexture("Interface/Common/UI-ModelControlPanel")
    rightTexture:SetTexCoord(0.01562500, 0.37500000, 0.42968750, 0.60937500)
    rightTexture:SetSize(23, 23)
    local leftTexture = frame:CreateTexture(nil, "BACKGROUND")
    leftTexture:SetPoint("LEFT", 0, 0)
    leftTexture:SetTexture("Interface/Common/UI-ModelControlPanel")
    leftTexture:SetTexCoord(0.40625000, 0.76562500, 0.42968750, 0.60937500)
    leftTexture:SetSize(23, 23)
    local middleTexture = frame:CreateTexture(nil, "BACKGROUND")
    middleTexture:SetPoint("LEFT", leftTexture, "RIGHT", 0, 0)
    middleTexture:SetPoint("RIGHT", rightTexture, "LEFT", 0, 0)
    middleTexture:SetTexture("Interface/Common/UI-ModelControlPanel")
    middleTexture:SetTexCoord(0, 01, 0.62500000, 0.80468750)
    middleTexture:SetSize(23, 23)

    return frame
end

local function InitButton(button, frame, relativeTo, tooltip, tooltipText)
    if relativeTo then
        button:SetPoint("LEFT", relativeTo, "RIGHT", 0, 0)
    else
        button:SetPoint("LEFT", 2, 0)
    end

    -- overwrite default tooltip handling (which might cause taint)
    button:SetScript("OnEnter", function()
        frame:SetAlpha(1)
        frame:Show()
        helpTooltip:SetOwner(button, "ANCHOR_BOTTOM")
        helpTooltip:SetText(tooltip, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
        if tooltipText then
            helpTooltip:AddLine(tooltipText, _, _, _, 1, 1)
        end
        helpTooltip:Show()
    end)
    button:SetScript("OnLeave", function()
        frame:SetAlpha(0.5)
        helpTooltip:Hide()
    end)
end

local function BuildButton(frame, relativeTo, tooltip, tooltipText)
    local button = CreateFrame("Button", nil, frame, "ModelControlButtonTemplate")
    InitButton(button, frame, relativeTo, tooltip, tooltipText)

    return button
end

local function CheckButtonStatus(self)
    if self:GetChecked() then
        self:OnMouseDown()
    else
        self:OnMouseUp()
    end
end

local function BuildCheckButton(frame, relativeTo, tooltip, tooltipText, OnInitShow)
    local button = CreateFrame("CheckButton", nil, frame, "ModelControlButtonTemplate")
    InitButton(button, frame, relativeTo, tooltip, tooltipText)
    button:HookScript("OnShow", OnInitShow)
    button:HookScript("OnShow", CheckButtonStatus)
    button:HookScript("OnClick", CheckButtonStatus)

    return button
end

local function BuildCameraButton(frame, relativeTo, tooltip, tooltipText, cameraMode, amountPerSceond)
    local button = CreateFrame("Button", nil, frame, "ModelControlButtonTemplate,ModifyOrbitCameraBaseButtonTemplate")
    button:SetSize(18, 18)
    InitButton(button, frame, relativeTo, tooltip, tooltipText)

    button.cameraMode = cameraMode
    button.amountPerSecond = amountPerSceond
    button.GetActiveOrbitCamera = function()
        return MountJournal.MountDisplay.ModelScene:GetActiveCamera()
    end

    button:HookScript("OnMouseDown", ModelControlButtonMixin.OnMouseDown)
    button:HookScript("OnMouseUp", ModelControlButtonMixin.OnMouseUp)

    return button
end

local function BuildCameraPanel()
    local L = ADDON.L

    local frame = BuildControlContainer(166)
    frame:SetPoint("BOTTOM", 0, 15)

    helpTooltip = CreateFrame("GameTooltip", "MJEDisplayHelpToolTip", frame, "SharedNoHeaderTooltipTemplate")

    local scene = MountJournal.MountDisplay.ModelScene
    scene:HookScript("OnEnter", function()
        frame:Show()
    end)
    scene:HookScript("OnLeave", function()
        frame:Hide()
    end)

    local special = BuildButton(frame, nil, "/mountspecial")
    special.icon:SetTexture("Interface/GossipFrame/CampaignGossipIcons") -- from atlas: campaignavailablequesticon
    special.icon:SetTexCoord(0.1875, 0.421875, 0.37, 0.85)
    special:HookScript("OnClick", function()
        local actor = MountJournal.MountDisplay.ModelScene:GetActorByTag("unwrapped")
        if actor then
            actor:SetAnimationBlendOperation(LE_MODEL_BLEND_OPERATION_ANIM)
            actor:PlayAnimationKit(1371)
            actor:PlayAnimationKit(1371) -- animation gets sometimes canceled. second call is to enforce it.
        end
    end)

    local char = BuildCheckButton(frame, special, MOUNT_JOURNAL_PLAYER, nil, PlayerPreviewToggle.OnShow)
    char.icon:SetTexture(386865) -- interface/friendsframe/ui-toast-toasticons.blp
    char.icon:SetTexCoord(0.04, 0.58, 0.04, 0.92, 0.21, 0.58, 0.21, 0.92)
    char.icon:SetVertexColor(1, 0.7, 0.1)
    char:HookScript("OnClick", function(self)
        if self:GetChecked() then
            SetCVar("mountJournalShowPlayer", 1)
        else
            SetCVar("mountJournalShowPlayer", 0)
        end
        ADDON.UI:UpdateMountDisplay(true)
    end)

    local zoomIn = BuildCameraButton(frame, char, ZOOM_IN, KEY_MOUSEWHEELUP, ORBIT_CAMERA_MOUSE_MODE_ZOOM, 0.9)
    zoomIn.icon:SetTexCoord(0.57812500, 0.82812500, 0.14843750, 0.27343750)

    local zoomOut = BuildCameraButton(frame, zoomIn, ZOOM_OUT, KEY_MOUSEWHEELDOWN, ORBIT_CAMERA_MOUSE_MODE_ZOOM, -0.9)
    zoomOut.icon:SetTexCoord(0.29687500, 0.54687500, 0.00781250, 0.13281250)

    local rotateLeft = BuildCameraButton(frame, zoomOut, ROTATE_LEFT, ROTATE_TOOLTIP, ORBIT_CAMERA_MOUSE_MODE_YAW_ROTATION, -3)
    rotateLeft.icon:SetTexCoord(0.01562500, 0.26562500, 0.28906250, 0.41406250)

    local rotateRight = BuildCameraButton(frame, rotateLeft, ROTATE_RIGHT, ROTATE_TOOLTIP, ORBIT_CAMERA_MOUSE_MODE_YAW_ROTATION, 3)
    rotateRight.icon:SetTexCoord(0.57812500, 0.82812500, 0.28906250, 0.41406250)

    local rotateUp = BuildCameraButton(frame, rotateRight, L.ROTATE_UP, ROTATE_TOOLTIP, ORBIT_CAMERA_MOUSE_MODE_PITCH_ROTATION, -3)
    rotateUp.icon:SetTexCoord(0.01562500, 0.26562500, 0.28906250, 0.41406250)
    rotateUp.icon:SetRotation(-90)

    local rotateDown = BuildCameraButton(frame, rotateUp, L.ROTATE_DOWN, ROTATE_TOOLTIP, ORBIT_CAMERA_MOUSE_MODE_PITCH_ROTATION, 3)
    rotateDown.icon:SetTexCoord(0.57812500, 0.82812500, 0.28906250, 0.41406250)
    rotateDown.icon:SetRotation(-90)

    local reset = BuildButton(frame, rotateDown, RESET_POSITION)
    reset:HookScript("OnClick", function()
        local cam = MountJournal.MountDisplay.ModelScene:GetActiveCamera()
        if cam then
            local info = cam.modelSceneCameraInfo
            cam:SetPitch(info.pitch)
            cam:SetYaw(info.yaw)
            cam:SetZoomDistance(info.zoomDistance);
        end
    end)
end

ADDON.Events:RegisterCallback("loadUI", function()
    HideOriginalElements()
    SetupModelActor()
    BuildCameraPanel()
end, "display director")