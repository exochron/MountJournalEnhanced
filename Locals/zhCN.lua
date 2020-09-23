local ADDON_NAME, ADDON = ...

if GetLocale() ~= 'zhCN' then
    return
end

ADDON.isMetric = true -- is the metric or imperial/us unit system used?
local L = ADDON.L or {}

--@localization(locale="zhCN", format="lua_additive_table", handle-unlocalized=comment)@
--@localization(locale="zhCN", namespace="Settings", format="lua_additive_table", handle-unlocalized=comment)@
--@localization(locale="zhCN", namespace="Families", format="lua_additive_table", handle-unlocalized=comment)@