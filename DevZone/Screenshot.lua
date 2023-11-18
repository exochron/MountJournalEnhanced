local _, ADDON = ...

-- TODO:
-- - take shots
-- - move latest X files into /Images/
-- - crop images
-- - ci: upload to cf
-- - ci: upload to wago

local cursor
local backScreen

local function TakeScreenshots(shotHandlers, doneHandler)
    local previousQuality = C_CVar.GetCVar("screenshotQuality")
    if previousQuality ~= "10" then
        C_CVar.SetCVar("screenshotQuality", 10)
    end

    local isInterrupted = false
    local function shoot()
        C_Timer.After(1, function()
            if not isInterrupted then
                Screenshot()
            end
        end)
    end

    local function onDone()
        cursor:UnregisterAllEvents()

        if previousQuality ~= "10" then
            C_CVar.SetCVar("screenshotQuality", previousQuality)
        end

        if doneHandler then
            doneHandler()
        end
    end

    local internalAPI = {}
    internalAPI.Point = function(targetFrame, offsetX, offsetY)
        cursor:SetPoint("TOPLEFT", targetFrame, "CENTER", offsetX or 0, offsetY or 0)
        cursor:Show()

        local function bubbleEvent(frame, event)
            local onEvent = frame:GetScript(event)
            if onEvent then
                onEvent(frame, false)
            end
            local parent = frame:GetParent()
            if parent then
                bubbleEvent(parent, event)
            end
        end
        bubbleEvent(targetFrame, "OnEnter")
        C_Timer.After(1.1, function()
            bubbleEvent(targetFrame, "OnLeave")
        end)
    end
    internalAPI.Click = function(targetFrame, button)
        local function trigger(event, ...)
            local onEvent = targetFrame:GetScript(event)
            if onEvent then
                onEvent(targetFrame, button or "LeftButton", ...)
            end
        end
        trigger("OnMouseDown")
        trigger("OnMouseUp")
        trigger("PreClick", false)
        trigger("OnClick", false)
        trigger("PostClick", false)
    end
    internalAPI.PointAndClick = function(targetFrame)
        internalAPI.Point(targetFrame)
        internalAPI.Click(targetFrame)
    end
    internalAPI.Wait = function()
        isInterrupted = true
    end
    internalAPI.Continue = function()
        if isInterrupted then
            isInterrupted = false
            shoot()
        end
    end
    internalAPI.BackScreen = function(red, green, blue)
        if not backScreen then
            backScreen = UIParent:CreateTexture()
            backScreen:SetAllPoints()
        end

        backScreen:SetColorTexture(red or 0, green or 0, blue or 0, 1)
        backScreen:Show()
    end

    if not cursor then
        cursor = CreateFrame("Frame")
        cursor:SetSize(20, 20)
        cursor:SetFrameStrata("TOOLTIP")

        cursor.tex = cursor:CreateTexture()
        cursor.tex:SetAllPoints()
        cursor.tex:SetTexture(131028) --interface/cursor/point.blp
        cursor:Hide()
    end

    local currentIndex

    local function proceed()
        local currentHandler
        currentIndex, currentHandler = next(shotHandlers, currentIndex)
        if currentIndex and currentHandler then
            currentHandler(internalAPI)
            shoot()
        else
            onDone()
        end
    end

    cursor:RegisterEvent("SCREENSHOT_SUCCEEDED")
    cursor:RegisterEvent("SCREENSHOT_FAILED")
    cursor:SetScript("OnEvent", function(_, event)
        cursor:Hide()
        if backScreen then
            backScreen:Hide()
        end

        if event == "SCREENSHOT_SUCCEEDED" then
            proceed()
        else
            onDone()
        end
    end)

    proceed()
end

function ADDON:TakeScreenshots()

    MainMenuBar:Hide()
    if WeakAuras then
        WeakAuras:Toggle() -- turn off WA
    end
    MountJournalEnhanced_Open()

    -- give time to load properly
    C_Timer.After(0.5, function()
        TakeScreenshots({
            function(api)
                api.BackScreen()
                api.Click(MountJournalFilterButton.ResetButton)

                C_CVar.SetCVar("mountJournalShowPlayer", 0) -- hide rider

                ADDON.Api:SetSelected(1727) --select Tarecgosa's Visage
                -- adjust camera
                MountJournal.MountDisplay.ModelScene:GetActiveCamera():SetYaw(3.6334)
                MountJournal.MountDisplay.ModelScene:GetActiveCamera():SetPitch(0.6171)

                -- fire /mountspecial
                MountJournal.MountDisplay.ModelScene:GetActorByTag("unwrapped"):SetAnimation(94)

                api.Wait()
                C_Timer.After(2, function()
                    api.Point(MountJournal.MountDisplay.ModelScene.ControlFrame.specialButton)
                    api.Continue()
                end)
            end,
            function(api)
                api.BackScreen()

                C_CVar.SetCVar("mountJournalShowPlayer", 1) -- show rider
                ADDON.Api:SetSelected(764) --select Grove Warden
                MountJournal.MountDisplay.ModelScene:Reset()

                api.Click(MountJournalFilterButton)

                assert(DropDownList1Button1NormalText:GetText() == RAID_FRAME_SORT_LABEL)
                api.Point(DropDownList1Button1)

                assert(DropDownList2Button5NormalText:GetText() == ADDON.L.SORT_BY_USAGE_COUNT)
                api.Point(DropDownList2Button5, 20)
            end,
            function(api)
                api.BackScreen()
                api.Point(DropDownList1Button11) -- Sources
            end,
            function(api)
                api.BackScreen()
                api.Point(DropDownList1Button12) -- Type
            end,
            function(api)
                api.BackScreen()

                api.Point(DropDownList1Button14)
                api.Click(DropDownList2Button2) -- deselect all
                api.Click(DropDownList2Button15) -- Drakes
                api.Point(DropDownList2Button6) -- Birds
                api.Click(DropDownList3Button3) -- Crows
                api.PointAndClick(DropDownList3Button8, 20) -- Owl
            end,
            function(api)
                api.BackScreen()
                api.Click(MountJournalFilterButton.ResetButton)
                api.Point(DropDownList1Button16) --Color
            end,
            function(api)
                api.BackScreen()
                api.Point(DropDownList1Button17) --Rarity
            end,
            function(api)
                api.BackScreen()
                api.Click(MountJournalFilterButton)

                ADDON.Api:SetSelected(1057) -- Nazjatar Blood Serpent
                local noteFrame = ADDON.UI:CreateNotesFrame(1057)
                C_Timer.After(1.1, function() noteFrame:Hide()  end)
            end,
            function(api)
                api.BackScreen()
                api.PointAndClick(ADDON.UI.FavoriteButton)
            end,
            function(api)
                api.BackScreen()
                api.PointAndClick(ADDON.UI.SettingsButton)
            end,
            function(api)
                api.BackScreen()
                ADDON:OpenOptions()
            end,
        },
                function()
                    MainMenuBar:Show()
                    if WeakAuras then
                        WeakAuras:Toggle() -- turn on WA
                    end
                end
        )
    end)
end