local ADDON_NAME, ADDON = ...

ADDON.Events:RegisterCallback("loadUI", function()
    if MountJournal.ToggleDynamicFlightFlyoutButton then
        --TODO setting for tww only ?

        MountJournal.ToggleDynamicFlightFlyoutButton:Hide()

        EventRegistry:RegisterCallback(
            "MountJournal.OnShow",
            function()
                MountJournal.ToggleDynamicFlightFlyoutButton:Hide()
            end,
            ADDON_NAME..'-skyriding'
        )

        ADDON.UI:RegisterToolbarGroup(
            'skyriding',
            MountJournal.DynamicFlightFlyout.OpenDynamicFlightSkillTreeButton,
            MountJournal.DynamicFlightFlyout.DynamicFlightModeButton
            -- TODO: add passenger toggle
        )
        MountJournal.DynamicFlightFlyout.OpenDynamicFlightSkillTreeButton:SetParent(MountJournal)
        MountJournal.DynamicFlightFlyout.OpenDynamicFlightSkillTreeButton:Show()
        MountJournal.DynamicFlightFlyout.DynamicFlightModeButton:SetParent(MountJournal)
        MountJournal.DynamicFlightFlyout.DynamicFlightModeButton:Show()
    else
        local AceGUI = LibStub("AceGUI-3.0")

        local skillTreeButton = AceGUI:Create("Icon")
        skillTreeButton:SetImage("Interface/ICONS/Ability_DragonRiding_Glyph01")
        skillTreeButton:SetImageSize(30, 30)
        skillTreeButton:SetWidth(30)
        skillTreeButton:SetHeight(30)
        skillTreeButton.image:SetPoint("TOP", 0, 0)
        skillTreeButton.frame:SetParent(MountJournal)
        skillTreeButton.frame:Show()
        skillTreeButton:SetCallback("OnClick", function()
            GenericTraitUI_LoadUI()
            GenericTraitFrame:SetSystemID(1)
            ToggleFrame(GenericTraitFrame)
        end)
        ADDON.UI:RegisterToolbarGroup('skyriding', skillTreeButton.frame)

        --todo maybe flight mode button for df ?
    end
end, 'skyriding' )
