local ADDON_NAME, ADDON = ...

local function CreateAchievementPoints()
    local MOUNT_ACHIEVEMENT_CATEGORY = 15248

    local frame = CreateFrame("Button", nil, MountJournal)

    frame:ClearAllPoints()
    frame:SetPoint("TOP", MountJournal, -50, -21)
    frame:SetSize(60, 40)

    frame.bgLeft = frame:CreateTexture(nil, "BACKGROUND")
    frame.bgLeft:SetAtlas("PetJournal-PetBattleAchievementBG")
    frame.bgLeft:ClearAllPoints()
    frame.bgLeft:SetSize(46, 18)
    frame.bgLeft:SetPoint("Top", -56, -12)
    frame.bgLeft:SetVertexColor(1, 1, 1, 1)

    frame.bgRight = frame:CreateTexture(nil, "BACKGROUND")
    frame.bgRight:SetAtlas("PetJournal-PetBattleAchievementBG")
    frame.bgRight:ClearAllPoints()
    frame.bgRight:SetSize(46, 18)
    frame.bgRight:SetPoint("Top", 55, -12)
    frame.bgRight:SetVertexColor(1, 1, 1, 1)
    frame.bgRight:SetTexCoord(1, 0, 0, 1)

    frame.highlight = frame:CreateTexture(nil)
    frame.highlight:SetDrawLayer("BACKGROUND", 1)
    frame.highlight:SetAtlas("PetJournal-PetBattleAchievementGlow")
    frame.highlight:ClearAllPoints()
    frame.highlight:SetSize(210, 40)
    frame.highlight:SetPoint("CENTER", 0, 0)
    frame.highlight:SetShown(false)

    frame.icon = frame:CreateTexture(nil, "OVERLAY")
    frame.icon:SetTexture("Interface\\AchievementFrame\\UI-Achievement-Shields-NoPoints")
    frame.icon:ClearAllPoints()
    frame.icon:SetSize(30, 30)
    frame.icon:SetPoint("RIGHT", 0, -5)
    frame.icon:SetTexCoord(0, 0.5, 0, 0.5)

    frame.staticText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    frame.staticText:ClearAllPoints()
    frame.staticText:SetPoint("RIGHT", frame.icon, "LEFT", -4, 4)
    frame.staticText:SetSize(0, 0)
    frame.staticText:SetText(GetCategoryAchievementPoints(MOUNT_ACHIEVEMENT_CATEGORY, true))

    frame:SetScript("OnClick", function()
        if ACHIEVEMENT_FUNCTIONS then
            ACHIEVEMENT_FUNCTIONS.selectedCategory = MOUNT_ACHIEVEMENT_CATEGORY
        else
            local onLoadAddon = CreateFrame("FRAME")
            onLoadAddon:RegisterEvent("ADDON_LOADED")
            onLoadAddon:SetScript("OnEvent", function(self, event, arg1)
                if arg1 == "Blizzard_AchievementUI" then
                    local doSwitch = true
                    AchievementFrame:HookScript("OnShow", function ()
                        if doSwitch then
                            ACHIEVEMENT_FUNCTIONS.selectedCategory = MOUNT_ACHIEVEMENT_CATEGORY
                            AchievementFrame_ForceUpdate()
                            doSwitch = false
                        end
                    end)
                end
            end)
        end
        ToggleAchievementFrame()

    end)
    frame:SetScript("OnEnter", function()
        frame.highlight:SetShown(true)
    end)
    frame:SetScript("OnLeave", function()
        frame.highlight:SetShown(false)
    end)

    frame:RegisterEvent("ACHIEVEMENT_EARNED")
    frame:SetScript("OnEvent", function(self, event, ...)
        frame.staticText:SetText(GetCategoryAchievementPoints(MOUNT_ACHIEVEMENT_CATEGORY, true))
    end)

    return frame
end

local frame

ADDON:RegisterUISetting('showAchievementPoints', true, ADDON.L.SETTING_ACHIEVEMENT_POINTS, function(flag)
    if ADDON.initialized then
        if not frame and flag then
            frame = CreateAchievementPoints()
        end

        if frame then
            frame:SetShown(flag)
        end
    end
end)

ADDON.Events:RegisterCallback("loadUI", function()
    ADDON:ApplySetting('showAchievementPoints', ADDON.settings.ui.showAchievementPoints)
end, "achievements")