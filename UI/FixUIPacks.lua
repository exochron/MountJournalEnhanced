local ADDON_NAME, ADDON = ...

local callbacks = {}
function ADDON:RegisterUIOverhaulCallback(func)
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
