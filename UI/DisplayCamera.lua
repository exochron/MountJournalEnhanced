local ADDON_NAME, ADDON = ...

-- unlock Y rotation with mouse

local function SetupCamera()
    if ADDON.settings.unlockDisplayCamera then
        local cam = MountJournal.MountDisplay.ModelScene:GetActiveCamera()
        if cam then
            cam:SetLeftMouseButtonYMode(ORBIT_CAMERA_MOUSE_MODE_PITCH_ROTATION)
        end
    end
end

hooksecurefunc(ADDON, "LoadUI", function()
    hooksecurefunc(MountJournal.MountDisplay.ModelScene, "SetActiveCamera", SetupCamera)
end)