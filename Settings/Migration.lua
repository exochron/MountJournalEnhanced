local ADDON_NAME, ADDON = ...

-- This script migrates the settings from personal scope to the current mixed scopes (2.5)

ADDON:RegisterLoginCallback(function()
    if MountJournalEnhancedSettings and 0 == #MJEPersonalSettings then
        MJEPersonalSettings = {
            personalUi = true,
            ui = {
                showShopButton = MountJournalEnhancedSettings.showShopButton,
                compactMountList = MountJournalEnhancedSettings.compactMountList,
                unlockDisplayCamera = MountJournalEnhancedSettings.unlockDisplayCamera,
                enableCursorKeys = MountJournalEnhancedSettings.enableCursorKeys,
                moveEquipmentSlot = MountJournalEnhancedSettings.moveEquipmentSlot,
            },

            favoritePerChar = MountJournalEnhancedSettings.favoritePerChar,
            favoredMounts = MountJournalEnhancedSettings.favoredMounts,

            hiddenMounts = MountJournalEnhancedSettings.hiddenMounts,
            personalHiddenMounts = true,

            filter = MountJournalEnhancedSettings.filter,
            personalFilter = true,
        }

        MountJournalEnhancedSettings = nil
    end
end)