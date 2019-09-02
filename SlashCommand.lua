local ADDON_NAME, ADDON = ...

SLASH_MOUNTJOURNALENHANCED1, SLASH_MOUNTJOURNALENHANCED2 = '/mountjournalenhanced', '/mje'
function SlashCmdList.MOUNTJOURNALENHANCED(msg, editBox)
    msg = msg:lower()

    if (msg == "debug on") then
        ADDON.settings.ui.debugMode = true
        print("MountJournalEnhanced: Debug mode activated.")
    elseif (msg == "debug off") then
        ADDON.settings.ui.debugMode = false
        print("MountJournalEnhanced: Debug mode deactivated.")
    else
        local title = GetAddOnMetadata(ADDON_NAME, "Title")
        InterfaceOptionsFrame_OpenToCategory(title)
        InterfaceOptionsFrame_OpenToCategory(title)
    end
end