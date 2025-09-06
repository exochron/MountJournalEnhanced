local _, ADDON = ...

function ADDON:TakeScreenshots()

    -- hide UI elements
    local UIElementsToHide={
        ChatFrame1,
        ChatFrame1EditBox,
        MainMenuBar,
        PlayerFrame,
        BuffFrame,
    }
    for _, frame in pairs(UIElementsToHide) do
        frame:Hide()
    end

    C_CVar.SetCVar("mountJournalShowPlayer", 0) -- hide player

    if WeakAuras then
        WeakAuras:Toggle() -- turn off WA
    end
    ToggleCollectionsJournal(COLLECTIONS_JOURNAL_TAB_INDEX_MOUNTS)

    -- give time to load properly
    C_Timer.After(0.5, function()
        local gg = LibStub("GalleryGenerator")

        gg:TakeScreenshots(
            {
                function(api)
                    api:BackScreen()
                    api:Click(MountJournal.FilterDropdown.ResetButton)

                    ADDON.Api:SetSelected(1727) --select Tarecgosa's Visage
                    -- adjust camera
                    MountJournal.MountDisplay.ModelScene:GetActiveCamera():SetYaw(3.6334)
                    MountJournal.MountDisplay.ModelScene:GetActiveCamera():SetPitch(0.6171)

                    -- fire /mountspecial
                    MountJournal.MountDisplay.ModelScene:GetActorByTag("unwrapped"):PlayAnimationKit(1371)
                    MountJournal.MountDisplay.ModelScene:GetActorByTag("unwrapped"):PlayAnimationKit(1371)

                    api:Wait()
                    C_Timer.After(2, function()
                        api:Point(MountJournal.MountDisplay.ModelScene.ControlFrame.specialButton)
                        api:Continue()
                    end)
                end,
                function(api)
                    api:BackScreen()

                    C_CVar.SetCVar("mountJournalShowPlayer", 1) -- show rider
                    ADDON.Api:SetSelected(764) --select Grove Warden
                    MountJournal.MountDisplay.ModelScene:Reset()

                    MountJournal.FilterDropdown:OpenMenu()
                    api:WaitAndPointOnMenuElement(1,1,function(element)
                        local profiles = {element:GetChildren()}
                        api:Point(profiles[3]) -- filter profiles
                        api:Continue()
                    end)
                end,
                function(api)
                    api:BackScreen()

                    MountJournal.FilterDropdown:OpenMenu()
                    api:WaitAndPointOnMenuElement(1,3,function() -- sort
                        api:WaitAndPointOnMenuElement(2,5) -- rarity
                    end)
                end,
                function(api)
                    api:BackScreen()

                    MountJournal.FilterDropdown:OpenMenu()
                    api:WaitAndPointOnMenuElement(1,13, function() -- sources
                        api:WaitAndPointOnMenuElement(2,4, -- world events
                        function()
                            api:WaitAndPointOnMenuElement(3,4, nil, 10) -- timewalking
                        end)
                    end)
                end,
                function(api)
                    api:BackScreen()
                    MountJournal.FilterDropdown:OpenMenu()
                    api:WaitAndPointOnMenuElement(1,14) -- Type
                end,
                function(api)
                    api:BackScreen()
                    MountJournal.FilterDropdown:OpenMenu()
                    api:WaitAndPointOnMenuElement(1,16, function() -- family
                        api:WaitAndPointOnMenuElement(2,7) -- Birds
                    end)
                end,
                function(api)
                    api:BackScreen()
                    MountJournal.FilterDropdown:OpenMenu()
                    api:WaitAndPointOnMenuElement(1,18) -- Color
                end,
                function(api)
                    api:BackScreen()
                    MountJournal.FilterDropdown:OpenMenu()
                    api:WaitAndPointOnMenuElement(1,19) -- Rarity
                end,
                function(api)
                    api:BackScreen()

                    ADDON.Api:SetSelected(1057) -- Nazjatar Blood Serpent
                    local noteFrame = ADDON.UI:CreateNotesFrame(1057)
                    C_Timer.After(1.1, function()
                        noteFrame:Hide()
                    end)

                    local button = MountJournal.ScrollBox:FindFrameByPredicate(function(frame)
                        return frame:GetElementData().mountID == 1057
                    end)
                    api:Point(button)
                    api:Click(button, "RightButton")

                    local menuButtons = { Menu.GetManager():GetOpenMenu():GetChildren()}
                    api:Point(menuButtons[6], 10) -- Set Note
                end,
                function(api)
                    api:BackScreen()
                    api:Point(ADDON.UI.FavoriteButton)
                    ADDON.UI.FavoriteButton:OpenMenu()
                end,
                function(api)
                    api:BackScreen()
                    api:Point(ADDON.UI.SettingsButton)
                    ADDON.UI.SettingsButton:OpenMenu()
                end,
                function(api)
                    api:BackScreen()
                    api:Click(ADDON.UI.PetAssignmentToolbarButton)
                    api:PointAndClick(ADDON.UI.PetAssignmentInfoButton)
                end,
                function(api)
                    ToggleCollectionsJournal()

                    api:BackScreen()

                    -- show mount preview
                    DressUpMount(1357) -- Enchanted Shadeleaf Runestag

                    api:Point(ADDON.UI.DressUpJournalButton, 17)
                end,
                function(api)
                    HideUIPanel(DressUpFrame)

                    api:BackScreen()
                    ADDON:OpenOptions()
                end,
            },
            function()
                for _, frame in pairs(UIElementsToHide) do
                    frame:Show()
                end
                if WeakAuras then
                    WeakAuras:Toggle() -- turn on WA
                end

                C_CVar.SetCVar("mountJournalShowPlayer", 1) -- show player
            end
        )
    end)
end