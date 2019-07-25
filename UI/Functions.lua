local ADDON_NAME, ADDON = ...

ADDON.UI = {}

--region frame point handling

local SAVE_KEY = 'MJE_SavedPoints'

---SavePoint
---@param frame table
---@param savePoint string|nil TOP|BOTTOM|.. or nil. nil saves all current points
function ADDON.UI:SavePoint(frame, savePoint)

    if (not frame[SAVE_KEY] or not savePoint) then
        frame[SAVE_KEY] = {}
    end

    for i = 1, frame:GetNumPoints() do
        local point, relativeTo, relativePoint, xOfs, yOfs = frame:GetPoint(i)
        if (point == savePoint or not savePoint) then
            frame[SAVE_KEY][point] = {point, relativeTo, relativePoint, xOfs, yOfs}
            break
        end
    end
end

---RestorePoint
---@param frame table
---@param savePoint string|nil TOP|BOTTOM|.. or nil. nil resores all saved points
function ADDON.UI:RestorePoint(frame, savePoint)
    if (savePoint and frame[SAVE_KEY] and frame[SAVE_KEY][savePoint]) then
        frame:SetPoint(unpack(frame[SAVE_KEY][savePoint]))
    elseif not savePoint and frame[SAVE_KEY] then
        frame:ClearAllPoints()
        for _, v in pairs(frame[SAVE_KEY]) do
            frame:SetPoint(unpack(v))
        end
    end
end

--endregion

--region ElvUI hooks

local callbacks = {}
function ADDON.UI:RegisterUIOverhaulCallback(func)
    table.insert(callbacks, func)
end

local function hookStripTextures()
    local frame = CreateFrame('Frame')
    if (frame.StripTextures) then
        local mt = getmetatable(frame).__index
        local org_Strip = mt.StripTextures
        mt.StripTextures = function(self, a, b, c, d, e, f, g, h, i)
            if (_G['MountJournal']) then
                for _, callback in pairs(callbacks) do
                    callback(self)
                end
            end
            return org_Strip(self, a, b, c, d, e, f, g, h, i)
        end
    end
end
ADDON:RegisterLoginCallback(hookStripTextures)

--endregion