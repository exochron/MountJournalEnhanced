local _, ADDON = ...

-- Normally the rider flies from over the saddle into it every time you switch to another mount.
-- It seems that the playerActor starts with some animation, which has that as first position.
-- With the AnimationBlendOperation=ANIM and some other SetAnimation() call during mountActor:AttachToMount()
-- the rider basically blends back into the saddle.
-- Therefore setting the AnimationBlendOperation=NONE beforehand avoids that issue.
local function fixInitialRiderBlend()
    local playerActor = MountJournal.MountDisplay.ModelScene:GetPlayerActor("player-rider")
    if playerActor then
        playerActor:SetAnimationBlendOperation(LE_MODEL_BLEND_OPERATION_NONE)
    end
end

ADDON.Events:RegisterCallback("loadUI", function()
    fixInitialRiderBlend()
end, "blizz plz fix")