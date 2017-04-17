local MODULE_NAME, MODULE_VERSION = "UserInterface", "1.0";

local module = CoreFramework:NewModule(MODULE_NAME, MODULE_VERSION);
if (not module) then return; end

local private = { };

module.StartFlashing = function(self, ...) private:StartFlashing(...); end;
module.StopFlashing = function(self, ...) private:StopFlashing(...); end;
module.IsFlashing = function(self, ...) return private:IsFlashing(...); end;

local Listener = CoreFramework:GetModule("Listener", MODULE_VERSION);

private.flashingFrames = { };
private.flashingTimers = { };
private.flashingTimersReferenceCount = { };

-- UIFrameFlash
function private:StartFlashing(frame, fadeInTime, fadeOutTime, flashDuration, showWhenDone, flashInHoldTime, flashOutHoldTime, syncId)
    if (not frame) then
        return;
    end

    local index = 1;
    while (self.flashingFrames[index]) do
        if (self.flashingFrames[index] == frame) then
            return;
        end
        index = index + 1;
    end

    if (syncId) then
        frame.syncId = syncId;
        if (self.flashingTimers[syncId] == nil) then
            self.flashingTimers[syncId] = 0;
            self.flashingTimersReferenceCount[syncId] = 0;
        end
        self.flashingTimersReferenceCount[syncId] = self.flashingTimersReferenceCount[syncId] + 1;
    else
        frame.syncId = nil;
    end

    frame.fadeInTime = fadeInTime;
    frame.fadeOutTime = fadeOutTime;
    frame.flashDuration = flashDuration;
    frame.showWhenDone = showWhenDone;
    frame.flashTimer = 0;
    frame.flashInHoldTime = flashInHoldTime;
    frame.flashOutHoldTime = flashOutHoldTime;

    tinsert(self.flashingFrames, frame);

    Listener:AddUpdateHandler(function(...) self:FlashingUpdate(...); end, "FlashingUpdate");
end

-- UIFrameFlashStop
function private:StopFlashing(frame)
    tDeleteItem(self.flashingFrames, frame);

    frame:SetAlpha(1.0);
    frame.flashTimer = nil;

    if (frame.syncId) then
        self.flashingTimersReferenceCount[frame.syncId] = self.flashingTimersReferenceCount[frame.syncId] - 1;
        if (self.flashingTimersReferenceCount[frame.syncId] == 0) then
            self.flashingTimers[frame.syncId] = nil;
            self.flashingTimersReferenceCount[frame.syncId] = nil;
        end
        frame.syncId = nil;
    end

    if (frame.showWhenDone) then
        frame:Show();
    else
        frame:Hide();
    end
end

-- UIFrameIsFlashing
function private:IsFlashing(frame)
    for index, value in pairs(self.flashingFrames) do
        if (value == frame) then
            return 1;
        end
    end

    return nil;
end

-- UIFrameFlash_OnUpdate
function private:FlashingUpdate(elapsed)
    local frame;
    local index = #self.flashingFrames;

    for syncId, timer in pairs(self.flashingTimers) do
        self.flashingTimers[syncId] = timer + elapsed;
    end

    while (self.flashingFrames[index]) do
        frame = self.flashingFrames[index];
        frame.flashTimer = frame.flashTimer + elapsed;

        if ((frame.flashTimer > frame.flashDuration) and frame.flashDuration ~= -1) then
            self:StopFlashing(frame);
        else
            local flashTime = frame.flashTimer;
            local alpha;

            if (frame.syncId) then
                flashTime = self.flashingTimers[frame.syncId];
            end

            flashTime = flashTime % (frame.fadeInTime + frame.fadeOutTime + (frame.flashInHoldTime or 0) + (frame.flashOutHoldTime or 0));
            if (flashTime < frame.fadeInTime) then
                alpha = flashTime/frame.fadeInTime;
            elseif (flashTime < frame.fadeInTime+(frame.flashInHoldTime or 0)) then
                alpha = 1;
            elseif (flashTime < frame.fadeInTime+(frame.flashInHoldTime or 0) + frame.fadeOutTime) then
                alpha = 1 - ((flashTime - frame.fadeInTime - (frame.flashInHoldTime or 0)) / frame.fadeOutTime);
            else
                alpha = 0;
            end

            frame:SetAlpha(alpha);
            frame:Show();
        end

        index = index - 1;
    end

    if (#self.flashingFrames == 0) then
        Listener:RemoveUpdateHandler("FlashingUpdate");
    end
end