local _, ADDON = ...

-- can we skip known useless updates because its called a second time immediately anyway?
local function shouldSkipUpdate()
    local callTrace = debugstack(0, 0, 4)
    if string.find(callTrace, "AlertFrameSystems.lua") then
        -- our update gets called 3 times with a click on popup for new mount. it even taints with PrepareForFanfare.
        if string.find(callTrace, "SetCollectionsJournalShown") then
            return true
        end

        if string.find(callTrace, "MountJournal_SelectByMountID") -- the original select call
                and not string.find(callTrace, "Api.lua") -- our hooked api
        then
            return true
        end
    end

    return false
end

--- This is the hooked version of MountJournal_UpdateMountDisplay() which calls the Api.
--- The whole reason for this is to avoid some code taint.
---
--- from https://www.townlong-yak.com/framexml/live/Blizzard_Collections/Blizzard_MountCollection.lua#533
function ADDON.UI:UpdateMountDisplay(forceSceneChange)
    if ADDON.initialized and ADDON.Api:GetSelected() and not shouldSkipUpdate() then
        local creatureName, spellID, icon, active, isUsable, _ = C_MountJournal.GetMountInfoByID(ADDON.Api:GetSelected());
        local needsFanfare = C_MountJournal.NeedsFanfare(ADDON.Api:GetSelected());
        if (MountJournal.MountDisplay.MJE_lastDisplayed ~= spellID or forceSceneChange) then
            local creatureDisplayID, descriptionText, sourceText, isSelfMount, _, modelSceneID, animID, spellVisualKitID, disablePlayerMountPreview = C_MountJournal.GetMountInfoExtraByID(ADDON.Api:GetSelected());
            if not creatureDisplayID then
                local randomSelection = false;
                creatureDisplayID = MountJournalMountButton_ChooseFallbackMountToDisplay(ADDON.Api:GetSelected(), randomSelection);
            end
            MountJournal.MountDisplay.InfoButton.Name:SetText(creatureName);
            if needsFanfare then
                MountJournal.MountDisplay.InfoButton.New:Show();
                MountJournal.MountDisplay.InfoButton.NewGlow:Show();
                local offsetX = math.min(MountJournal.MountDisplay.InfoButton.Name:GetStringWidth(), MountJournal.MountDisplay.InfoButton.Name:GetWidth());
                MountJournal.MountDisplay.InfoButton.New:SetPoint("LEFT", MountJournal.MountDisplay.InfoButton.Name, "LEFT", offsetX + 8, 0);
                MountJournal.MountDisplay.InfoButton.Icon:SetTexture(COLLECTIONS_FANFARE_ICON);
            else
                MountJournal.MountDisplay.InfoButton.New:Hide();
                MountJournal.MountDisplay.InfoButton.NewGlow:Hide();
                MountJournal.MountDisplay.InfoButton.Icon:SetTexture(icon);
            end
            MountJournal.MountDisplay.InfoButton.Source:SetText(sourceText);
            MountJournal.MountDisplay.InfoButton.Lore:SetText(descriptionText)
            MountJournal.MountDisplay.MJE_lastDisplayed = spellID;
            MountJournal.MountDisplay.ModelScene:TransitionToModelSceneID(modelSceneID, CAMERA_TRANSITION_TYPE_IMMEDIATE, CAMERA_MODIFICATION_TYPE_MAINTAIN, forceSceneChange);
            MountJournal.MountDisplay.ModelScene:PrepareForFanfare(needsFanfare);
            local mountActor = MountJournal.MountDisplay.ModelScene:GetActorByTag("unwrapped");
            if mountActor then
                mountActor:SetModelByCreatureDisplayID(creatureDisplayID);
                -- mount self idle animation
                if (isSelfMount) then
                    mountActor:SetAnimationBlendOperation(LE_MODEL_BLEND_OPERATION_NONE);
                    mountActor:SetAnimation(618); -- MountSelfIdle
                else
                    mountActor:SetAnimationBlendOperation(LE_MODEL_BLEND_OPERATION_ANIM);
                    mountActor:SetAnimation(0);
                end
                local showPlayer = GetCVarBool("mountJournalShowPlayer");
                if not disablePlayerMountPreview and not showPlayer then
                    disablePlayerMountPreview = true;
                end
                MountJournal.MountDisplay.ModelScene:AttachPlayerToMount(mountActor, animID, isSelfMount, disablePlayerMountPreview, spellVisualKitID);
            end
        end
        MountJournal.MountDisplay.ModelScene:Show();
        MountJournal.MountDisplay.YesMountsTex:Show();
        MountJournal.MountDisplay.InfoButton:Show();
        MountJournal.MountDisplay.NoMountsTex:Hide();
        MountJournal.MountDisplay.NoMounts:Hide();
        if (needsFanfare) then
            MountJournal.MountButton:SetText(UNWRAP)
            MountJournal.MountButton:Enable();
        elseif (active) then
            MountJournal.MountButton:SetText(BINDING_NAME_DISMOUNT);
            MountJournal.MountButton:SetEnabled(isUsable);
        else
            MountJournal.MountButton:SetText(MOUNT);
            MountJournal.MountButton:SetEnabled(isUsable);
        end
    else
        MountJournal.MountDisplay.InfoButton:Hide();
        MountJournal.MountDisplay.ModelScene:Hide();
        MountJournal.MountDisplay.YesMountsTex:Hide();
        MountJournal.MountDisplay.NoMountsTex:Show();
        MountJournal.MountDisplay.NoMounts:Show();
        MountJournal.MountButton:SetEnabled(false);
    end

    ADDON.Events:TriggerEvent("OnUpdateMountDisplay")
end

ADDON.Events:RegisterCallback("preloadUI", function()
    hooksecurefunc("MountJournal_UpdateMountDisplay", ADDON.UI.UpdateMountDisplay)

    -- overwrite default handler
    MountJournal.MountDisplay.ModelScene:SetScript("OnMouseUp", function(self, button)
        self:OnMouseUp(button)

        if ADDON.Api:GetSelected() and C_MountJournal.NeedsFanfare(ADDON.Api:GetSelected()) then
            ADDON.Api:UseMount(ADDON.Api:GetSelected())
        end
    end)
end, "enhanced display")