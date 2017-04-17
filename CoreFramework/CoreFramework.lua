if (CoreFramework) then return; end
CoreFramework = { };

local private = { };

CoreFramework.NewModule = function(self, ...) return private:NewModule(...); end;
CoreFramework.GetModule = function(self, ...) return private:GetModule(...); end;
CoreFramework.HasModule = function(self, ...) return private:HasModule(...); end;

private.modules = { };

function private:NewModule(name, version, initialState)
    self:CheckArguments(name, version);

    local module = initialState or { };

    module.moduleInfo = {
        Name = name,
        Version = version,
    };

    if (not self.modules[name]) then
        self.modules[name] = { };
    end

    if (self.modules[name][version]) then
        return nil;
    end

    self.modules[name][version] = module;
    return module;
end

function private:GetModule(name, version)
    self:CheckArguments(name, version);

    if (not self.modules or not self.modules[name] or not self.modules[name][version]) then
        error(string.format("Module %q version %s not found.", name, version));
    end

    return self.modules[name][version];
end

function private:HasModule(name, version)
    self:CheckArguments(name, version);

    return (self.modules and self.modules[name] and self.modules[name][version]);
end

function private:CheckArguments(name, version)
    if (type(name) ~= "string" or string.len(name) == 0) then
        error("Module name required.");
    end

    if (type(version) ~= "string" or string.len(version) == 0) then
        error("Module version required.");
    end
end
