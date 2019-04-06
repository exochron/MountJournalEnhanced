local ADDON_NAME, ADDON = ...
local MOUNT_COUNT_STATISTIC = 339

local doStrip = false

local function CreateCharacterMountCount()
    local frame = CreateFrame("frame", nil, MountJournal, "InsetFrameTemplate3")

    frame:ClearAllPoints()
    frame:SetPoint("TOPLEFT", MountJournal, 70, -42)
    frame:SetSize(130, 18)
    if (doStrip) then
        frame:StripTextures()
    end

    frame.staticText = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    frame.staticText:ClearAllPoints()
    frame.staticText:SetPoint("LEFT", frame, 10, 0)
    frame.staticText:SetText(CHARACTER)

    frame.uniqueCount = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    frame.uniqueCount:ClearAllPoints()
    frame.uniqueCount:SetPoint("RIGHT", frame, -10, 0)
    --frame.uniqueCount:SetText(GetNumCompanions("MOUNT"))
    local _, _, _, mountCount = GetAchievementCriteriaInfo(MOUNT_COUNT_STATISTIC, 1)
    frame.uniqueCount:SetText(mountCount)

    MountJournal.MountCount:SetPoint("TopLeft", 70, -22)
    MountJournal.MountCount:SetSize(130, 18)

    frame:RegisterEvent("COMPANION_LEARNED")
    frame:RegisterEvent("ACHIEVEMENT_EARNED")
    frame:SetScript("OnEvent", function(self, event, ...)
        ADDON:UpdateIndexMap()
        frame.uniqueCount:SetText(GetNumCompanions("MOUNT"))
    end)
end

ADDON:RegisterLoadUICallback(CreateCharacterMountCount)

ADDON:RegisterUIOverhaulCallback(function(self)
    if (self == MountJournal.MountCount) then
        doStrip = true
    end
end)