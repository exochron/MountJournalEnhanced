local ADDON_NAME, ADDON = ...

ADDON.MountJournalEnhancedSource = {
    ["Drop"] = {
        -- sourceType = 1
        ------------------------------
        -- Alliance & Horde ----------
        ------------------------------

        [24242] = true, -- Swift Razzashi Raptor- no longer available
        [24252] = true, -- Swift Zulian Tiger- no longer available
        [60002] = true, -- Time-Lost Proto-Drake- The Storm Peaks, Time-Lost Proto-Drake
        [88718] = true, -- Phosphorescent Stone Drake- Deepholm, Aeonaxx
        [88750] = true, -- Grey Riding Camel- Uldum, Mysterious Camel Figurine
        [98718] = true, -- Subdued Seahorse- Shimmering Expanse, Poseidus
        [127158] = true, -- Heavenly Onyx Cloud Serpent- Kun-Lai Summit, Sha of Anger
        [130965] = true, -- Son of Galleon- Valley of the Four Winds, Galleon
        [132036] = true, -- Thundering Ruby Cloud Serpent- 10x Skyshard
        [138423] = true, -- Cobalt Primordial Direhorn- Isle of Giants, Oondasta
        [139442] = true, -- Thundering Cobalt Cloud Serpent- Isle of Thunder, Nalak
        [148476] = true, -- Thundering Onyx Cloud Serpent- Timeless Isle, Huolon
        [179478] = true, -- Voidtalon of the Dark Star- Edge of Reality

        -- Zandalari Warbringer
        [138424] = true, -- Amber Primordial Direhorn
        [138425] = true, -- Slate Primordial Direhorn
        [138426] = true, -- Jade Primordial Direhorn

        -- Mysterious Egg
        [61294] = true, -- Green Proto-Drake

        -- Primal Egg
        [138641] = true, -- Red Primal Raptor
        [138642] = true, -- Black Primal Raptor
        [138643] = true, -- Green Primal Raptor

        -- Warlords of Draenor Rare
        [171636] = true, -- Great Greytusk
        [171620] = true, -- Bloodhoof Bull
        [171622] = true, -- Mottled Meadowstomper
        [171849] = true, -- Sunhide Gronnling
        [171824] = true, -- Sapphire Riverbeast
        [171830] = true, -- Swift Breezestrider
        [171619] = true, -- Tundra Icehoof - Vengeance, Deathtalon, Terrorfist, Doomroller
        [171630] = true, -- Armored Razorback - Vengeance, Deathtalon, Terrorfist, Doomroller
        [171837] = true, -- Warsong Direfang - Vengeance, Deathtalon, Terrorfist, Doomroller

        -- Warlords of Draenor Elite
        [171851] = true, -- Garn Nighthowl

        -- Warlords of Draenor World Boss
        [171828] = true, -- Solar Spirehawk - Rukhmar

        -- Legion
        [223018] = true, -- Fathom Dweller - World Boss, Kosumoth the Hungering
        [243025] = true, -- Riddler's Mind-Worm
        [242881] = true, -- Cloudwing Hippogryph - Farondis cache (paragon)
        [242874] = true, -- Highmountain Elderhorn - Highmountain Supplies (paragon)
        [233364] = true, -- Leywoven Flying Carpet - Nightfallen Cache (paragon)
        [242882] = true, -- Valarjar Stormwing - Valarjar Strongbox (paragon)
        [242875] = true, -- Wild Dreamrunner - Dreamweaver Cache (paragon)
        [254258] = true, -- Blessed Felcrusher - Army of the Light Cache (paragon)
        [254259] = true, -- Avenging Felcrusher - Army of the Light Cache (paragon)
        [254069] = true, -- Glorious Felcrusher - Army of the Light Cache (paragon)
        [253058] = true, -- Maddened Chaosrunner
        [243652] = true, -- Vile Fiend
        [253661] = true, -- Crimson Slavermaw
        [253662] = true, -- Acid Belcher
        [253660] = true, -- Biletooth Gnasher
        [253106] = true, -- Vibrant Mana Ray
        [253107] = true, -- Lambent Mana Ray
        [253108] = true, -- Felglow Mana Ray
        [253109] = true, -- Scintillating Mana Ray
        [235764] = true, -- Darkspore Mana Ray
        [247402] = true, -- Lucid Nightmare

        -- Battle for Azeroth
        [237286] = true, -- Dune Scavenger
        [243795] = true, -- Leaping Veinseeker
        [279868] = true, -- Witherbark Direwing - Nimar the Slayer Nimar the Slayer
        [279569] = true, -- Swift Albino Raptor - Beastrider Kama
        [279611] = true, -- Skullripper - Skullripper
        [275623] = true, -- Nazjatar Blood Serpent - Adherent of the Abyss
        [279608] = true, -- Lil' Donkey - Overseer Krix
        [279457] = true, -- Broken Highland Mustang - Knight-Captain Aldrin
        [260174] = true, -- Terrified Pack Mule
        [279456] = true, -- Highland Mustang -Doomrider Helgrim
        [260175] = true, -- Goldenmane
    },

    ["Quest"] = {
        -- sourceType = 2
        ------------------------------
        -- Alliance & Horde ----------
        ------------------------------

        [26656] = true, -- Black Qiraji Battle Tank - no longer available
        [54753] = true, -- White Polar Bear - Quest from Gretta the Arbiter, needs reputation to be able to accept the quest
        [73313] = true, -- Crimson Deathcharger - Mograine's Reunion
        [75207] = true, -- Abyssal Seahorse - The Abyssal Ride
        [127154] = true, -- Onyx Cloud Serpent - Quest Surprise Attack!, needs reputation to be able to accept the quest
        [138640] = true, -- Bone-White Primal Raptor - A Mountain of Giant Dinosaur Bones
        [171850] = true, -- Llothien Prowler - Volpin the Elusive
        [213164] = true, -- Brilliant Direbeak - Direbeak Reunion
        [213165] = true, -- Viridian Sharptalon - Sharptalon Reunion
        [213163] = true, -- Snowfeather Hunter - Snowfeather Reunion
        [213158] = true, -- Predatory Bloodgazer - Bloodgazer Reunion
        [215159] = true, -- Long-Forgotten Hippogryph - Ephemeral Crystal x5
        [230987] = true, -- Arcanist's Manasaber - Fate of the Nightborne
        [239770] = true, -- Black Qiraji War Tank - newer high res version of the Black Qiraji Battle Tank

        ------------------------------
        -- Alliance ------------------
        ------------------------------

        [136163] = true, -- Grand Gryphon - Operation: Shieldwall; The Silence
        [274610] = true, -- Teldrassil Hippogryph - From the Ashes... (BfA PreQuest)

        ------------------------------
        -- Horde ---------------------
        ------------------------------

        [136164] = true, -- Grand Wyvern - Dominance Offensive; Breath of Darkest Shadow
        [272472] = true, -- Undercity Plaguebat - Killer Queen (BfA PreQuest)
        [267270] = true, -- Kua'fon - Down, But Not Out
    },

    ["Vendor"] = {
        -- sourceType = 3
        ------------------------------
        -- Alliance & Horde ----------
        ------------------------------

        [122708] = true, -- Grand Expedition Yak
        [127216] = true, -- Grey Riding Yak
        [127220] = true, -- Blonde Riding Yak
        [171825] = true, -- Mosshide Riverwallow
        [171616] = true, -- Witherhide Cliffstomper
        [171628] = true, -- Rocktusk Battleboar - Trader Araanda, Trader Darakk
        [213115] = true, -- Bloodfang Widow - The Mad Merchant
        [227956] = true, -- Arcadian War Turtle - Xur'ios
        [214791] = true, -- Brinedeep Bottom-Feeder - Conjurer Margoss
        [230844] = true, -- Brawler's Burly Basilisk - brawler guild mount (season 2)
        [264058] = true, -- Mighty Caravan Brutosaur
        [279474] = true, -- Palehide Direhorn

        ------------------------------
        -- Alliance ------------------
        ------------------------------

        [171846] = true, -- Champion's Treadblade

        -- pre 1.4, no longer available
        [15779] = true, -- White Mechanostrider Mod B
        [16055] = true, -- Black Nightsaber
        [16056] = true, -- Ancient Frostsaber
        [16082] = true, -- Palomino
        [16083] = true, -- White Stallion
        [17459] = true, -- Icy Blue Mechanostrider Mod A
        [17460] = true, -- Frost Ram
        [17461] = true, -- Black Ram

        -- Stormwind
        [32235] = true, -- Golden Gryphon
        [32239] = true, -- Ebon Gryphon
        [32240] = true, -- Snowy Gryphon
        [32242] = true, -- Swift Blue Gryphon
        [32289] = true, -- Swift Red Gryphon
        [32290] = true, -- Swift Green Gryphon
        [32292] = true, -- Swift Purple Gryphon

        -- Kirin Tor
        [59791] = true, -- Wooly Mammoth - Alliance
        [60114] = true, -- Armored Brown Bear - Alliance
        [61229] = true, -- Armored Snowy Gryphon
        [61425] = true, -- Traveler's Tundra Mammoth - Alliance

        ------------------------------
        -- Horde ---------------------
        ------------------------------

        -- pre 1.4, no longer available
        [16080] = true, -- Red Wolf
        [16081] = true, -- Arctic Wolf
        [16084] = true, -- Mottled Red Raptor
        [17450] = true, -- Ivory Raptor
        [18991] = true, -- Green Kodo
        [18992] = true, -- Teal Kodo

        -- Orgrimmar
        [32243] = true, -- Tawny Wind Rider
        [32244] = true, -- Blue Wind Rider
        [32245] = true, -- Green Wind Rider
        [32246] = true, -- Swift Red Wind Rider
        [32295] = true, -- Swift Green Wind Rider
        [32296] = true, -- Swift Yellow Wind Rider
        [32297] = true, -- Swift Purple Wind Rider

        -- Kirin Tor
        [59793] = true, -- Wooly Mammoth - Horde
        [60116] = true, -- Armored Brown Bear - Horde
        [61230] = true, -- Armored Blue Wind Rider
        [61447] = true, -- Traveler's Tundra Mammoth - Horde
    },

    ["Profession"] = {
        sourceType = {4},
        [30174] = true, -- Riding Turtle
        [121838] = true, -- Ruby Panther
    },

    ["Instance"] = {
        -- Dungeon
        [17481] = true, -- Rivendare's Deathcharger - Stratholme, Lord Aurius Rivendare
        [41252] = true, -- Raven Lord - Sethekk Halls, Anzu
        [46628] = true, -- Swift White Hawkstrider - Magisters' Terrace, Kael'thas Sunstrider
        [59569] = true, -- Bronze Drake - The Culling of Stratholme, Infinite Corruptor
        [59996] = true, -- Blue Proto-Drake - Utgarde Pinnacle, Skadi
        [88742] = true, -- Drake of the North Wind - The Vortex Pinnacle, Altarius
        [88746] = true, -- Vitreous Stone Drake - The Stonecore, Slabhide
        [96491] = true, -- Armored Razzashi Raptor - Zul'Gurub, Bloodlord Mandokir
        [96499] = true, -- Swift Zulian Panther - Zul'Gurub, High Priestess Kilnara
        [231428] = true, -- Smoldering Ember Wyrm - Return to Karazhan timerun
        [229499] = true, -- Midnight - Return to Karazhan
        [254813] = true, -- Sharkbait - Freehold (Mythic)
        [266058] = true, -- Tomb Stalker - Kings' Rest (Mythic)
        [273541] = true, -- Underrot Crawg - The Underrot (Mythic)

        -- Raid
        [25953] = true, -- Blue Qiraji Battle Tank - Temple of Ahn'Qiraj
        [26054] = true, -- Red Qiraji Battle Tank - Temple of Ahn'Qiraj
        [26055] = true, -- Yellow Qiraji Battle Tank - Temple of Ahn'Qiraj
        [26056] = true, -- Green Qiraji Battle Tank - Temple of Ahn'Qiraj
        [36702] = true, -- Fiery Warhorse - Karazhan, Attumen the Huntsman
        [40192] = true, -- Ashes of Al'ar - The Eye, Kael'thas Sunstrider
        [59567] = true, -- Azure Drake - The Eye of Eternity, Malygos
        [59568] = true, -- Blue Drake - The Eye of Eternity, Malygos
        [59571] = true, -- Twilight Drake - The Obsidian Sanctum, Sartharion
        [59650] = true, -- Black Drake - The Obsidian Sanctum, Sartharion
        [61465] = true, -- Grand Black War Mammoth - Vault of Archavon, Alliance
        [61467] = true, -- Grand Black War Mammoth - Vault of Archavon, Horde
        [69395] = true, -- Onyxian Drake - Onyxia's Lair, Onyxia
        [63796] = true, -- Mimiron's Head - Ulduar, Yogg-Saron
        [72286] = true, -- Invincible - Icecrown Citadel, The Lich King
        [88744] = true, -- Drake of the South Wind - Throne of Four Winds, Al'Akir
        [97493] = true, -- Pureblood Fire Hawk - Firelands, Ragnaros
        [101542] = true, -- Flametalon of Alysrazor - Firelands, Alysrazor
        [107842] = true, -- Blazing Drake - Dragon Soul, Deathwing
        [107845] = true, -- Life-Binder's Handmaiden - Dragon Soul, Deathwing
        [110039] = true, -- Experiment 12-B - Dragon Soul, Ultraxion
        [127170] = true, -- Astral Cloud Serpent - Mogu'shan Vaults, Elegon
        [136471] = true, -- Spawn of Horridon - Throne of Thunder, Horridon
        [139448] = true, -- Clutch of Ji-Kun - Throne of Thunder, Ji-Kun
        [148417] = true, -- Kor'kron Juggernaut - Siege of Orgrimmar, Garrosh Hellscream
        [171621] = true, -- Ironhoof Destroyer - Blackrock Foundry, Blackhand
        [182912] = true, -- Felsteel Annihilator - Hellfire Citadel, Archimonde
        [189999] = true, -- Grove Warden - Hellfire Citadel, Archimonde
        [213134] = true, -- Felblaze Infernal - The Nighthold, Gul'dan
        [171827] = true, -- Hellfire Infernal - The Nighthold, Gul'dan (Mythic)
        [232519] = true, -- Abyss Worm - Tomb of Sargeras, Mistress Sassz'ine
        [253088] = true, -- Antoran Charhound - Antorus, Shatug
        [253639] = true, -- Violet Spellwing - Antorus, Argus
        [243651] = true, -- Shackled Ur'zul - Antorus, Argus Mythic
    },

    ["Reputation"] = {
        ------------------------------
        -- Alliance & Horde ----------
        ------------------------------

        -- Sha'tari Skyguard
        [39798] = true, -- Green Riding Nether Ray
        [39800] = true, -- Red Riding Nether Ray
        [39801] = true, -- Purple Riding Nether Ray
        [39802] = true, -- Silver Riding Nether Ray
        [39803] = true, -- Blue Riding Nether Ray

        -- Netherwing
        [41513] = true, -- Onyx Netherwing Drake
        [41514] = true, -- Azure Netherwing Drake
        [41515] = true, -- Cobalt Netherwing Drake
        [41516] = true, -- Purple Netherwing Drake
        [41517] = true, -- Veridian Netherwing Drake
        [41518] = true, -- Violet Netherwing Drake

        -- Cenarion Expedition
        [43927] = true, -- Cenarion War Hippogryph

        -- The Storm Peaks
        [54753] = true, -- White Polar Bear - Quest from Gretta the Arbiter

        -- The Wyrmrest Accord
        [59570] = true, -- Red Drake

        -- Argent Tournament
        [63844] = true, -- Argent Hippogryph
        [66906] = true, -- Argent Charger
        [67466] = true, -- Argent Warhorse

        -- Ramkahen
        [88748] = true, -- Brown Riding Camel
        [88749] = true, -- Tan Riding Camel

        -- Tol Barad
        [88741] = true, -- Drake of the West Wind

        -- The Anglers
        [118089] = true, -- Azure Water Strider

        -- The Klaxxi
        [123886] = true, -- Amber Scorpion

        -- Order of the Cloud Serpent
        [113199] = true, -- Jade Cloud Serpent
        [123992] = true, -- Azure Cloud Serpent
        [123993] = true, -- Golden Cloud Serpent

        -- Golden Lotus
        [127174] = true, -- Azure Riding Crane
        [127176] = true, -- Golden Riding Crane
        [127177] = true, -- Regal Riding Crane

        -- Tushui Pandaren/Huojin Pandaren
        [120822] = true, -- Great Red Dragon Turtle
        [120395] = true, -- Green Dragon Turtle
        [127286] = true, -- Black Dragon Turtle
        [127287] = true, -- Blue Dragon Turtle
        [127288] = true, -- Brown Dragon Turtle
        [127289] = true, -- Purple Dragon Turtle
        [127290] = true, -- Red Dragon Turtle
        [127293] = true, -- Great Green Dragon Turtle
        [127295] = true, -- Great Black Dragon Turtle
        [127302] = true, -- Great Blue Dragon Turtle
        [127308] = true, -- Great Brown Dragon Turtle
        [127310] = true, -- Great Purple Dragon Turtle

        -- Shado-Pan
        [127154] = true, -- Onyx Cloud Serpent - From Quest Surprise Attack!
        [129932] = true, -- Green Shado-Pan Riding Tiger
        [129934] = true, -- Blue Shado-Pan Riding Tiger
        [129935] = true, -- Red Shado-Pan Riding Tiger

        -- The Tillers
        [130086] = true, -- Brown Riding Goat
        [130137] = true, -- White Riding Goat
        [130138] = true, -- Black Riding Goat

        -- The August Celestials
        [129918] = true, -- Thundering August Cloud Serpent

        -- The Lorewalkers
        [130092] = true, -- Red Flying Cloud

        -- Emperor Shaohao
        [127164] = true, -- Heavenly Golden Cloud Serpent

        -- The Saberstalkers
        [171633] = true, -- Wild Goretusk
        [190690] = true, -- Bristling Hellboar

        -- Steamwheedle Preservation Society
        [171634] = true, -- Domesticated Razorback

        -- Arakkoa Outcasts
        [171829] = true, -- Shadowmane Charger

        -- Order of the Awakened
        [183117] = true, -- Corrupted Dreadwing

        -- Vol'jin's Headhunters, Hand of the Prophet
        [190977] = true, -- Deathtusk Felboar

        -- Talon's Vengeance
        [230401] = true, -- White Hawkstrider

        -- Argussian Reach
        [242305] = true, -- Sable Ruinstrider
        [253004] = true, -- Amethyst Ruinstrider
        [253005] = true, -- Beryl Ruinstrider
        [253006] = true, -- Russet Ruinstrider
        [253007] = true, -- Cerulean Ruinstrider
        [253008] = true, -- Umber Ruinstrider

        -- Army of the Light
        [239013] = true, -- Lightforged Warframe

        ------------------------------
        -- Alliance ------------------
        ------------------------------

        -- Stormwind
        [458] = true, -- Brown Horse
        [470] = true, -- Black Stallion
        [472] = true, -- Pinto
        [6648] = true, -- Chestnut Mare
        [23227] = true, -- Swift Palomino
        [23228] = true, -- Swift White Steed
        [23229] = true, -- Swift Brown Steed

        -- Ironforge
        [6777] = true, -- Gray Ram
        [6898] = true, -- White Ram
        [6899] = true, -- Brown Ram
        [23238] = true, -- Swift Brown Ram
        [23239] = true, -- Swift Gray Ram
        [23240] = true, -- Swift White Ram

        -- Gnomeregan
        [10873] = true, -- Red Mechanostrider
        [10969] = true, -- Blue Mechanostrider
        [17453] = true, -- Green Mechanostrider
        [17454] = true, -- Unpainted Mechanostrider
        [23222] = true, -- Swift Yellow Mechanostrider
        [23223] = true, -- Swift White Mechanostrider
        [23225] = true, -- Swift Green Mechanostrider

        -- Darnassus
        [8394] = true, -- Striped Frostsaber
        [10793] = true, -- Striped Nightsaber
        [10789] = true, -- Spotted Frostsaber
        [23219] = true, -- Swift Mistsaber
        [23221] = true, -- Swift Frostsaber
        [23338] = true, -- Swift Stormsaber
        [66847] = true, -- Striped Dawnsaber

        -- Exodar
        [34406] = true, -- Brown Elekk
        [35710] = true, -- Gray Elekk
        [35711] = true, -- Purple Elekk
        [35712] = true, -- Great Green Elekk
        [35713] = true, -- Great Blue Elekk
        [35714] = true, -- Great Purple Elekk

        -- Gilneas
        [103195] = true, -- Mountain Horse
        [103196] = true, -- Swift Mountain Horse

        -- Wintersaber Trainers
        [17229] = true, -- Winterspring Frostsaber

        -- Kurenai
        [34896] = true, -- Cobalt War Talbuk
        [34897] = true, -- White War Talbuk
        [34898] = true, -- Silver War Talbuk
        [34899] = true, -- Tan War Talbuk
        [39315] = true, -- Cobalt Riding Talbuk
        [39317] = true, -- Silver Riding Talbuk
        [39318] = true, -- Tan Riding Talbuk
        [39319] = true, -- White Riding Talbuk

        -- The Sons of Hodir
        [59799] = true, -- Ice Mammoth - Alliance
        [61470] = true, -- Grand Ice Mammoth - Alliance

        -- Argent Tournament
        [63232] = true, -- Stormwind Steed
        [63636] = true, -- Ironforge Ram
        [63637] = true, -- Darnassian Nightsaber
        [63638] = true, -- Gnomeregan Mechanostrider
        [63639] = true, -- Exodar Elekk
        [65637] = true, -- Great Red Elekk
        [65638] = true, -- Swift Moonsaber
        [65640] = true, -- Swift Gray Steed
        [65642] = true, -- Turbostrider
        [65643] = true, -- Swift Violet Ram

        -- The Silver Covenant
        [66087] = true, -- Silver Covenant Hippogryph
        [66090] = true, -- Quel'dorei Steed

        -- Tol Barad
        [92231] = true, -- Spectral Steed

        -- Operation: Shieldwall
        [135416] = true, -- Grand Armored Gryphon

        -- Kirin Tor Offensive
        [140249] = true, -- Golden Primal Direhorn

        -- Council of Exarchs
        [171625] = true, -- Dusty Rockhide

        -- Order of Embers
        [260173] = true, -- Smoky Charger

        -- Proudmoore Admiralty
        [259213] = true, -- Admiralty Stallion

        -- Storm's Wake
        [260172] = true, -- Dapple Gray

        ------------------------------
        -- Horde ---------------------
        ------------------------------

        -- Orgrimmar
        [580] = true, -- Timber Wolf
        [6653] = true, -- Dire Wolf
        [6654] = true, -- Brown Wolf
        [23250] = true, -- Swift Brown Wolf
        [23251] = true, -- Swift Timber Wolf
        [23252] = true, -- Swift Gray Wolf
        [64658] = true, -- Black Wolf

        -- Darkspear Trolls
        [8395] = true, -- Emerald Raptor
        [10796] = true, -- Turquoise Raptor
        [10799] = true, -- Violet Raptor
        [23241] = true, -- Swift Blue Raptor
        [23242] = true, -- Swift Olive Raptor
        [23243] = true, -- Swift Orange Raptor

        -- Undercity
        [17462] = true, -- Red Skeletal Horse
        [17463] = true, -- Blue Skeletal Horse
        [17464] = true, -- Brown Skeletal Horse
        [17465] = true, -- Green Skeletal Warhorse
        [23246] = true, -- Purple Skeletal Warhorse
        [64977] = true, -- Black Skeletal Horse
        [66846] = true, -- Ochre Skeletal Warhorse

        -- Thunder Bluff
        [18989] = true, -- Gray Kodo
        [18990] = true, -- Brown Kodo
        [23247] = true, -- Great White Kodo
        [23248] = true, -- Great Gray Kodo
        [23249] = true, -- Great Brown Kodo
        [64657] = true, -- White Kodo

        -- Silvermoon City
        [35027] = true, -- Swift Purple Hawkstrider
        [33660] = true, -- Swift Pink Hawkstrider
        [34795] = true, -- Red Hawkstrider
        [35018] = true, -- Purple Hawkstrider
        [35020] = true, -- Blue Hawkstrider
        [35022] = true, -- Black Hawkstrider
        [35025] = true, -- Swift Green Hawkstrider

        -- Bilgewater Cartel
        [87090] = true, -- Goblin Trike
        [87091] = true, -- Goblin Turbo-Trike

        -- Darkspear Trolls in Un'Goro Crater
        [64659] = true, -- Venomhide Ravasaur

        -- The Mag'har
        [34896] = true, -- Cobalt War Talbuk
        [34897] = true, -- White War Talbuk
        [34898] = true, -- Silver War Talbuk
        [34899] = true, -- Tan War Talbuk
        [39315] = true, -- Cobalt Riding Talbuk
        [39317] = true, -- Silver Riding Talbuk
        [39318] = true, -- Tan Riding Talbuk
        [39319] = true, -- White Riding Talbuk

        -- The Sons of Hodir
        [59797] = true, -- Ice Mammoth - Horde
        [61469] = true, -- Grand Ice Mammoth - Horde

        -- The Sunreavers
        [66088] = true, -- Sunreaver Dragonhawk
        [66091] = true, -- Sunreaver Hawkstrider

        -- Argent Tournament
        [63635] = true, -- Darkspear Raptor
        [63641] = true, -- Thunder Bluff Kodo
        [63640] = true, -- Orgrimmar Wolf
        [63642] = true, -- Silvermoon Hawkstrider
        [63643] = true, -- Forsaken Warhorse
        [65645] = true, -- White Skeletal Warhorse
        [65639] = true, -- Swift Red Hawkstrider
        [65641] = true, -- Great Golden Kodo
        [65644] = true, -- Swift Purple Raptor
        [65646] = true, -- Swift Burgundy Wolf

        -- Tol Barad
        [92232] = true, -- Spectral Wolf

        -- Sunreaver Onslaught
        [140250] = true, -- Crimson Primal Direhorn

        -- Dominance Offensive
        [135418] = true, -- Grand Armored Wyvern

        -- Frostwolf Orcs
        [171842] = true, -- Swift Frostwolf

        -- Talanji's Expedition
        [275841] = true, -- Expedition Bloodswarmer

        -- Voldunai
        [237287] = true, -- Alabaster Hyena

        -- Zandalari Empire
        [275837] = true, -- Cobalt Pterrordax
    },

    ["Achievement"] = {
        -- sourceType = 6
        ------------------------------
        -- Alliance & Horde ----------
        ------------------------------

        [43688] = true, -- Amani War Bear - no longer available
        [59976] = true, -- Black Proto-Drake - no longer available
        [60024] = true, -- Violet Proto-Drake - What a Long, Strange Trip It's Been
        [60025] = true, -- Albino Drake - Leading the Cavalry
        [98204] = true, -- Amani Battle Bear - Bear-ly Made It
        [133023] = true, -- Jade Pandaren Kite - Jade Pandaren Kite
        [142641] = true, -- Brawler's Burly Mushan Beast - I've Got the Biggest Brawls of Them All (Season 1)
        [127169] = true, -- Heavenly Azure Cloud Serpent - Lord of the Reins

        -- Wrath of the Lichking
        [59961] = true, -- Red Proto-Drake - Glory of the Hero
        [63956] = true, -- Ironbound Proto-Drake - Glory of the Ulduar Raider (25 player)
        [63963] = true, -- Rusted Proto-Drake - Glory of the Ulduar Raider (10 player)
        [72807] = true, -- Icebound Frostbrood Vanquisher - Glory of the Icecrown Raider (25 player)
        [72808] = true, -- Bloodbathed Frostbrood Vanquisher - Glory of the Icecrown Raider (10 player)

        -- Cataclysm
        [97359] = true, -- Flameward Hippogryph - The Molten Front Offensive
        [88331] = true, -- Volcanic Stone Drake - Glory of the Cataclysm Hero
        [88335] = true, -- Drake of the East Wind - Glory of the Cataclysm Raider
        [88990] = true, -- Dark Phoenix - Guild Glory of the Cataclysm Raider
        [97560] = true, -- Corrupted Fire Hawk - Glory of the Firelands Raider
        [107844] = true, -- Twilight Harbinger - Glory of the Dragon Soul Raider

        -- Mists of Pandaria
        [124408] = true, -- Thundering Jade Cloud Serpent - Guild Glory of the Pandaria Raider
        [127156] = true, -- Crimson Cloud Serpent - Glory of the Pandaria Hero
        [127161] = true, -- Heavenly Crimson Cloud Serpent - Glory of the Pandaria Raider
        [136400] = true, -- Armored Skyscreamer - Glory of the Thundering Raider
        [148392] = true, -- Spawn of Galakras - Glory of the Orgrimmar Raider
        [148396] = true, -- Kor'kron War Wolf - Ahead of the Curve: Garrosh Hellscream (10/25 player)

        -- Challenge Mode
        [129552] = true, -- Crimson Pandaren Phoenix - Challenge Conqueror: Silver
        [132117] = true, -- Ashen Pandaren Phoenix - Challenge Conqueror: Silver
        [132118] = true, -- Emerald Pandaren Phoenix - Challenge Conqueror: Silver
        [132119] = true, -- Violet Pandaren Phoenix - Challenge Conqueror: Silver

        -- Warlords of Draenor
        [97501] = true, -- Felfire Hawk - Mountacular
        [170347] = true, -- Core Hound - Boldly, You Sought the Power of Ragnaros
        [175700] = true, -- Emerald Drake -  Awake the Drakes
        [171436] = true, -- Gorestrider Gronnling - Glory of the Draenor Raider
        [171627] = true, -- Blacksteel Battleboar - Guild Glory of the Draenor Raider
        [171632] = true, -- Frostplains Battleboar - Glory of the Draenor Hero
        [171848] = true, -- Challenger's War Yeti - Challenge Warlord: Silver
        [186305] = true, -- Infernal Direwolf - Glory of the Hellfire Raider
        [191633] = true, -- Soaring Skyterror - Draenor Pathfinder

        -- Legion
        [223814] = true, -- Mechanized Lumber Extractor - Remember to Share
        [225765] = true, -- Leyfeather Hippogryph - Glory of the Legion Hero
        [215558] = true, -- Ratstallion - Underbelly Tycoon
        [193007] = true, -- Grove Defiler - Glory of the Legion Raider
        [254260] = true, -- Bleakhoof Ruinstrider - ...And Chew Mana Buns
        [253087] = true, -- Antoran Gloomhound - Glory of the Argus Raider
        [258022] = true, -- Lightforged Felcrusher - Allied Races: Lightforged Draenei
        [258060] = true, -- Highmountain Thunderhoof - Allied Races: Highmountain Tauren
        [258845] = true, -- Nightborne Manasaber - Allied Races: Nightborne
        [259202] = true, -- Starcursed Voidstrider - Allied Races: Void Elf

        -- Battle for Azeroth
        [213350] = true, -- Frostshard Infernal - No Stable Big Enough
        [280729] = true, -- Frenzied Feltalon - A Horde of Hoofbeats
        [263707] = true, -- Zandalari Direhorn - Allied Races: Zandalari Troll
        [267274] = true, -- Mag'har Direwolf - Allied Races: Mag'har Orc
        [271646] = true, -- Dark Iron Core Hound - Allied Races: Dark Iron Dwarf
        [239049] = true, -- Obsidian Krolusk - Glory of the Wartorn Hero
        [250735] = true, -- Bloodgorged Crawg - Glory of the Uldir Raider
        [279454] = true, -- Conquerer's Scythemaw - Conqueror of Azeroth
        [280730] = true, -- Pureheart Courser - 100 Exalted Reputations

        ------------------------------
        -- Alliance ------------------
        ------------------------------

        [68057] = true, -- Swift Alliance Steed - no longer available
        [68187] = true, -- Crusader's White Warhorse - no longer available
        [90621] = true, -- Golden King - Guild Level 25
        [130985] = true, -- Pandaren Kite - Pandaren Ambassador, Alliance

        [61996] = true, -- Blue Dragonhawk - Mountain o' Mounts, Alliance
        [142478] = true, -- Armored Blue Dragonhawk - Mount Parade, Alliance
        [179245] = true, -- Chauffeur - Heirloom Hoarder, Alliance

        ------------------------------
        -- Horde ---------------------
        ------------------------------

        [68056] = true, -- Swift Horde Wolf - no longer available
        [68188] = true, -- Crusader's Black Warhorse - no longer available
        [93644] = true, -- Kor'kron Annihilator - Guild Level 25
        [118737] = true, -- Pandaren Kite - Pandaren Ambassador, Horde
        [171845] = true, -- Warlord's Deathwheel -  Warlord's Deathwheel
        [179244] = true, -- Chauffeur - Heirloom Hoarder, Horde

        [61997] = true, -- Red Dragonhawk - Mountain o' Mounts, Horde
        [142266] = true, -- Armored Red Dragonhawk - Mount Parade, Horde
    },

    ["Island Expedition"] = {
        [254811] = true, -- Squawks
        [278979] = true, -- Surf Jelly
        [279466] = true, -- Twilight Avenger
        [279469] = true, -- Qinsho's Eternal Hound
        [279467] = true, -- Craghorn Chasm-Leaper
    },

    ["Garrison"] = {
        ------------------------------
        -- Alliance & Horde ----------
        ------------------------------

        -- Stables
        [171617] = true, -- Trained Icehoof
        [171623] = true, -- Trained Meadowstomper
        [171637] = true, -- Trained Rocktusk
        [171638] = true, -- Trained Riverwallow
        [171831] = true, -- Trained Silverpelt
        [171841] = true, -- Trained Snarler
        [171629] = true, -- Armored Frostboar - Advanced Husbandry
        [171838] = true, -- Armored Frostwolf - The Stable Master

        -- Fishing Shack
        [127271] = true, -- Crimson Water Strider

        -- Garrison Invasion
        [171624] = true, -- Shadowhide Pearltusk
        [171635] = true, -- Giant Coldsnout
        [171836] = true, -- Garn Steelmaw
        [171843] = true, -- Smoky Direwolf

        -- Garrison Mission
        [189364] = true, -- Coalfist Gronnling - Breaker Two
        [171826] = true, -- Mudback Riverbeast - It's a Boat, It's a Plane, It's... Just a Riverbeast.

        ------------------------------
        -- Alliance ------------------
        ------------------------------

        -- Trading Post
        [171626] = true, -- Armored Irontusk - Alliance

        ------------------------------
        -- Horde ---------------------
        ------------------------------

        -- Trading Post
        [171839] = true, -- Ironside Warwolf - Horde
    },

    ["PVP"] = {
        ------------------------------
        -- Alliance & Horde ----------
        ------------------------------

        -- Halaa
        [39316] = true, -- Dark Riding Talbuk
        [34790] = true, -- Dark War Talbuk

        -- Tol Barad
        [88741] = true, -- Drake of the West Wind

        -- Timeless Isle
        [148428] = true, -- Ashhide Mushan Beast

        -- Arena
        [37015] = true, -- Swift Nether Drake - Season 1
        [44744] = true, -- Merciless Nether Drake - Season 2
        [49193] = true, -- Vengeful Nether Drake - Season 3
        [58615] = true, -- Brutal Nether Drake - Season 4
        [64927] = true, -- Deadly Gladiator's Frost Wyrm - Season 5
        [65439] = true, -- Furious Gladiator's Frost Wyrm - Season 6
        [67336] = true, -- Relentless Gladiator's Frost Wyrm - Season 7
        [71810] = true, -- Wrathful Gladiator's Frost Wyrm - Season 8
        [101282] = true, -- Vicious Gladiator's Twilight Drake - Season 9
        [101821] = true, -- Ruthless Gladiator's Twilight Drake - Season 10
        [124550] = true, -- Cataclysmic Gladiator's Twilight Drake - Season 11
        [139407] = true, -- Malevolent Gladiator's Cloud Serpent - Season 12
        [148618] = true, -- Tyrannical Gladiator's Cloud Serpent - Season 13
        [148619] = true, -- Grievous Gladiator's Cloud Serpent - Season 14
        [148620] = true, -- Prideful Gladiator's Cloud Serpent - Season 15
        [186828] = true, -- Primal Gladiator's Felblood Gronnling - Season 16
        [189043] = true, -- Wild Gladiator's Felblood Gronnling - Season 17
        [189044] = true, -- Warmongering Gladiator's Felblood Gronnling - Season 18

        [227986] = true, -- Vindictive Gladiator's Storm Dragon - Gladiator: Legion Season 1
        [227988] = true, -- Fearless Gladiator's Storm Dragon - Gladiator: Legion Season 2
        [227989] = true, -- Cruel Gladiator's Storm Dragon - Gladiator: Legion Season 3
        [227991] = true, -- Ferocious Gladiator's Storm Dragon - Gladiator: Legion Season 4
        [227994] = true, -- Fierce Gladiator's Storm Dragon
        [227995] = true, -- Dominating Gladiator's Storm Dragon
        [243201] = true, -- Demonic Gladiator's Storm Dragon
        [262022] = true, -- Dread Gladiator's Proto-Drake - Gladiator: Battle for Azeroth Season 1

        -- Prestige Reward
        [222202] = true, -- Prestigious Bronze Courser
        [222236] = true, -- Prestigious Royal Courser
        [222237] = true, -- Prestigious Forest Courser
        [222238] = true, -- Prestigious Ivory Courser
        [222240] = true, -- Prestigious Azure Courser
        [222241] = true, -- Prestigious Midnight Courser
        [281044] = true, -- Prestigious Bloodforged Courser

        ------------------------------
        -- Alliance ------------------
        ------------------------------

        -- War Mounts
        [22717] = true, -- Black War Steed
        [22719] = true, -- Black Battlestrider
        [22720] = true, -- Black War Ram
        [22723] = true, -- Black War Tiger
        [48027] = true, -- Black War Elekk
        [183889] = true, -- Vicious War Mechanostrider
        [223578] = true, -- Vicious War Elekk
        [223341] = true, -- Vicious Gilnean Warhorse
        [229487] = true, -- Vicious War Bear
        [229512] = true, -- Vicious War Lion
        [232523] = true, -- Vicious War Turtle
        [242896] = true, -- Vicious War Fox
        [261433] = true, -- Vicious War Basilisk
        [272481] = true, -- Vicious War Riverbeast

        -- Achievement
        [60118] = true, -- Black War Bear - For The Alliance!
        [100332] = true, -- Vicious War Steed - Veteran of the Alliance
        [146615] = true, -- Vicious Warsaber - Grievous Combatant
        [171834] = true, -- Vicious War Ram - Primal Combatant
        [193695] = true, -- Prestigious War Steed - Free For All, More For Me

        -- Stormpike Guard
        [23510] = true, -- Stormpike Battle Charger

        -- Wintergrasp
        [59785] = true, -- Black War Mammoth - Alliance

        -- Tol Barad
        [92231] = true, -- Spectral Steed

        -- Wrynn's Vanguard
        [171833] = true, -- Pale Thorngrazer

        ------------------------------
        -- Horde ---------------------
        ------------------------------

        -- War Mounts
        [22718] = true, -- Black War Kodo
        [22724] = true, -- Black War Wolf
        [22722] = true, -- Red Skeletal Warhorse
        [35028] = true, -- Swift Warstrider
        [22721] = true, -- Black War Raptor
        [185052] = true, -- Vicious War Kodo
        [223354] = true, -- Vicious War Trike
        [223363] = true, -- Vicious Warstrider
        [229486] = true, -- Vicious War Bear
        [232525] = true, -- Vicious War Turtle
        [230988] = true, -- Vicious War Scorpion
        [242897] = true, -- Vicious War Fox
        [261434] = true, -- Vicious War Basilisk
        [270560] = true, -- Vicious War Clefthoof

        -- Achievement
        [60119] = true, -- Black War Bear - For The Horde!
        [100333] = true, -- Vicious War Wolf - Veteran of the Horde
        [146622] = true, -- Vicious Skeletal Warhorse - Grievous Combatant
        [171835] = true, -- Vicious War Raptor - Primal Combatant
        [204166] = true, -- Prestigious War Wolf - Free For All, More For Me

        -- Frostwolf Clan
        [23509] = true, -- Frostwolf Howler

        -- Wintergrasp
        [59788] = true, -- Black War Mammoth - Horde

        -- Tol Barad
        [92232] = true, -- Spectral Wolf

        -- Vol'jin's Spear
        [171832] = true, -- Breezestrider Stallion
    },

    ["Class"] = {
        ------------------------------
        -- Alliance & Horde ----------
        ------------------------------

        --Warlock
        [5784] = true, -- Felsteed
        [23161] = true, -- Dreadsteed
        [232412] = true, -- Netherlord's Chaotic Wrathsteed
        [238452] = true, -- Netherlord's Brimstone Wrathsteed
        [238454] = true, -- Netherlord's Accursed Wrathsteed

        -- Death Knight
        [48778] = true, -- Acherus Deathcharger
        [54729] = true, -- Winged Steed of the Ebon Blade
        [229387] = true, -- Deathlord's Vilebrood Vanquisher

        -- Demon Hunter
        [200175] = true, -- Felsaber
        [229417] = true, -- Slayer's Felbroken Shrieker

        -- Mage
        [229376] = true, -- Archmage's Prismatic Disc

        -- Paladin
        [66906] = true, -- Argent Charger
        [231435] = true, -- Highlord's Golden Charger
        [231587] = true, -- Highlord's Vengeful Charger
        [231588] = true, -- Highlord's Vigilant Charger
        [231589] = true, -- Highlord's Valorous Charger
        [270564] = true, -- Dawnforge Ram
        [270562] = true, -- Darkforge Ram

        -- Priest
        [229377] = true, -- High Priest's Lightsworn Seeker

        -- Monk
        [229385] = true, -- Ban-Lu, Grandmaster's Companion

        --Hunter
        [229438] = true, -- Huntmaster's Fierce Wolfhawk
        [229439] = true, -- Huntmaster's Dire Wolfhawk
        [229386] = true, -- Huntmaster's Loyal Wolfhawk

        -- Warrior
        [229388] = true, -- Battlelord's Bloodthirsty War Wyrm

        -- Shaman
        [231442] = true, -- Farseer's Raging Tempest

        -- Rogue
        [231434] = true, -- Shadowblade's Murderous Omen
        [231523] = true, -- Shadowblade's Lethal Omen
        [231524] = true, -- Shadowblade's Baneful Omen
        [231525] = true, -- Shadowblade's Crimson Omen

        ------------------------------
        -- Alliance ------------------
        ------------------------------

        -- Paladin
        [23214] = true, -- Summon Charger
        [13819] = true, -- Summon Warhorse
        [73629] = true, -- Summon Exarch's Elekk
        [73630] = true, -- Summon Great Exarch's Elekk

        ------------------------------
        -- Horde ---------------------
        ------------------------------

        -- Paladin
        [34767] = true, -- Summon Thalassian Charger
        [34769] = true, -- Summon Thalassian Warhorse
        [69820] = true, -- Summon Sunwalker Kodo
        [69826] = true, -- Summon Great Sunwalker Kodo
    },

    ["World Event"] = {
        sourceType = {7},
        -- Love is in the Air
        [71342] = true, -- Big Love Rocket

        -- Brewfest
        [43899] = true, -- Brewfest Ram
        [43900] = true, -- Swift Brewfest Ram
        [49378] = true, -- Brewfest Riding Kodo
        [49379] = true, -- Great Brewfest Kodo

        -- Hallow's End
        [48025] = true, -- Headless Horseman's Mount

        -- Darkmoon Faire
        [103081] = true, -- Darkmoon Dancing Bear
        [102346] = true, -- Swift Forest Strider
        [228919] = true, -- Darkwater Skate
        [247448] = true, -- Darkmoon Dirigible

        -- Timewalking
        [127165] = true, -- Yu'lei, Daughter of Jade

        -- Call of the Scarab (Micro)
        [239766] = true, -- Blue Qiraji War Tank
        [239767] = true, -- Red Qiraji War Tank
    },

    ["Black Market"] = {
        [17481] = true, -- Rivendare's Deathcharger
        [30174] = true, -- Riding Turtle
        [36702] = true, -- Fiery Warhorse
        [40192] = true, -- Ashes of Al'ar
        [41252] = true, -- Raven Lord
        [46199] = true, -- X-51 Nether-Rocket X-TREME
        [46628] = true, -- Swift White Hawkstrider
        [54753] = true, -- White Polar Bear
        [59567] = true, -- Azure Drake
        [59568] = true, -- Blue Drake
        [59996] = true, -- Blue Proto-Drake
        [60021] = true, -- Plagued Proto-Drake - Black Market only
        [61294] = true, -- Green Proto-Drake
        [63796] = true, -- Mimiron's Head
        [63963] = true, -- Rusted Proto-Drake
        [69395] = true, -- Onyxian Drake
        [72286] = true, -- Invincible
        [74918] = true, -- Wooly White Rhino
        [88742] = true, -- Drake of the North Wind
        [88744] = true, -- Drake of the South Wind
        [88746] = true, -- Vitreous Stone Drake
        [97493] = true, -- Pureblood Fire Hawk
        [101542] = true, -- Flametalon of Alysrazor
        [107842] = true, -- Blazing Drake
        [107845] = true, -- Life-Binder's Handmaiden
        [110039] = true, -- Experiment 12-B
        [127170] = true, -- Astral Cloud Serpent
        [127158] = true, -- Heavenly Onyx Cloud Serpent
        [130965] = true, -- Son of Galleon
        [132036] = true, -- Thundering Ruby Cloud Serpent
        [139442] = true, -- Thundering Cobalt Cloud Serpent
        [139448] = true, -- Clutch of Ji-Kun
        [148476] = true, -- Thundering Onyx Cloud Serpent
    },

    ["Shop"] = {
        sourceType = {10},
    },

    ["Promotion"] = {
        sourceType = {8,9},
        --  8 = promotion
        --  9 = TCG
    },
}

ADDON.MountJournalEnhancedExpansion = {

	["Classic"] = {
        ["minID"] = 0,
        ["maxID"] = 30000,
    },
	
	["The Burning Crusade"] = {
        ["minID"] = 30001,
        ["maxID"] = 50000,
		[58983] = true, -- Big Blizzard Bear
    },
	
	["Wrath of the Lich King"] = {
        ["minID"] = 50001,
        ["maxID"] = 76000,
		[48778] = true, -- Acherus Deathcharger
		[46197] = true, -- X-51 Nether-Rocket
		[46199] = true, -- X-51 Nether-Rocket X-TREME
    },
	
	["Cataclysm"] = {
        ["minID"] = 76001,
        ["maxID"] = 113120,
        [71810] = true, -- Wrathful Gladiator's Frost Wyrm
        [75207] = true, -- Abyssal Seahorse
    },
	
	["Mists of Pandaria"] = {
        ["minID"] = 113121,
        ["maxID"] = 160000,
    },
	
	["Warlords of Draenor"] = {
        ["minID"] = 160001,
        ["maxID"] = 193000,
		[142910] = true, -- Ironbound Wraithcharger
		[194464] = true, -- Eclipse Dragonhawk
		[201098] = true, -- Infinite Timereaver
        [155741] = true, -- Dread Raven - Warlords of Draenor Collector's Edition
    },

    ["Legion"] = {
        ["minID"] = 193001,
        ["maxID"] = 254500,
        [171827] = true, -- Hellfire Infernal
        [171850] = true, -- Llothien Prowler
        [127165] = true, -- Yu'lei, Daughter of Jade
        [189998] = true, -- Illidari Felstalker - Legion Collector's Edition
        [259395] = true, -- Shu-zen, the Divine Sentinel
    },

    ["Battle for Azeroth"] = {
        ["minID"] = 254501,
        ["maxID"] = 999999,
        [213350] = true, -- Frostshard  Infernal
        [237286] = true, -- Dune Scavenger
        [239049] = true, -- Obsidian Krolusk
        [243795] = true, -- Leaping Veinseeker
        [250735] = true, -- Bloodgorged Crawg
        [255695] = true, -- Seabraid Stallion - Battle for Azeroth CE
        [255696] = true, -- Gilded Ravasaurn - Battle for Azeroth CE
    }
}

ADDON.MountJournalEnhancedType = {
    ground = {
        typeIDs = {230, 231, 241, 269, 284}
    },
    flying = {
        typeIDs = {247, 248}
    },
    waterWalking = {
        typeIDs = {269},
    },
    underwater = {
        typeIDs = {232, 254},
        [30174] = true, -- Riding Turtle
        [64731] = true, -- Sea Turtle
    },
    repair = {
        [61425] = true, -- Traveler's Tundra Mammoth
        [122708] = true, -- Grand Expedition Yak
        [264058] = true, -- Mighty Caravan Brutosaur
    },
    passenger = {
        [61425] = true, -- Traveler's Tundra Mammoth
        [122708] = true, -- Grand Expedition Yak
        [61469] = true, -- Grand Ice Mammoth
        [61470] = true, -- Grand Ice Mammoth
        [61465] = true, -- Grand Black War Mammoth
        [61467] = true, -- Grand Black War Mammoth
        [121820] = true, -- Obsidian Nightwing
        [93326] = true, -- Sandstone Drake
        [55531] = true, -- Mechano-Hog
        [60424] = true, -- Mekgineer's Chopper
        [75973] = true, -- X-53 Touring Rocket
        [245723] = true, -- Stormwind Skychaser - Blizzcon 2017
        [245725] = true, -- Orgrimmar Interceptor - Blizzcon 2017
        [264058] = true, -- Mighty Caravan Brutosaur
    },
}

ADDON.MountJournalEnhancedIgnored = {
    [459] = true, -- Gray Wolf
    [468] = true, -- White Stallion
    [578] = true, -- Black Wolf
    [579] = true, -- Red Wolf
    [581] = true, -- Winter Wolf
    [8980] = true, -- Skeletal Horse
    [6896] = true, -- Black Ram
    [10795] = true, -- Ivory Raptor
    [15780] = true, -- Green Mechanostrider
    [18363] = true, -- Riding Kodo
    [25863] = true, -- Black Qiraji Battle Tank
    [26655] = true, -- Black Qiraji Battle Tank
    [28828] = true, -- Nether Drake
    [33630] = true, -- Blue Mechanostrider
    [44317] = true, -- Merciless Nether Drake
    [48954] = true, -- Swift Zhevra
    [59572] = true, -- Black Polar Bear
    [60136] = true, -- Grand Caravan Mammoth
    [60140] = true, -- Grand Caravan Mammoth
    [62048] = true, -- Black Dragonhawk Mount
    [64656] = true, -- Blue Skeletal Warhorse
    [66122] = true, -- Magic Rooster
    [66123] = true, -- Magic Rooster
    [66124] = true, -- Magic Rooster
    [123182] = true, -- White Riding Yak
    [127209] = true, -- Black Riding Yak
    [127213] = true, -- Brown Riding Yak

    -- ghost
    [55164] = true, -- Swift Spectral Gryphon
    [194046] = true, -- Swift Spectral Rylak
    
    -- Legion Unknown Source
    [239363] = true, -- Swift Spectral Hippogryph

    [244457] = true, -- ?
}