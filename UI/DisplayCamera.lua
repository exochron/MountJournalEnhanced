local ADDON_NAME, ADDON = ...

-- unlock Y rotation with mouse

function ADDON:ApplyUnlockDisplayCamera(flag)
    ADDON.settings.ui.unlockDisplayCamera = flag
    if (MountJournal) then
        local cam = MountJournal.MountDisplay.ModelScene:GetActiveCamera()
        if cam then
            if flag then
                cam:SetLeftMouseButtonYMode(ORBIT_CAMERA_MOUSE_MODE_PITCH_ROTATION)
            else
                cam:SetLeftMouseButtonYMode(ORBIT_CAMERA_MOUSE_MODE_NOTHING)
            end
        end
    end
end

local function SetupCamera()
    local cam = MountJournal.MountDisplay.ModelScene:GetActiveCamera()
    if cam then
        ADDON:ApplyUnlockDisplayCamera(ADDON.settings.ui.unlockDisplayCamera)

        -- revert Y rotation for a better feel
        local org_GetDelta = cam.GetDeltaModifierForCameraMode
        cam.GetDeltaModifierForCameraMode = function(self, mode)
            local result = org_GetDelta(self, mode)
            if (mode == ORBIT_CAMERA_MOUSE_MODE_PITCH_ROTATION) then
                result = -result
            end

            return result
        end
    end
end

ADDON:RegisterLoadUICallback(function()
    hooksecurefunc(MountJournal.MountDisplay.ModelScene, "SetActiveCamera", SetupCamera)
end)