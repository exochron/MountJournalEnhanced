local ADDON_NAME, ADDON = ...

SLASH_MOUNTJOURNALENHANCED1, SLASH_MOUNTJOURNALENHANCED2 = '/mountjournalenhanced', '/mje'
function SlashCmdList.MOUNTJOURNALENHANCED(msg, editBox)
    msg = msg:lower()

    if (msg == "debug on") then
        ADDON.settings.debugMode = true
        print("MountJournalEnhanced: Debug mode activated.")
        if ADDON.initialized then
            ADDON:RunDebugTest()
        end
    elseif (msg == "debug off") then
        ADDON.settings.debugMode = false
        print("MountJournalEnhanced: Debug mode deactivated.")

    else
        local title = GetAddOnMetadata(ADDON_NAME, "Title")
        InterfaceOptionsFrame_OpenToCategory(title)
        InterfaceOptionsFrame_OpenToCategory(title)
    end
end