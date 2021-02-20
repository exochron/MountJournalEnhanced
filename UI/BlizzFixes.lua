local ADDON_NAME, ADDON = ...

-- Normally the rider flies from over the saddle into it every time you switch to another mount.
-- It seems that the playerActor starts with some animation, which has that as first position.
-- With the AnimationBlendOperation=ANIM and some other SetAnimation() call during mountActor:AttachToMount()
-- the rider basically blends back into the saddle.
-- Therefore setting the AnimationBlendOperation=NONE beforehand avoids that issue.
local function fixInitialRiderBlend()
    local org_attachPlayer = MountJournal.MountDisplay.ModelScene.AttachPlayerToMount
    MountJournal.MountDisplay.ModelScene.AttachPlayerToMount = function(self, mountActor, animID, isSelfMount, disablePlayerMountPreview, spellVisualKitID)
        local previousBlend
        local playerActor = self:GetPlayerActor("player-rider");
        if playerActor then
            previousBlend = playerActor:GetAnimationBlendOperation()
            playerActor:SetAnimationBlendOperation(LE_MODEL_BLEND_OPERATION_NONE)
        end

        org_attachPlayer(self, mountActor, animID, isSelfMount, disablePlayerMountPreview, spellVisualKitID)

        if nil ~= previousBlend then
            playerActor:SetAnimationBlendOperation(previousBlend)
        end
    end
end

ADDON:RegisterLoadUICallback(function()
    fixInitialRiderBlend()
end)