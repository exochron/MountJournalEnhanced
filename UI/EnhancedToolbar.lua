local _, ADDON = ...

local buttonList, enabledGroup = {}, {}

local function renderToolbar()
    local lastButton
    local hasElements = false

    if MountJournal.SummonRandomFavoriteButton then
        lastButton = MountJournal.SummonRandomFavoriteButton
    end

    local names = GetKeysArray(buttonList)
    table.sort(names)

    for _, name in ipairs(names) do
        local group = buttonList[name]
        if #group > 0 and enabledGroup[name] then

            group[#group]:ClearAllPoints()

            if lastButton then
                group[#group]:SetPoint("RIGHT", lastButton, "LEFT", -20, 0)
            else
                group[#group]:SetPoint("CENTER", MountJournal, "TOPRIGHT", -24, -42)
            end

            for i = #group-1, 1, -1 do
                group[i]:ClearAllPoints()
                group[i]:SetPoint("RIGHT", group[i+1], "LEFT", -6, 0)
            end

            lastButton = group[1]
            hasElements = true
        end
    end

    if MountJournal.SummonRandomFavoriteButton then
        MountJournal.SummonRandomFavoriteButton.spellname:SetShown(not hasElements)
    end
end

function ADDON.UI:RegisterToolbarGroup(name, ...)
    local group = { ... }

    if #group > 0 then
        buttonList[name] = group
        enabledGroup[name] = true

        if ADDON.initialized then
            renderToolbar()
        end

        return function(enabled)
            enabledGroup[name] = enabled
            if ADDON.initialized then
                renderToolbar()
            end
        end
    end
end

ADDON.Events:RegisterCallback("loadUI", renderToolbar, 'toolbar' )