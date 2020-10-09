local _, ADDON = ...

if GetLocale() ~= "deDE" then
    return
end

ADDON.isMetric = true -- is the metric or imperial/us unit system used?
local L = ADDON.L or {}

--@localization(locale="deDE", format="lua_additive_table", handle-unlocalized=comment)@
--@localization(locale="deDE", namespace="Settings", format="lua_additive_table", handle-unlocalized=comment)@
--@localization(locale="deDE", namespace="Families", format="lua_additive_table", handle-unlocalized=comment)@