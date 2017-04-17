local MODULE_NAME, MODULE_VERSION = "CommandLine", "1.0";

local module = CoreFramework:NewModule(MODULE_NAME, MODULE_VERSION);
if (not module) then return; end

local private = { };

module.AddSlashCommand = function(self, ...) private:AddSlashCommand(...); end;

function private:AddSlashCommand(name, handler, ...)
    if (type(name) ~= "string" or string.len(name) == 0) then
        error("Command name required.");
    end

    if (type(handler) ~= "function") then
        error("Command handler required.");
    end

    SlashCmdList[name] = function(line) self:OnSlashCommand(handler, line); end;
    local command = '';
    for index = 1, select('#', ...) do
        command = select(index, ...);
        _G['SLASH_' .. name .. index] = '/' .. command;
    end
end

function private:OnSlashCommand(handler, line)
    local parsedLine = SecureCmdOptionParse(line);
    if (not parsedLine) then
        return;
    end

    local command, parameter1, parameter2 = parsedLine:match("^(%S*)%s*(%S*)%s*(%S*)%s*(%S*)$");
    handler(command, parameter1, parameter2);
end
