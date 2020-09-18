local _, ADDON = ...

if GetLocale() ~= 'koKR' then
    return
end

ADDON.isMetric = true -- is the metric or imperial/us unit system used?
local L = ADDON.L or {}

--@localization(locale="koKR", format="lua_additive_table", handle-unlocalized=comment)@
--@localization(locale="koKR", namespace="Settings", format="lua_additive_table", handle-unlocalized=comment)@
--@localization(locale="koKR", namespace="Families", format="lua_additive_table", handle-unlocalized=comment)@
