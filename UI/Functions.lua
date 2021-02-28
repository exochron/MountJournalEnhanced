local ADDON_NAME, ADDON = ...

ADDON.UI = {}

--region frame point handling

local SAVE_KEY_POINTS = 'MJE_SavedPoints'

---SavePoint
---@param frame table
---@param savePoint string|nil TOP|BOTTOM|.. or nil. nil saves all current points
function ADDON.UI:SavePoint(frame, savePoint)

    if not frame[SAVE_KEY_POINTS] or not savePoint then
        frame[SAVE_KEY_POINTS] = {}
    end

    for i = 1, frame:GetNumPoints() do
        local point, relativeTo, relativePoint, xOfs, yOfs = frame:GetPoint(i)
        if point == savePoint then
            frame[SAVE_KEY_POINTS][point] = { point, relativeTo, relativePoint, xOfs, yOfs }
            break
        end
        if not savePoint then
            frame[SAVE_KEY_POINTS][point] = { point, relativeTo, relativePoint, xOfs, yOfs }
        end
    end
end

---RestorePoint
---@param frame table
---@param savePoint string|nil TOP|BOTTOM|.. or nil. nil resores all saved points
function ADDON.UI:RestorePoint(frame, savePoint)
    if savePoint and frame[SAVE_KEY_POINTS] and frame[SAVE_KEY_POINTS][savePoint] then
        frame:SetPoint(unpack(frame[SAVE_KEY_POINTS][savePoint]))
    elseif not savePoint and frame[SAVE_KEY_POINTS] then
        frame:ClearAllPoints()
        for _, v in pairs(frame[SAVE_KEY_POINTS]) do
            frame:SetPoint(unpack(v))
        end
    end
end

--endregion

--region frame size handling

local SAVE_KEY_SIZE = 'MJE_SavedSize'

function ADDON.UI:SaveSize(frame)
    local w, h = frame:GetSize()
    frame[SAVE_KEY_SIZE] = { w, h }
end

function ADDON.UI:RestoreSize(frame)
    if frame[SAVE_KEY_SIZE] then
        frame:SetSize(frame[SAVE_KEY_SIZE][1], frame[SAVE_KEY_SIZE][2])
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
    if frame.StripTextures then
        local mt = getmetatable(frame).__index
        local org_Strip = mt.StripTextures
        mt.StripTextures = function(self, ...)
            if _G['MountJournal'] then
                for _, callback in pairs(callbacks) do
                    callback(self)
                end
            end
            return org_Strip(self, ...)
        end
    end
end
ADDON.Events:RegisterCallback("OnLogin", hookStripTextures, "ElvUI hooks")

--endregion