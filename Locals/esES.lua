local _, ADDON = ...

if GetLocale() ~= 'esES' then
    return
end

ADDON.isMetric = true -- is the metric or imperial/us unit system used?
local L = ADDON.L or {}

--@localization(locale="esES", format="lua_additive_table", handle-unlocalized=comment)@
--@localization(locale="esES", namespace="Settings", format="lua_additive_table", handle-unlocalized=comment)@
--@localization(locale="esES", namespace="Families", format="lua_additive_table", handle-unlocalized=comment)@
