local MODULE_NAME, MODULE_VERSION = "Listener", "1.0";

local module = CoreFramework:NewModule(MODULE_NAME, MODULE_VERSION);
if (not module) then return; end

local private = { };

module.AddUpdateHandler = function(self, ...) private:AddUpdateHandler(...); end;
module.RemoveUpdateHandler = function(self, ...) private:RemoveUpdateHandler(...); end;
module.AddEventHandler = function(self, ...) private:AddEventHandler(...); end;
module.RemoveEventHandler = function(self, ...) private:RemoveEventHandler(...); end;

function private:Initialize()
    self.frame = CreateFrame("frame");
    self.frame:SetScript("OnUpdate", function(sender, ...) self:OnUpdate(...); end);
    self.frame:SetScript("OnEvent", function(sender, ...) self:OnEvent(...); end);
end

private.updateListeners = { };
private.updateListenersWidthId = { };

function private:AddUpdateHandler(handler, id)
    if (type(handler) ~= "function") then
        error(string.format("Update handler required."));
    end

    if (type(id) ~= "nil" and (type(id) ~= "string" or string.len(id) == 0)) then
        error(string.format("Invalide update handler id."));
    end
    
    if (id == nil) then
        table.insert(self.updateListeners, { handler = handler });
    else
        self.updateListenersWidthId[id] = { handler = handler };
    end
end

function private:RemoveUpdateHandler(id)
    if (type(id) ~= "nil" and (type(id) ~= "string" or string.len(id) == 0)) then
        error(string.format("Invalide update handler id."));
    end

    self.updateListenersWidthId[id] = nil;
end

function private:OnUpdate(...)
    for _, listener in pairs(self.updateListeners) do
        listener.handler(...);
    end
    
    for _, listener in pairs(self.updateListenersWidthId) do
        listener.handler(...);
    end
end

private.eventListeners = { };
private.eventListenersWidthId = { };

function private:AddEventHandler(event, handler, id)
    if (type(event) ~= "string" or string.len(event) == 0) then
        error(string.format("Event name required."));
    end

    if (type(handler) ~= "function") then
        error(string.format("Event handler required."));
    end

    if (type(id) ~= "nil" and (type(id) ~= "string" or string.len(id) == 0)) then
        error(string.format("Invalide event handler id."));
    end
    
    if (id == nil) then
        table.insert(self.eventListeners, { event = event, handler = handler });
    else
        self.eventListenersWidthId[id] = { event = event, handler = handler };
    end
    
    self.frame:RegisterEvent(event);
end

function private:RemoveEventHandler(id)
    if (type(id) ~= "nil" and (type(id) ~= "string" or string.len(id) == 0)) then
        error(string.format("Invalide event handler id."));
    end

    self.eventListenersWidthId[id] = nil;
end

function private:OnEvent(event, ...)
    for _, listener in pairs(self.eventListeners) do
        if (listener.event == nil or listener.event == event) then
            listener.handler(event, ...);
        end
    end
    
    for _, listener in pairs(self.eventListenersWidthId) do
        if (listener.event == nil or listener.event == event) then
            listener.handler(event, ...);
        end
    end
end

private:Initialize();
