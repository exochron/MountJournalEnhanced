local MODULE_NAME, MODULE_VERSION = "Localization", "1.1";

local DEFAULT_LANGUAGE = "enUS";

local module = CoreFramework:NewModule(MODULE_NAME, MODULE_VERSION);
if (not module) then return; end

local private = { };

module.NewLocalization = function(self, ...) return private:NewLocalization(...); end;
module.GetLocalization = function(self, ...) return private:GetLocalization(...); end;

private.localizations = { };

function private:NewLocalization(addonName, language)
    if (type(addonName) ~= "string" or string.len(addonName) == 0) then
        error(string.format("Addon name required."));
    end

    if (type(language) ~= "string" or string.len(language) == 0) then
        error(string.format("Language required."));
    end

    if (not self.localizations[addonName]) then
        self.localizations[addonName] = { };
    end

    local localization = { };
    self.localizations[addonName][language] = localization;
    return localization;
end

function private:GetLocalization(addonName)
    if (type(addonName) ~= "string" or string.len(addonName) == 0) then
        error(string.format("Addon name required."));
    end

    if (not self.localizations[addonName]) then
        return { };
    end
    
    local language = GetLocale();
    local localization = self.localizations[addonName][language] or { };
    local defaultLocalization = self.localizations[addonName][DEFAULT_LANGUAGE] or { };
    
    local combindedLocalization = { };
    
    for key, value in pairs(defaultLocalization) do
        combindedLocalization[key] = value;
    end
    
    for key, value in pairs(localization) do
        combindedLocalization[key] = value;
    end
    
    return combindedLocalization;
end
