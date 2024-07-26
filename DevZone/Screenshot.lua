local _, ADDON = ...

function ADDON:TakeScreenshots()

    -- hide UI elements
    local UIElementsToHide={
        ChatFrame1,
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

    local function OpenFilterMenu()
        MountJournal.FilterDropdown:SetMenuOpen(true)

        return { Menu.GetManager():GetOpenMenu():GetChildren() }
    end

    -- give time to load properly
    C_Timer.After(0.5, function()
        local gg = LibStub("GalleryGenerator")

        gg:TakeScreenshots(
            {
                function(api)
                    api:BackScreen()
                    api:Click(MountJournal.FilterDropdown.ResetButton)

                    C_CVar.SetCVar("mountJournalShowPlayer", 0) -- hide rider

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

                    api:Point(OpenFilterMenu()[3]) -- sort
                end,
                function(api)
                    api:BackScreen()
                    MountJournal.FilterDropdown:SetMenuOpen(true)

                    api:Point(OpenFilterMenu()[13]) -- Sources
                end,
                function(api)
                    api:BackScreen()

                    api:Point(OpenFilterMenu()[14]) -- Type
                end,
                function(api)
                    api:BackScreen()

                    api:Point(OpenFilterMenu()[16]) -- Family
                end,
                function(api)
                    api:BackScreen()
                    api:Point(OpenFilterMenu()[18]) -- Color
                end,
                function(api)
                    api:BackScreen()
                    api:Point(OpenFilterMenu()[19]) -- Rarity
                end,
                function(api)
                    api:BackScreen()
                    MountJournal.FilterDropdown:SetMenuOpen(false)

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
                    ADDON.UI.FavoriteButton:SetMenuOpen(true)
                end,
                function(api)
                    api:BackScreen()
                    api:Point(ADDON.UI.SettingsButton)
                    ADDON.UI.SettingsButton:SetMenuOpen(true)
                end,
                function(api)
                    api:BackScreen()

                    api:Click(MountJournal.DynamicFlightFlyout.OpenDynamicFlightSkillTreeButton)

                    api:Point(ADDON.UI.SkyridingSpendAllGlyphsButton, 22)
                end,
                function(api)
                    HideUIPanel(GenericTraitFrame)

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