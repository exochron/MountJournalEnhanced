local _, ADDON = ...

local build = select(4, GetBuildInfo())
if build < 50000 then
    ADDON.DB.Recent = {
        ["minID"] = 2313, -- some next mount
        ["blacklist"] = {},
        ["whitelist"] = {1931, 1932, 1933, 1934 },
    }
else
    ADDON.DB.Recent = {
        ["minID"] = 2340,
        ["blacklist"] = {},
        ["whitelist"] = { },
    }
end

-- in classic no mount has a sourceType set. so generic filter doesn't work.
-- => add manually for professions, shop and tcg :(

ADDON.DB.Source.Profession[44151] = true; -- Turbo-Charged Flying Machine
ADDON.DB.Source.Profession[44153] = true; -- Flying Machine
ADDON.DB.Source.Profession[55531] = true; -- Mechano-Hog
ADDON.DB.Source.Profession[60424] = true; -- Mekgineer's Chopper
ADDON.DB.Source.Profession[61309] = true; -- Magnificent Flying Carpet
ADDON.DB.Source.Profession[61451] = true; -- Flying Carpet
ADDON.DB.Source.Profession[64731] = true; -- Sea Turtle
ADDON.DB.Source.Profession[75596] = true; -- Frosty Flying Carpet
ADDON.DB.Source.Profession[84751] = true; -- Fossilized Raptor
ADDON.DB.Source.Profession[92155] = true; -- Ultramarine Qiraji Battle Tank
ADDON.DB.Source.Profession[93326] = true; -- Sandstone Drake
ADDON.DB.Source.Profession[120043] = true; -- Jeweled Ony Panther
ADDON.DB.Source.Profession[121820] = true; -- Obsidian Nightwing
ADDON.DB.Source.Profession[121836] = true; -- Sapphire Panther
ADDON.DB.Source.Profession[121837] = true; -- Jade Panther
ADDON.DB.Source.Profession[121839] = true; -- Sunstone Panther
ADDON.DB.Source.Profession[126507] = true; -- Depleted-Kyparium Rocket
ADDON.DB.Source.Profession[126508] = true; -- Geosynchronous World Spinner
ADDON.DB.Source.Profession[134359] = true; -- Sky Golem

ADDON.DB.Source.Promotion[42776] = true; -- Spectral Tiger
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
ADDON.DB.Source.Promotion[388516] = true; -- Hao-Yue
ADDON.DB.Source.Promotion[394209] = true; -- Festering Emerald Drake
ADDON.DB.Source.Promotion[416158] = true; -- Nightmarish Emerald Drake
ADDON.DB.Source.Promotion[423869] = true; -- Avatar of Flame
ADDON.DB.Source.Promotion[93623] = true; -- Mottled Drake
ADDON.DB.Source.Promotion[96503] = true; -- Amani Dragonhawk
ADDON.DB.Source.Promotion[97581] = true; -- Savage Raptor
ADDON.DB.Source.Promotion[98727] = true; -- Winged Guardian
ADDON.DB.Source.Promotion[101573] = true; -- Swift Shorestrider
ADDON.DB.Source.Promotion[102488] = true; -- White Riding Camel
ADDON.DB.Source.Promotion[102514] = true; -- Corrupted Hippogryph
ADDON.DB.Source.Promotion[107203] = true; -- Tyrael's Charger
ADDON.DB.Source.Promotion[107516] = true; -- Spectral Gryphon
ADDON.DB.Source.Promotion[107517] = true; -- Spectral Wind Rider
ADDON.DB.Source.Promotion[110051] = true; -- Heart of the Aspects
ADDON.DB.Source.Promotion[113120] = true; -- Feldrake
ADDON.DB.Source.Promotion[124659] = true; -- Imperial Quilen
ADDON.DB.Source.Promotion[136505] = true; -- Ghastly Charger
ADDON.DB.Source.Promotion[142073] = true; -- Hearthsteed
ADDON.DB.Source.Promotion[155741] = true; -- Dread Raven
ADDON.DB.Source.Shop[139595] = true; -- Armored Bloodwing
ADDON.DB.Source.Shop[142878] = true; -- Enchanted Fey Dragon
ADDON.DB.Source.Shop[153489] = true; -- Iron Skyreaver
ADDON.DB.Source.Shop[163024] = true; -- Warforged Nightmare
ADDON.DB.Source.Shop[348459] = true; -- Reawakened Phase-Hunter (TBC Classic)
ADDON.DB.Source.Shop[372677] = true; -- Kalu'ak Whalebone Glider (WotLK Classic)
ADDON.DB.Source.Shop[440915] = true; -- Auspicious Arborwyrm
ADDON.DB.Source.Shop[463045] = true; -- Lava Drake (12 Month Sub)
ADDON.DB.Source.Shop[466948] = true; -- Chaos-Born Dreadwing
ADDON.DB.Source.Shop[466977] = true; -- Chaos-Born Wind Rider
ADDON.DB.Source.Shop[466980] = true; -- Chaos-Born Hippogryph
ADDON.DB.Source.Shop[466983] = true; -- Chaos-Born Gryphon
ADDON.DB.Source.Shop[473478] = true; -- Sha-Touched Riding Tiger
ADDON.DB.Source.Shop[473487] = true; -- Sha-Touched Cloud Serpent
ADDON.DB.Source.Shop[1224596] = true; -- Meeksi Teapuff (classic)
ADDON.DB.Source.Shop[1224643] = true; -- Meeksi Gentlepaw (classic)
ADDON.DB.Source.Shop[1224645] = true; -- Meeksi Rufflemane (classic)
ADDON.DB.Source.Shop[1224646] = true; -- Meeksi Wanderpaw (classic)
ADDON.DB.Source.Shop[1224647] = true; -- Meeksi Brewrobber (classic)

--ADDON.DB.Expansion[0][1843] = true; -- Tiger
ADDON.DB.Expansion[1][1761] = true; -- Reawakened Phase-Hunter (TBC Classic)
ADDON.DB.Expansion[2][1762] = true; -- Kalu'ak Whalebone Glider (WotLK Classic)
ADDON.DB.Expansion[2][1769] = true; -- Hao-Yue, River Foreseer
ADDON.DB.Expansion[2][1770] = true; -- Festering Emerald Drake
ADDON.DB.Expansion[2][1806] = true; -- Auspicious Arborwyrm
ADDON.DB.Expansion[2][1832] = true; -- Nightmarish Emerald Drake
ADDON.DB.Expansion[2][2147] = true; -- Polly Roger

-- in cataclysm classic all mounts got new mountIds
ADDON.DB.Expansion[3].minID = 1807; -- Avatar of Flame (Cataclysm Classic)
ADDON.DB.Expansion[3].maxID = 2312; -- Chaos-Born Gryphon

-- mists keeps old mount Ids. meaning but we have to add newer mounts manually
ADDON.DB.Expansion[4][2340] = true; -- Sha-Touched Riding Tiger
ADDON.DB.Expansion[4][2341] = true; -- Sha-Touched Cloud Serpent
ADDON.DB.Expansion[4][2342] = true; -- Meeksi
ADDON.DB.Expansion[4][2343] = true; -- Meeksi
ADDON.DB.Expansion[4][2344] = true; -- Meeksi
ADDON.DB.Expansion[4][2345] = true; -- Meeksi
ADDON.DB.Expansion[4][2346] = true; -- Meeksi
ADDON.DB.Expansion[4][2514] = true; -- Meeksi
ADDON.DB.Expansion[4][2515] = true; -- Meeksi
ADDON.DB.Expansion[4][2516] = true; -- Meeksi
ADDON.DB.Expansion[4][2517] = true; -- Meeksi
--ADDON.DB.Expansion[GetClientDisplayExpansionLevel()].maxID = 999999999

-- These are duplicate TCG mounts only existing in classic
ADDON.DB.Ignored.ids[1763] = true; -- Magic Rooster
ADDON.DB.Ignored.ids[1764] = true; -- X-51 Nether-Rocket X-TREME
ADDON.DB.Ignored.ids[1765] = true; -- Big Battle Bear
ADDON.DB.Ignored.ids[1766] = true; -- Blazing Hippogryph
ADDON.DB.Ignored.ids[1767] = true; -- Wooly White Rhino
ADDON.DB.Ignored.ids[1768] = true; -- X-51 Nether-Rocket

ADDON.DB.Ignored.ids[1843] = true; -- Tiger
