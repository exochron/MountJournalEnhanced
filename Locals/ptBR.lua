local _, ADDON = ...

if GetLocale() ~= 'ptBR' then
    return
end

ADDON.isMetric = true -- is the metric or imperial/us unit system used?
local L = ADDON.L or {}

--@localization(locale="ptBR", format="lua_additive_table", handle-unlocalized=comment)@
--@localization(locale="ptBR", namespace="Settings", format="lua_additive_table", handle-unlocalized=comment)@
--@localization(locale="ptBR", namespace="Families", format="lua_additive_table", handle-unlocalized=comment)@
