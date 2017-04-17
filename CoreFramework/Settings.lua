local MODULE_NAME, MODULE_VERSION = "Settings", "1.0";

local module = CoreFramework:NewModule(MODULE_NAME, MODULE_VERSION);
if (not module) then return; end

local private = { };

module.GetSettings = function(self, ...) return private:GetSettings(...); end;
module.SetSettings = function(self, ...) return private:SetSettings(...); end;

function private:GetSettings(variableName, defaultSettings)
    if (type(variableName) ~= "string" or string.len(variableName) == 0) then
        error(string.format("Variable name required."));
    end

    if (type(defaultSettings) ~= "nil" and type(defaultSettings) ~= "table") then
        error(string.format("Invalide default settings."));
    end

    local settings = _G[variableName] or { };

    if (defaultSettings) then
        self:CombineSettings(settings, defaultSettings);
    end

    _G[variableName] = settings;

    return settings;
end

function private:SetSettings(variableName, settings)
    if (type(variableName) ~= "string" or string.len(variableName) == 0) then
        error(string.format("Variable name required."));
    end

    if (type(settings) ~= "table") then
        error(string.format("Invalide settings."));
    end

    _G[variableName] = settings;
end

function private:CombineSettings(settings, defaultSettings)
    for key, value in pairs(defaultSettings) do
        if (settings[key] == nil) then
            settings[key] = value;
        elseif (type(settings[key]) == "table" and type(value) == "table") then
            self:CombineSettings(settings[key], value);
        end
    end
end
