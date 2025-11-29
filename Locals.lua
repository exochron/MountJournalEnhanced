local _, ADDON = ...

local locale = GetLocale()

ADDON.isMetric = (locale ~= "enUS") -- is the metric or imperial unit system used?
ADDON.L = {}
local L = ADDON.L

L["AUTO_ROTATE"] = "Rotate automatically"
L["Black Market"] = "Black Market"
L["COMPARTMENT_TOOLTIP"] = "|cffeda55fLeft-Click|r to toggle showing the mount collection.\n|cffeda55fRight-Click|r to open addon options."
L["DRESSUP_LABEL"] = "Journal"
L["FAVOR_DISPLAYED"] = "All Displayed"
L["FILTER_ONLY_LATEST"] = "Only latest additions"
L["FILTER_PROFILE"] = "Profile"
L["FILTER_PROFILE_TOOLTIP_TITLE"] = "Filter Profiles"
L["FILTER_PROFILE_TOOLTIP_TEXT"] = "Quickly load your predefined filter and search settings.|n|cffeda55fLeft-Click|r to load filter profile.|n|cffeda55fRight-Click|r to save filter profile."
L["FILTER_PROFILE_TOOLTIP_REMIX_LEGION"] = "You can use this prepared profile for Legion: Remix."
L["FILTER_SECRET"] = "Hidden by the game"
L["FILTER_RETIRED"] = "No longer available"
L["Family"] = "Family"
L["Hidden"] = "Hidden"
L["Only tradable"] = "Only tradable"
L["Only usable"] = "Only usable"
L["Passenger"] = "Passenger"
L["PET_ASSIGNMENT_TITLE"] = "Assign Pet to Mount"
L["PET_ASSIGNMENT_NONE"] = "No Pet"
L["PET_ASSIGNMENT_TOOLTIP_CURRENT"] = "Current assigned Pet:"
L["PET_ASSIGNMENT_TOOLTIP_LEFT"] = "|cffeda55fLeft click|r to open pet assignment."
L["PET_ASSIGNMENT_TOOLTIP_RIGHT"] = "|cffeda55fRight click|r to assign active pet to mount."
L["PET_ASSIGNMENT_INFO"] = "You can assign a pet to this mount. It's going to be summoned as well, when you mount up.|n|n"
        .. "All assignments are shared with all your characters.|n|n"
        .. "You can use right-click on a pet entry to summon it manually.|n|n"
        .. "Please be aware that most ground pets won't fly with you and just disappear when you take off. Also, flying pets are usually slower than you. So they might need some time to catch up to you.|n|n"
        .. "Auto summoning pets is only active in world content."
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
L["STATS_TIP_TRAVEL_TIME_DAYS"] = "in days"
L["STATS_TIP_USAGE_COUNT_HEAD"] = "Usage count"
L["TOGGLE_COLOR"] = "Show next color variation"
L["Transform"] = "Transform"
L["ANIMATION_STAND"] = "Stand"
L["ANIMATION_WALK"] = "Walk"
L["ANIMATION_WALK_BACK"] = "Walk Backwards"
L["ANIMATION_RUN"] = "Run"
L["ANIMATION_FLY"] = "Fly"
L["ANIMATION_FLY_IDLE"] = "Fly Idle"
L["FILTER_ONLY"] = "only"
L["LINK_WOWHEAD"] = "Link to Wowhead"
L["CLICK_TO_SHOW_LINK"] = "Click to Show Link"
L["SYNC_TARGET_TIP_TITLE"] = "Sync Journal with Target"
L["SYNC_TARGET_TIP_TEXT"] = "Automatically select the mount of your current target."
L["SYNC_TARGET_TIP_FLAVOR"] = "Get ready for a mount off!"
L["FAVORITE_PROFILE"] = "Profile"
L["FAVORITE_ACCOUNT_PROFILE"] = "Account"
L["ASK_FAVORITE_PROFILE_NAME"] = "Enter Profile Name:"
L["CONFIRM_FAVORITE_PROFILE_DELETION"] = "Are you sure you want to delete the profile \"%s\"?\nAll current character assignments will be reset to the default profile \"%s\"."
L["FAVOR_AUTO"] = "Add new mounts automatically"
L["LDB_TIP_NO_FAVORITES_TITLE"] = "You have not selected any mount as favorite yet."
L["LDB_TIP_NO_FAVORITES_LEFT_CLICK"] = "|cffeda55fLeft click|r to open Mount Collection."
L["LDB_TIP_NO_FAVORITES_RIGHT_CLICK"] = "|cffeda55fRight click|r to select different Favorite Profile."
L["EVENT_PLUNDERSTORM"] = "Plunderstorm"
L["EVENT_SCARAB"] = "Call of the Scarab"
L["EVENT_SECRETS"] = "Secrets of Azeroth"

-- Settings
L["DISPLAY_ALL_SETTINGS"] = "Display all settings"
L["RESET_WINDOW_SIZE"] = "Reset journal size"
L["SETTING_ABOUT_AUTHOR"] = "Author"
L["SETTING_ACHIEVEMENT_POINTS"] = "Show achievement points"
L["SETTING_COLOR_NAMES"] = "Colorize names in list based on rarity"
L["SETTING_COMPACT_LIST"] = "Compact mount list"
L["SETTING_CURSOR_KEYS"] = "Enable Up&Down keys to browse mounts"
L["SETTING_DISPLAY_BACKGROUND"] = "Change background color in display"
L["SETTING_HEAD_ABOUT"] = "About"
L["SETTING_HEAD_BEHAVIOUR"] = "Behavior"
L["SETTING_MOUNT_COUNT"] = "Show personal mount count"
L["SETTING_MOUNTSPECIAL_BUTTON"] = "Show /mountspecial button"
L["SETTING_PERSONAL_FILTER"] = "Apply filters only to this character"
L["SETTING_PERSONAL_HIDDEN_MOUNTS"] = "Apply hidden mounts only to this character"
L["SETTING_PERSONAL_UI"] = "Apply Interface settings only to this character"
L["SETTING_PREVIEW_LINK"] = "Show Collection button in mount preview"
L["SETTING_SEARCH_MORE"] = "Search also in description text"
L["SETTING_SEARCH_FAMILY_NAME"] = "Search also by family name"
L["SETTING_SEARCH_NOTES"] = "Search also in own notes"
L["SETTING_SHOW_RESIZE_EDGE"] = "Activate edge in bottom corner to resize window"
L["SETTING_SHOW_DATA"] = "Show mount data in display"
L["SETTING_SUMMONPREVIOUSPET"] = "Summon previous active pet again when dismounting."
L["SETTING_TRACK_USAGE"] = "Track mount usage behavior on all characters"
L["SETTING_YCAMERA"] = "Unlock Y rotation with mouse in display"
L["SETTING_SHOW_FILTER_PROFILES_IN_MENU"] = "Show filter profiles in filter menu."

-- Families
--@localization(locale="enUS", namespace="Families", format="lua_additive_table", handle-unlocalized=comment)@

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

-- update labels for keyboard bindings (see: Bindings.xml)
BINDING_NAME_MJE_RANDOM_MOUNT = MOUNT_JOURNAL_SUMMON_RANDOM_FAVORITE_MOUNT