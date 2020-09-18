local _, ADDON = ...

if GetLocale() ~= 'frFR' then
    return
end

ADDON.isMetric = true -- is the metric or imperial/us unit system used?
local L = ADDON.L or {}

--@localization(locale="frFR", format="lua_additive_table", handle-unlocalized=comment)@
--@localization(locale="frFR", namespace="Settings", format="lua_additive_table", handle-unlocalized=comment)@
--@localization(locale="frFR", namespace="Families", format="lua_additive_table", handle-unlocalized=comment)@
