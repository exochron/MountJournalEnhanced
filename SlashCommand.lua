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

    elseif (msg == "shop on") then
        ADDON.settings.showShopButton = true
        print("MountJournalEnhanced: shop button activated.")
        ADDON:ToggleShopButton()
    elseif (msg == "shop off") then
        ADDON.settings.showShopButton = false
        print("MountJournalEnhanced: shop button deactivated.")
        ADDON:ToggleShopButton()

    else
        print("Syntax:")
        print("/mje shop (on | off)")
        print("/mje debug (on | off)")
    end
end