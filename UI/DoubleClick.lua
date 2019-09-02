local ADDON_NAME, ADDON = ...

local function MountListItem_OnDoubleClick(sender, button)
    if (button == "LeftButton") then
        local _, _, _, _, _, _, _, _, _, _, _, mountID = C_MountJournal.GetDisplayedMountInfo(sender.index)
        C_MountJournal.SummonByID(mountID)
    end
end

ADDON:RegisterLoadUICallback(function()
    local buttons = MountJournal.ListScrollFrame.buttons
    for buttonIndex = 1, #buttons do
        local button = buttons[buttonIndex]
        button:HookScript("OnDoubleClick", MountListItem_OnDoubleClick)
    end
end)