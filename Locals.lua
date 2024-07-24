local _, ADDON = ...

local locale = GetLocale()

ADDON.isMetric = (locale ~= "enUS") -- is the metric or imperial unit system used?
ADDON.L = {}
local L = ADDON.L

L["AUTO_ROTATE"] = "Rotate automatically"
L["Black Market"] = "Black Market"
L["COMPARTMENT_TOOLTIP"] = "|cffeda55fLeft-Click|r to toggle showing the mount collection.\n|cffeda55fRight-Click|r to open addon options."
L["DRESSUP_LABEL"] = "Journal"
L["FAVOR_AUTO"] = "Auto-favor new mounts"
L["FAVOR_DISPLAYED"] = "All Displayed"
L["FAVOR_PER_CHARACTER"] = "Per Character"
L["FILTER_ONLY_LATEST"] = "Only latest additions"
L["FILTER_SECRET"] = "Hidden by the game"
L["Family"] = "Family"
L["Hidden"] = "Hidden"
L["Only tradable"] = "Only tradable"
L["Only usable"] = "Only usable"
L["Passenger"] = "Passenger"
L["ROTATE_DOWN"] = "Rotate Down"
L["ROTATE_UP"] = "Rotate Up"
L["Reset filters"] = "Reset filters"
L["SORT_BY_FAMILY"] = STABLE_SORT_TYPE_LABEL or "Family"
L["SORT_BY_LAST_USAGE"] = "Last usage"
L["SORT_BY_LEARNED_DATE"] = "Date of receipt"
L["SORT_BY_TRAVEL_DISTANCE"] = "Travelled distance"
L["SORT_BY_TRAVEL_DURATION"] = "Travelled duration"
L["SORT_BY_USAGE_COUNT"] = "Count of usage"
L["SORT_FAVORITES_FIRST"] = "Favorites First"
L["SORT_REVERSE"] = "Reverse Sort"
L["SORT_UNOWNED_BOTTOM"] = "Unowned at Bottom"
L["SORT_UNUSABLE_BOTTOM"] = "Unusable after Usable"
L["SPECIAL_TIP"] = "Starts the special animation of your mount in game."
L["STATS_TIP_CUSTOMIZATION_COUNT_HEAD"] = "Count of collected customization options"
L["STATS_TIP_LEARNED_DATE_HEAD"] = "Possession date"
L["STATS_TIP_RARITY_HEAD"] = RARITY
L["STATS_TIP_RARITY_DESCRIPTION"] = "% of characters who own this mount"
L["STATS_TIP_TRAVEL_DISTANCE_HEAD"] = "Travel distance"
L["STATS_TIP_TRAVEL_TIME_HEAD"] = "Travel time"
L["STATS_TIP_TRAVEL_TIME_TEXT"] = "in hours:minutes:seconds"
L["STATS_TIP_USAGE_COUNT_HEAD"] = "Usage count"
L["TASK_END"] = "[MJE] Phew! I'm done."
L["TASK_FAVOR_START"] = "[MJE] Reapplying stars all over your mounts. Please wait a few seconds until I'm finished."
L["TOGGLE_COLOR"] = "Show next color variation"
L["Transform"] = "Transform"
L["ANIMATION_STAND"] = "Stand"
L["ANIMATION_WALK"] = "Walk"
L["ANIMATION_WALK_BACK"] = "Walk Backwards"
L["ANIMATION_RUN"] = "Run"
L["ANIMATION_FLY"] = "Fly"
L["ANIMATION_FLY_IDLE"] = "Fly Idle"
L["FILTER_ONLY"] = "only"
L["TRAITS_SPEND_ALL"] = "Spend all"

-- Families
L["Airplanes"] = "Airplanes"
L["Airships"] = "Airships"
L["Alpacas"] = "Alpacas"
L["Amphibian"] = "Amphibian"
L["Animite"] = "Animite"
L["Aqir Flyers"] = "Aqir Flyers"
L["Arachnids"] = "Arachnids"
L["Armoredon"] = "Armoredon"
L["Assault Wagons"] = "Assault Wagons"
L["Basilisks"] = "Basilisks"
L["Bats"] = "Bats"
L["Bears"] = "Bears"
L["Bees"] = "Bees"
L["Beetle"] = "Beetle"
L["Birds"] = "Birds"
L["Bipedal Cat"] = "Bipedal Cat"
L["Blood Ticks"] = "Blood Ticks"
L["Boars"] = "Boars"
L["Book"] = "Book"
L["Bovids"] = "Bovids"
L["Broom"] = "Broom"
L["Brutosaurs"] = "Brutosaurs"
L["Camels"] = "Camels"
L["Carnivorans"] = "Carnivorans"
L["Carpets"] = "Carpets"
L["Cats"] = "Cats"
L["Cervid"] = "Cervid"
L["Chargers"] = "Chargers"
L["Chickens"] = "Chickens"
L["Clefthooves"] = "Clefthooves"
L["Cloud Serpents"] = "Cloud Serpents"
L["Core Hounds"] = "Core Hounds"
L["Crabs"] = "Crabs"
L["Cranes"] = "Cranes"
L["Crawgs"] = "Crawgs"
L["Crocolisks"] = "Crocolisks"
L["Crows"] = "Crows"
L["Demonic Hounds"] = "Demonic Hounds"
L["Demonic Steeds"] = "Demonic Steeds"
L["Demons"] = "Demons"
L["Devourer"] = "Devourer"
L["Dinosaurs"] = "Dinosaurs"
L["Dire Wolves"] = "Dire Wolves"
L["Direhorns"] = "Direhorns"
L["Discs"] = "Discs"
L["Dragonhawks"] = "Dragonhawks"
L["Drakes"] = "Drakes"
L["Dread Ravens"] = "Dread Ravens"
L["Dreamsaber"] = "Dreamsaber"
L["Elekks"] = "Elekks"
L["Elementals"] = "Elementals"
L["Falcosaurs"] = "Falcosaurs"
L["Fathom Rays"] = "Fathom Rays"
L["Feathermanes"] = "Feathermanes"
L["Felsabers"] = "Felsabers"
L["Fish"] = "Fish"
L["Flies"] = "Flies"
L["Flying Steeds"] = "Flying Steeds"
L["Foxes"] = "Foxes"
L["Gargon"] = "Gargon"
L["Gargoyle"] = "Gargoyle"
L["Goats"] = "Goats"
L["Gorger"] = "Gorger"
L["Gorm"] = "Gorm"
L["Grand Drakes"] = "Grand Drakes"
L["Gronnlings"] = "Gronnlings"
L["Gryphons"] = "Gryphons"
L["Gyrocopters"] = "Gyrocopters"
L["Hands"] = "Hands"
L["Hawkstriders"] = "Hawkstriders"
L["Hippogryphs"] = "Hippogryphs"
L["Horned Steeds"] = "Horned Steeds"
L["Horses"] = "Horses"
L["Hounds"] = "Hounds"
L["Hovercraft"] = "Hovercraft"
L["Hover Board"] = "Hover Board"
L["Humanoids"] = "Humanoids"
L["Hyenas"] = "Hyenas"
L["Infernals"] = "Infernals"
L["Insects"] = "Insects"
L["Jellyfish"] = "Jellyfish"
L["Jet Aerial Units"] = "Jet Aerial Units"
L["Kites"] = "Kites"
L["Kodos"] = "Kodos"
L["Krolusks"] = "Krolusks"
L["Larion"] = "Larion"
L["Lions"] = "Lions"
L["Lupine"] = "Lupine"
L["Mammoths"] = "Mammoths"
L["Mana Rays"] = "Mana Rays"
L["Manasabers"] = "Manasabers"
L["Mauler"] = "Mauler"
L["Mechanical Animals"] = "Mechanical Animals"
L["Mechanical Birds"] = "Mechanical Birds"
L["Mechanical Cats"] = "Mechanical Cats"
L["Mechanical Steeds"] = "Mechanical Steeds"
L["Mechanostriders"] = "Mechanostriders"
L["Mecha-suits"] = "Mecha-suits"
L["Moose"] = "Moose"
L["Moth"] = "Moth"
L["Motorcycles"] = "Motorcycles"
L["Mountain Horses"] = "Mountain Horses"
L["Murloc"] = "Murloc"
L["Mushan"] = "Mushan"
L["Nether Drakes"] = "Nether Drakes"
L["Nether Rays"] = "Nether Rays"
L["N'Zoth Serpents"] = "N'Zoth Serpents"
L["Others"] = "Others"
L["Owl"] = "Owl"
L["Owlbear"] = "Owlbear"
L["Ox"] = "Ox"
L["Pandaren Phoenixes"] = "Pandaren Phoenixes"
L["Parrots"] = "Parrots"
L["Peafowl"] = "Peafowl"
L["Phoenixes"] = "Phoenixes"
L["Proto-Drakes"] = "Proto-Drakes"
L["Pterrordaxes"] = "Pterrordaxes"
L["Quilen"] = "Quilen"
L["Rams"] = "Rams"
L["Raptora"] = "Raptora"
L["Raptors"] = "Raptors"
L["Rats"] = "Rats"
L["Ravagers"] = "Ravagers"
L["Rays"] = "Rays"
L["Razorwing"] = "Razorwing"
L["Reptiles"] = "Reptiles"
L["Rhinos"] = "Rhinos"
L["Riverbeasts"] = "Riverbeasts"
L["Roc"] = "Roc"
L["Rockets"] = "Rockets"
L["Ruinstriders"] = "Ruinstriders"
L["Rylaks"] = "Rylaks"
L["Sabers"] = "Sabers"
L["Scorpions"] = "Scorpions"
L["Sea Serpents"] = "Sea Serpents"
L["Seahorses"] = "Seahorses"
L["Seat"] = "Seat"
L["Silithids"] = "Silithids"
L["Snail"] = "Snail"
L["Snapdragons"] = "Snapdragons"
L["Spider Tanks"] = "Spider Tanks"
L["Spiders"] = "Spiders"
L["Sporebat"] = "Sporebat"
L["Stag"] = "Stag"
L["Steeds"] = "Steeds"
L["Stingrays"] = "Stingrays"
L["Stone Cats"] = "Stone Cats"
L["Stone Drakes"] = "Stone Drakes"
L["Talbuks"] = "Talbuks"
L["Tallstriders"] = "Tallstriders"
L["Talonbirds"] = "Talonbirds"
L["Tauralus"] = "Tauralus"
L["Thunder Lizard"] = "Thunder Lizard"
L["Tigers"] = "Tigers"
L["Toads"] = "Toads"
L["Turtles"] = "Turtles"
L["Undead Drakes"] = "Undead Drakes"
L["Undead Steeds"] = "Undead Steeds"
L["Undead Wolves"] = "Undead Wolves"
L["Ungulates"] = "Ungulates"
L["Ur'zul"] = "Ur'zul"
L["Vehicles"] = "Vehicles"
L["Vombata"] = "Vombata"
L["Vulpin"] = "Vulpin"
L["Vultures"] = "Vultures"
L["War Wolves"] = "War Wolves"
L["Wasp"] = "Wasp"
L["Water Striders"] = "Water Striders"
L["Wilderlings"] = "Wilderlings"
L["Wind Drakes"] = "Wind Drakes"
L["Wolfhawks"] = "Wolfhawks"
L["Wolves"] = "Wolves"
L["Wyverns"] = "Wyverns"
L["Yaks"] = "Yaks"
L["Yetis"] = "Yetis"

-- Settings
L["DISPLAY_ALL_SETTINGS"] = "Display all settings"
L["RESET_WINDOW_SIZE"] = "Reset journal size"
L["SETTING_ABOUT_AUTHOR"] = "Author"
L["SETTING_ACHIEVEMENT_POINTS"] = "Show achievement points"
L["SETTING_AUTO_FAVOR"] = "Automatically set new mounts as favorite"
L["SETTING_COLOR_NAMES"] = "Colorize names in list based on rarity"
L["SETTING_COMPACT_LIST"] = "Compact mount list"
L["SETTING_CURSOR_KEYS"] = "Enable Up&Down keys to browse mounts"
L["SETTING_DISPLAY_BACKGROUND"] = "Change background color in display"
L["SETTING_FAVORITE_PER_CHAR"] = "Favorite mounts per character"
L["SETTING_HEAD_ABOUT"] = "About"
L["SETTING_HEAD_BEHAVIOUR"] = "Behavior"
L["SETTING_MOUNT_COUNT"] = "Show personal mount count"
L["SETTING_MOUNTSPECIAL_BUTTON"] = "Show /mountspecial button"
L["SETTING_MOVE_EQUIPMENT_SLOT"] = "Move equipment slot"
L["SETTING_MOVE_EQUIPMENT_SLOT_OPTION_TOP"] = "within top bar"
L["SETTING_MOVE_EQUIPMENT_SLOT_OPTION_DISPLAY"] = "inside display"
L["SETTING_PERSONAL_FILTER"] = "Apply filters only to this character"
L["SETTING_PERSONAL_HIDDEN_MOUNTS"] = "Apply hidden mounts only to this character"
L["SETTING_PERSONAL_UI"] = "Apply Interface settings only to this character"
L["SETTING_PREVIEW_LINK"] = "Show Collection button in mount preview"
L["SETTING_SEARCH_MORE"] = "Search also in description text"
L["SETTING_SEARCH_NOTES"] = "Search also in own notes"
L["SETTING_SHOP_BUTTON"] = "Show shop button at untrained shop mounts"
L["SETTING_SHOW_RESIZE_EDGE"] = "Activate edge in bottom corner to resize window"
L["SETTING_SHOW_STATISTICS"] = "Show mount statistics in display"
L["SETTING_TRACK_USAGE"] = "Track mount usage behavior on all characters"
L["SETTING_YCAMERA"] = "Unlock Y rotation with mouse in display"

if locale == "deDE" then
    --@localization(locale="deDE", format="lua_additive_table", handle-unlocalized=comment)@
    --@localization(locale="deDE", namespace="Settings", format="lua_additive_table", handle-unlocalized=comment)@
    --@localization(locale="deDE", namespace="Families", format="lua_additive_table", handle-unlocalized=comment)@

elseif locale == "esES" then
    --@localization(locale="esES", format="lua_additive_table", handle-unlocalized=comment)@
    --@localization(locale="esES", namespace="Settings", format="lua_additive_table", handle-unlocalized=comment)@
    --@localization(locale="esES", namespace="Families", format="lua_additive_table", handle-unlocalized=comment)@

elseif locale == "esMX" then
    --@localization(locale="esMX", format="lua_additive_table", handle-unlocalized=comment)@
    --@localization(locale="esMX", namespace="Settings", format="lua_additive_table", handle-unlocalized=comment)@
    --@localization(locale="esMX", namespace="Families", format="lua_additive_table", handle-unlocalized=comment)@

elseif locale == "frFR" then
    --@localization(locale="frFR", format="lua_additive_table", handle-unlocalized=comment)@
    --@localization(locale="frFR", namespace="Settings", format="lua_additive_table", handle-unlocalized=comment)@
    --@localization(locale="frFR", namespace="Families", format="lua_additive_table", handle-unlocalized=comment)@

elseif locale == "itIT" then
    --@localization(locale="itIT", format="lua_additive_table", handle-unlocalized=comment)@
    --@localization(locale="itIT", namespace="Settings", format="lua_additive_table", handle-unlocalized=comment)@
    --@localization(locale="itIT", namespace="Families", format="lua_additive_table", handle-unlocalized=comment)@

elseif locale == "koKR" then
    --@localization(locale="koKR", format="lua_additive_table", handle-unlocalized=comment)@
    --@localization(locale="koKR", namespace="Settings", format="lua_additive_table", handle-unlocalized=comment)@
    --@localization(locale="koKR", namespace="Families", format="lua_additive_table", handle-unlocalized=comment)@

elseif locale == "ptBR" then
    --@localization(locale="ptBR", format="lua_additive_table", handle-unlocalized=comment)@
    --@localization(locale="ptBR", namespace="Settings", format="lua_additive_table", handle-unlocalized=comment)@
    --@localization(locale="ptBR", namespace="Families", format="lua_additive_table", handle-unlocalized=comment)@

elseif locale == "ruRU" then
    --@localization(locale="ruRU", format="lua_additive_table", handle-unlocalized=comment)@
    --@localization(locale="ruRU", namespace="Settings", format="lua_additive_table", handle-unlocalized=comment)@
    --@localization(locale="ruRU", namespace="Families", format="lua_additive_table", handle-unlocalized=comment)@

elseif locale == "zhCN" then
    --@localization(locale="zhCN", format="lua_additive_table", handle-unlocalized=comment)@
    --@localization(locale="zhCN", namespace="Settings", format="lua_additive_table", handle-unlocalized=comment)@
    --@localization(locale="zhCN", namespace="Families", format="lua_additive_table", handle-unlocalized=comment)@

elseif locale == "zhTW" then
    --@localization(locale="zhTW", format="lua_additive_table", handle-unlocalized=comment)@
    --@localization(locale="zhTW", namespace="Settings", format="lua_additive_table", handle-unlocalized=comment)@
    --@localization(locale="zhTW", namespace="Families", format="lua_additive_table", handle-unlocalized=comment)@
end