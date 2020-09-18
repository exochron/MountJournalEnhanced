local _, ADDON = ...

if GetLocale() ~= 'ruRU' then
    return
end

ADDON.isMetric = true -- is the metric or imperial/us unit system used?
local L = ADDON.L or {}

--@localization(locale="ruRU", format="lua_additive_table", handle-unlocalized=comment)@
--@localization(locale="ruRU", namespace="Settings", format="lua_additive_table", handle-unlocalized=comment)@
--@localization(locale="ruRU", namespace="Families", format="lua_additive_table", handle-unlocalized=comment)@