local _, ADDON = ...

ADDON.DB.Recent = {
    ["minID"] = 1,
    ["blacklist"] = { },
    ["whitelist"] = { },
}

-- in wotlk no mount has a sourceType set. so generic filter doesn't work.
-- => add manually for professions, shop and tcg :(

ADDON.DB.Source.Profession[44151] = true; -- Turbo-Charged Flying Machine
ADDON.DB.Source.Profession[44153] = true; -- Flying Machine
ADDON.DB.Source.Profession[55531] = true; -- Mechano-Hog
ADDON.DB.Source.Profession[60424] = true; -- Mekgineer's Chopper
ADDON.DB.Source.Profession[61309] = true; -- Magnificent Flying Carpet
ADDON.DB.Source.Profession[61451] = true; -- Flying Carpet
ADDON.DB.Source.Profession[64731] = true; -- Sea Turtle
ADDON.DB.Source.Profession[75596] = true; -- Frosty Flying Carpet

ADDON.DB.Source.Promotion[42776] = true; -- Spectral Tigher
ADDON.DB.Source.Promotion[42777] = true; -- Swift Spectral Tigher
ADDON.DB.Source.Promotion[46197] = true; -- X-51 Nether-Rocket
ADDON.DB.Source.Promotion[46199] = true; -- X-51 Nether-Rocket X-TREME
ADDON.DB.Source.Promotion[51412] = true; -- Big Battle Bear
ADDON.DB.Source.Promotion[58983] = true; -- Big Blizzard Bear
ADDON.DB.Source.Promotion[65917] = true; -- Magic Rooster
ADDON.DB.Source.Promotion[74856] = true; -- Blazing Hippogryph
ADDON.DB.Source.Promotion[74918] = true; -- Wooly White Rhino
ADDON.DB.Source.Promotion[348459] = true; -- Reawakened Phase-Hunter
ADDON.DB.Source.Promotion[372677] = true; -- Kalu'ak Whalebone Glider
ADDON.DB.Source.Promotion[394209] = true; -- Festering Emerald Drake
ADDON.DB.Source.Promotion[416158] = true; -- Nightmarish Emerald Drake
ADDON.DB.Source.Promotion[423869] = true; -- Avatar of Flame

ADDON.DB.Family["Reptiles"]["Others"][1761] = true; -- Reawakened Phase-Hunter
ADDON.DB.Family["Vehicles"]["Kites"][1762] = true; -- Kalu'ak Whalebone Glider
ADDON.DB.Family["Drakes"]["Drakes"][1770] = true; -- Festering Emerald Drake
ADDON.DB.Family["Drakes"]["Drakes"][1832] = true; -- Nightmarish Emerald Drake

ADDON.DB.Expansion[1][1761] = true; -- Reawakened Phase-Hunter (TBC Classic)
ADDON.DB.Expansion[2][1762] = true; -- Kalu'ak Whalebone Glider (WotLK Classic)
ADDON.DB.Expansion[3][1807] = true; -- Avatar of Flame (Cataclysm Classic)
ADDON.DB.Expansion[GetServerExpansionLevel()].maxID = 999999999

-- These are duplicate TCG mounts only existing in classic
ADDON.DB.Ignored.ids[1763] = true; -- Magic Rooster
ADDON.DB.Ignored.ids[1764] = true; -- X-51 Nether-Rocket X-TREME
ADDON.DB.Ignored.ids[1765] = true; -- Big Battle Bear
ADDON.DB.Ignored.ids[1766] = true; -- Blazing Hippogryph
ADDON.DB.Ignored.ids[1767] = true; -- Wooly White Rhino
ADDON.DB.Ignored.ids[1768] = true; -- X-51 Nether-Rocket
