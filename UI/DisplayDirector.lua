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
--42=swimming
--636=mountspecial


--region rotation buttons
local function ToggleRotationButtons(isShown)
    local scene = MountJournal.MountDisplay.ModelScene
    scene.RotateLeftButton:SetShown(isShown)
    scene.RotateRightButton:SetShown(isShown)
end

local function SetupRotationButtons()
    ToggleRotationButtons(false)
    local scene = MountJournal.MountDisplay.ModelScene
    scene:HookScript("OnEnter", function() ToggleRotationButtons(true)end)
    scene.RotateLeftButton:HookScript("OnEnter",function() ToggleRotationButtons(true) end)
    scene.RotateRightButton:HookScript("OnEnter",function() ToggleRotationButtons(true) end)
    scene:HookScript("OnLeave", function() ToggleRotationButtons(false) end)
end
--endregion

hooksecurefunc(ADDON, "LoadUI",function()
    SetupRotationButtons()
end )