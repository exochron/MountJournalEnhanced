local _, ADDON = ...

SLASH_MOUNTJOURNALENHANCED1, SLASH_MOUNTJOURNALENHANCED2 = '/mountjournalenhanced', '/mje'

local function printHelp()
    print("Syntax:")
    print("/mje options       Opens addon options")
    print("/mje reset size    Resets journal frame size to default")
    print("/mje set date [Mount Name] YYYY-MM-DD You can set the collection date of an already collected mount. This only works for mounts which don't have a date set yet. This means: you can set the date ONLY ONCE.")
end

function SlashCmdList.MOUNTJOURNALENHANCED(input)
    local loweredInput = input:lower():trim()

    if loweredInput == "debug on" then
        ADDON.settings.ui.debugMode = true
        print("MountJournalEnhanced: debug mode activated.")
    elseif loweredInput == "debug off" then
        ADDON.settings.ui.debugMode = false
        print("MountJournalEnhanced: debug mode deactivated.")
    elseif ADDON.TakeScreenshots and loweredInput == "screenshot" then
        ADDON:TakeScreenshots()
    elseif loweredInput == "reset size" then
        ADDON.UI:RestoreWindowSize()
    elseif loweredInput == "options" then
        ADDON:OpenOptions()
    else
        local setMount, setYear, setMonth, setDay = string.match(input, "set date (.+) (%d%d%d%d)-(%d%d)-(%d%d)")
        if setMount then
            local spellId = string.match(input, "mount:(%d+):")
            if not spellId then
                _, _, _, _, _, _, spellId = GetSpellInfo(setMount)
            end
            if spellId then
                local mountId = C_MountJournal.GetMountFromSpell(spellId)
                if mountId then
                    ADDON:SetLearnedDate(mountId, setYear + 0, setMonth + 0, setDay + 0)
                    return
                end
            end
        end

        printHelp()
    end
end