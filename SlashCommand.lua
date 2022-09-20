local _, ADDON = ...

SLASH_MOUNTJOURNALENHANCED1, SLASH_MOUNTJOURNALENHANCED2 = '/mountjournalenhanced', '/mje'
function SlashCmdList.MOUNTJOURNALENHANCED(msg)
    msg = msg:lower()

    if msg == "debug on" then
        ADDON.settings.ui.debugMode = true
        print("MountJournalEnhanced: Debug mode activated.")
    elseif msg == "debug off" then
        ADDON.settings.ui.debugMode = false
        print("MountJournalEnhanced: Debug mode deactivated.")
    elseif msg == "reset size" then
        ADDON.UI:RestoreWindowSize()
    else
        ADDON:OpenOptions()
    end
end