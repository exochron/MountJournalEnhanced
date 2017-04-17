local MODULE_NAME, MODULE_VERSION = "Addon", "1.0";

local module = CoreFramework:NewModule(MODULE_NAME, MODULE_VERSION);
if (not module) then return; end

local private = { };

module.NewAddon = function(self, ...) return private:NewAddon(...); end;

local Listener = CoreFramework:GetModule("Listener", MODULE_VERSION);
local CommandLine = CoreFramework:GetModule("CommandLine", MODULE_VERSION);
local Settings = CoreFramework:GetModule("Settings", MODULE_VERSION);

function private:NewAddon(addonName, initialState, dependencies)
    if (type(addonName) ~= "string" or string.len(addonName) == 0) then
        error(string.format("Addon name required."));
    end

    if (type(initialState) ~= "nil" and type(initialState) ~= "table") then
        error(string.format("Invalide argument for initial state."));
    end

    if (type(dependencies) ~= "nil" and type(dependencies) ~= "table") then
        error(string.format("Invalide argument for dependencies."));
    end
    if (dependencies) then
        for _, dependency in pairs(dependencies) do
            if (type(dependency) ~= "function") then
                error(string.format("Invalide argument for dependencies."));
            end
        end
    end

    local addon = initialState or { };
    addon.addonInfo = { name = addonName, };
    addon.loaded = false;

    Listener:AddUpdateHandler(function()
        if (type(addon.Update) == "function") then
            addon:Update();
        end
    end);
    Listener:AddEventHandler("PLAYER_ENTERING_WORLD", function()
        if (addon.loaded) then
            return;
        end

        if (not self:CheckDependencies(dependencies)) then
            return;
        end

        addon.settings = Settings:GetSettings(addonName .. "Settings", addon.settings);

        if (type(addon.Load) == "function") then
            addon:Load();
        end

        addon.loaded = true;
    end);
    Listener:AddEventHandler("PLAYER_LEAVING_WORLD", function()
        if (type(addon.Unload) == "function") then
            addon:Unload();
        end
    end);

    addon.AddEventHandler = function(this, event, handler)
        Listener:AddEventHandler(event, handler);
    end;

    addon.AddSlashCommand = function(this, name, handler, ...)
        CommandLine:AddSlashCommand(name, handler, ...);
    end;

    return addon;
end

function private:CheckDependencies(dependencies)
    if (not dependencies) then
        return true;
    end

    for _, dependency in pairs(dependencies) do
        if (not dependency()) then
            return false;
        end
    end

    return true;
end