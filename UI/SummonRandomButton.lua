local _, ADDON = ...

ADDON.Events:RegisterCallback("OnLogin", function()
    local MACRO_NAME = "MJE: Random Mount"
    local MACRO_BODY = "/run C_MountJournal.SummonByID(0)"
    local MACRO_ICON = "ability_hunter_beastcall"

    if not InCombatLockdown() then
        local existingName, _, existingBody = GetMacroInfo(MACRO_NAME)
        if not existingName and GetNumMacros() < 120 then
            CreateMacro(MACRO_NAME, MACRO_ICON, MACRO_BODY)
        elseif existingName and existingBody ~= MACRO_BODY then
            EditMacro(existingName, nil, nil, MACRO_BODY)
        end
    end
end, "random-macro")

ADDON.Events:RegisterCallback("loadUI", function()
    if not MountJournal.SummonRandomFavoriteButton then
        local button = CreateFrame("Button", nil, MountJournal, "MJE_SummonRandomFavoriteButton")
        button.texture:SetTexture("interface/icons/ability_hunter_beastcall")
        button.spellname:SetText(MOUNT_JOURNAL_SUMMON_RANDOM_FAVORITE_MOUNT)
        button:RegisterForDrag("LeftButton")
    end
end, "summon random mount button")