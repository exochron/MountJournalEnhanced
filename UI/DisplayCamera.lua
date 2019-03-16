local ADDON_NAME, ADDON = ...

-- unlock Y rotation with mouse

local function SetupCamera()
    if ADDON.settings.unlockDisplayCamera then
        local cam = MountJournal.MountDisplay.ModelScene:GetActiveCamera()
        if cam then
            cam:SetLeftMouseButtonYMode(ORBIT_CAMERA_MOUSE_MODE_PITCH_ROTATION)

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
end

ADDON:RegisterLoadUICallback(function()
    hooksecurefunc(MountJournal.MountDisplay.ModelScene, "SetActiveCamera", SetupCamera)
end)