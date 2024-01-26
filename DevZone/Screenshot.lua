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

    -- give time to load properly
    C_Timer.After(0.5, function()
        local gg = LibStub("GalleryGenerator")

        gg:TakeScreenshots(
            {
                function(api)
                    api:BackScreen()
                    api:Click(MountJournalFilterButton.ResetButton)

                    C_CVar.SetCVar("mountJournalShowPlayer", 0) -- hide rider

                    ADDON.Api:SetSelected(1727) --select Tarecgosa's Visage
                    -- adjust camera
                    MountJournal.MountDisplay.ModelScene:GetActiveCamera():SetYaw(3.6334)
                    MountJournal.MountDisplay.ModelScene:GetActiveCamera():SetPitch(0.6171)

                    -- fire /mountspecial
                    MountJournal.MountDisplay.ModelScene:GetActorByTag("unwrapped"):SetAnimation(94)

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

                    api:Click(MountJournalFilterButton)

                    api:Point(DropDownList1Button1)

                    api:Point(DropDownList2Button5, 20)
                end,
                function(api)
                    api:BackScreen()
                    api:Click(MountJournalFilterButton)
                    api:Point(DropDownList1Button11) -- Sources
                end,
                function(api)
                    api:BackScreen()
                    api:Click(MountJournalFilterButton)
                    api:Point(DropDownList1Button12) -- Type
                end,
                function(api)
                    api:BackScreen()

                    api:Click(MountJournalFilterButton)

                    api:Point(DropDownList1Button14)
                    api:Click(DropDownList2Button2) -- deselect all
                    api:Click(DropDownList2Button15) -- Drakes
                    api:Point(DropDownList2Button6) -- Birds
                    api:Click(DropDownList3Button3) -- Crows
                    api:PointAndClick(DropDownList3Button8, 20) -- Owl
                end,
                function(api)
                    api:BackScreen()
                    api:Click(MountJournalFilterButton.ResetButton)
                    api:Click(MountJournalFilterButton)
                    api:Point(DropDownList1Button16) --Color
                end,
                function(api)
                    api:BackScreen()
                    api:Click(MountJournalFilterButton)
                    api:Point(DropDownList1Button17) --Rarity
                end,
                function(api)
                    api:BackScreen()
                    api:Click(MountJournalFilterButton)

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
                    api:Point(DropDownList1Button4, 10)
                end,
                function(api)
                    api:BackScreen()
                    api:PointAndClick(ADDON.UI.FavoriteButton)
                end,
                function(api)
                    api:BackScreen()
                    api:PointAndClick(ADDON.UI.SettingsButton)
                end,
                function(api)
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