local ADDON_NAME, ADDON = ...

ADDON.DB = {}

ADDON.DB.Source = {
    ["Drop"] = {
        -- sourceType = 1
        ------------------------------
        -- Alliance & Horde ----------
        ------------------------------

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
        [261395] = true, -- The Hivemind - hidden mount
        [288438] = true, -- Blackpaw - Darkshore Warfront
        [288495] = true, -- Ashenvale Chimaera - Darkshore Warfront
        [288499] = true, -- Frightened Kodo - Darkshore Warfront
        [288503] = true, -- Umber Nightsaber - Darkshore Warfront
        [288505] = true, -- Kaldorei Nightsaber - Darkshore Warfront
        [291492] = true, -- Rusty Mechanocrawler - Mechagon
        [297157] = true, -- Junkheap Drifter - Mechagon
        [298367] = true, -- Mollie - Vol'dun
        [300149] = true, -- Silent Glider - Nazjatar
        [300150] = true, -- Fabious - Nazjatar
        [312751] = true, -- Clutch of Ha-Li - Vale of Eternal Blossoms
        [315014] = true, -- Ivory Cloud Serpent - Vale of Eternal Blossoms
        [315847] = true, -- Drake of the Four Winds - Uldum
        [315987] = true, -- Mail Muncher - Horrific Visions
        [316275] = true, -- Waste Marauder - Uldum
        [316337] = true, -- Malevolent Drone - Uldum
        [316493] = true, -- Elusive Quickhoof - Vol'dun
        [315427] = true, -- Rajani Warserpent (actually just the scale drops from rare) - Vale of Eternal Blossoms
        [316722] = true, -- Ren's Stalwart Hound - Vale of Eternal Blossoms
        [316723] = true, -- Xinlao - Vale of Eternal Blossoms

        -- Shadowlands
        [312753] = true, -- Hopecrusher Gargon - Venthyr drop: Hopecrusher
        [312762] = true, -- Mawsworn Soulhunter - The Maw - Gorged Shadehound
        [312765] = true, -- Sundancer - Bastion - Sundancer
        [312767] = true, -- Swift Gloomhoof - Ardenweald - Night Mare
        [332252] = true, -- Shimmermist Runner - Ardenweald - Treasure
        [332457] = true, -- Bonehoof Tauralus - necrolord drop: Tahonta
        [332466] = true, -- Armored Bonehoof Tauralus - necrolord drop: Sabriel
        [332478] = true, -- Blisterback Bloodtusk - Maldraxxus - Warbringer Mal'korak
        [332480] = true, -- Gorespine - Maldraxxus - Nerissa Heartless
        [332882] = true, -- Horrid Dredwing - Revendreth - Harika the Horrid
        [332904] = true, -- Harvester's Dredwing - The Maw - Harvester's War Chest
        [332905] = true, -- Endmire Flyer - Revendreth - Famu the Infinite
        [334352] = true, -- Wildseed Cradle - Ardenweald - Treasure
        [334364] = true, -- Spinemaw Gladechewer - Ardenweald - Gormtamer Tizo
        [334366] = true, -- Wild Glimmerfur Prowler - Ardenweald - Valfir the Unrelenting
        [334433] = true, -- Silverwind Larion - Bastion - Treasure
        [336038] = true, -- Callow Flayedwing - Random Egg drop in Maldraxxus
        [336042] = true, -- Hulking Deathroc - Maldraxxus - Violet Mistake
        [336045] = true, -- Predatory Plagueroc - Maldraxxus - Gieger
        [339588] = true, -- Sinrunner Blanchy - treasure quest chain
        [339632] = true, -- Arboreal Gulper - Ardenweald - Humon'gozz
        [344228] = true, -- Battle-Bound Warhound - Theatre of Pain
        [344574] = true, -- Bulbous Necroray - Necroray Egg
        [344575] = true, -- Pestilent Necroray - Necroray Egg
        [344576] = true, -- Infested Necroray - Necroray Egg
        [346141] = true, -- Slime Serpent (secret)
        [354358] = true, -- Darkmaul - Korthia - Darkmaul treasure quest
        [347250] = true, -- Lord of the Corpseflies - Korthia - Fleshwing
        [352309] = true, -- Hand of Bahmethra - The Maw -Tormentors of Torghast
        [352441] = true, -- Wild Hunt Legsplitter - Night Fae Assault
        [352742] = true, -- Undying Darkhound - Undying Army Assault
        [353859] = true, -- Summer Wilderling - Korthia - Escaped Wilderling
        [353877] = true, -- Foresworn Aquilon - Korthia - Wild Worldcracker
        [354353] = true, -- Fallen Charger - The Maw - Fallen Charger
        [354354] = true, -- Hand of Nilganihmaht - The Maw - secret/treasure hunt
        [354357] = true, -- Crimson Shardhide - Korthia - Malbog
        [354360] = true, -- Garnet Razorwing - Korthia - Reliwik the Defiant
        [354361] = true, -- Dusklight Razorwing - Korthia - random eggs
        [354362] = true, -- Maelie the Wanderer - Korthia - treasure quest chain
        [356501] = true, -- Rampaging Mauler - Korthia - Konthrogz the Obliterator
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
        [289639] = true, -- Bruce - Complete the Brawler's Guild Questline
        [299159] = true, -- Scrapforged Mechaspider - Drive It Away Today
        [312754] = true, -- Battle Gargon Vrednic - venthyr campaign quest
        [312759] = true, -- Dreamlight Runestag - night fae campaign quest
        [312761] = true, -- Enchanted Dreamlight Runestag - night fae campaign quest
        [316339] = true, -- Shadowbarb Drone - Uldum
        [316802] = true, -- Springfur Alpaca - Uldum
        [332455] = true, -- War-Bred Tauralus - necrolord campaign quest
        [332462] = true, -- Armored War-Bred Tauralus - necrolord covenant quest
        [332932] = true, -- Crypt Gargon - venthyr campaign quest
        [333027] = true, -- Loyal Gorger - Revendreth
        [334391] = true, -- Phalynx of Courage - kyrian campaign quest
        [334406] = true, -- Eternal Phalynx of Courage - kyrian campaign quest
        [344577] = true, -- Bound Shadehound (secret)

        ------------------------------
        -- Alliance ------------------
        ------------------------------

        [136163] = true, -- Grand Gryphon - Operation: Shieldwall; The Silence
        [259741] = true, -- Honeyback Harvester - Leaving the Hive: Harvester
        [274610] = true, -- Teldrassil Hippogryph - From the Ashes... (BfA PreQuest)
        [300147] = true, -- Deepcoral Snapdragon - Wild Tame

        ------------------------------
        -- Horde ---------------------
        ------------------------------

        [136164] = true, -- Grand Wyvern - Dominance Offensive; Breath of Darkest Shadow
        [272472] = true, -- Undercity Plaguebat - Killer Queen (BfA PreQuest)
        [267270] = true, -- Kua'fon - Down, But Not Out
        [297560] = true, -- Child of Torcali - Wander Not Alone
        [300146] = true, -- Snapdragon Kelpstalker - Good Girl
    },

    ["Vendor"] = {
        -- sourceType = 3
        ------------------------------
        -- Alliance & Horde ----------
        ------------------------------

        [122708] = true, -- Grand Expedition Yak
        [127216] = true, -- Grey Riding Yak
        [127220] = true, -- Blonde Riding Yak
        [171616] = true, -- Witherhide Cliffstomper
        [171628] = true, -- Rocktusk Battleboar - Trader Araanda, Trader Darakk
        [171825] = true, -- Mosshide Riverwallow
        [213115] = true, -- Bloodfang Widow - The Mad Merchant
        [214791] = true, -- Brinedeep Bottom-Feeder - Conjurer Margoss
        [227956] = true, -- Arcadian War Turtle - Xur'ios
        [230844] = true, -- Brawler's Burly Basilisk - brawler guild mount (season 2)
        [259740] = true, -- Green Marsh Hopper
        [266925] = true, -- Siltwing Albatross - Island expedition
        [279474] = true, -- Palehide Direhorn
        [288506] = true, -- Sandy Nightsaber
        [288587] = true, -- Blue Marsh Hopper
        [288589] = true, -- Yellow Marsh Hopper
        [288711] = true, -- Saltwater Seahorse - Island expedition
        [294143] = true, -- X-995 Mechanocat
        [300151] = true, -- Inkscale Deepseeker
        [300153] = true, -- Crimson Tidestallion
        [316340] = true, -- Wicked Swarmer
        [318051] = true, -- Silky Shimmermoth - Ardenweald
        [332243] = true, -- Shadeleaf Runestag - night fae renown vendor
        [332245] = true, -- Winterborn Runestag - night fae feature vendor
        [332246] = true, -- Enchanted Shadeleaf Runestag - night fae renown vendor
        [332248] = true, -- Enchanted Winterborn Runestag - night fae feature vendor
        [332456] = true, -- Plaguerot Tauralus - necrolord renown vendor
        [332464] = true, -- Armored Plaguerot Tauralus - necrolord renown vendor
        [332927] = true, -- Sinfall Gargon - venthyr renown vendor
        [333021] = true, -- Gravestone Battle Armor - venthyr renown vendor
        [334386] = true, -- Phalynx of Humility - kyrian renown vendor
        [334398] = true, -- Phalynx of Purity - kyrian renown vendor
        [334403] = true, -- Eternal Phalynx of Purity - kyrian renown vendor
        [334408] = true, -- Eternal Phalynx of Loyalty - kyrian feature vendor
        [334409] = true, -- Eternal Phalynx of Humility - kyrian feature vendor
        [340503] = true, -- Umbral Scythehorn - night fae feature vendor
        [342667] = true, -- Vibrant Flutterwing - night fae feature vendor

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

        -- Warfront Service Medal
        [288740] = true, -- Priestess' Moonsaber
        [288736] = true, -- Azureshell Krolusk

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

        -- Warfront Service Medal
        [288714] = true, -- Bloodthirsty Dreadwing
        [288735] = true, -- Rubyshell Krolusk
    },

    ["Profession"] = {
        sourceType = { 4 },
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
        [290718] = true, -- Aerial Unit R-21/X - Mechagon
        [299158] = true, -- Mechagon Peacekeeper - Mechagon
        [336036] = true, -- Marrowfang - The Necrotic Wake
        [353263] = true, -- Cartel Master's Gearglider - Tazavesh, the Veiled Market

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
        [289083] = true, -- G.M.O.D. - Battle of Dazar'alor
        [289555] = true, -- Glacial Tidestorm - Battle of Dazar'alor
        [302143] = true, -- Uncorrupted Voidwing - Heroic? N'Zoth, Ny'alotha
        [308814] = true, -- Ny'alotha Allseer - Mythic N'Zoth, Ny'alotha
        [354351] = true, -- Sanctum Gloomcharger - The Nine, Sanctum of Domination
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

        [230401] = true, -- White Hawkstrider -- Talon's Vengeance
        [242305] = true, -- Sable Ruinstrider -- Argussian Reach
        [253004] = true, -- Amethyst Ruinstrider -- Argussian Reach
        [253005] = true, -- Beryl Ruinstrider -- Argussian Reach
        [253006] = true, -- Russet Ruinstrider -- Argussian Reach
        [253007] = true, -- Cerulean Ruinstrider -- Argussian Reach
        [253008] = true, -- Umber Ruinstrider -- Argussian Reach
        [239013] = true, -- Lightforged Warframe -- Army of the Light
        [242881] = true, -- Cloudwing Hippogryph - Farondis cache (paragon)
        [242874] = true, -- Highmountain Elderhorn - Highmountain Supplies (paragon)
        [233364] = true, -- Leywoven Flying Carpet - Nightfallen Cache (paragon)
        [242882] = true, -- Valarjar Stormwing - Valarjar Strongbox (paragon)
        [242875] = true, -- Wild Dreamrunner - Dreamweaver Cache (paragon)
        [254258] = true, -- Blessed Felcrusher - Army of the Light Cache (paragon)
        [254259] = true, -- Avenging Felcrusher - Army of the Light Cache (paragon)
        [254069] = true, -- Glorious Felcrusher - Army of the Light Cache (paragon)

        [294038] = true, -- Royal Snapdragon - Nazjatar (supplies/paragon)
        [299170] = true, -- Rustbolt Resistor -- Rustbolt Resistance
        [316276] = true, -- Wastewander Skyterror -- Uldum Accord

        [327405] = true, -- Colossal Slaughterclaw - Supplies of the Undying Army (paragon)
        [332256] = true, -- Duskflutter Ardenmoth - Wild Hunt
        [332484] = true, -- Lurid Bloodtusk - The Undying Army
        [332923] = true, -- Inquisition Gargon - The Avowed
        [341639] = true, -- Court Sinrunner -- Court of Harvesters
        [342334] = true, -- Gilded Prowler - The Ascended
        [342335] = true, -- Ascended Skymane - Bastion - Bastion supplies
        [342666] = true, -- Amber Ardenmoth - Wild Hunt Supplies (paragon)
        [347251] = true, -- Soaring Razorwing - Korthia - The Archivists' Codex - Tier 6
        [347536] = true, -- Tamed Mauler - Korthia - Supplies of the Archivists' Codex
        [347810] = true, -- Beryl Shardhide - Korthia - Death's Advance Supplies
        [354352] = true, -- Soulbound Gloomcharger - The Maw - Mysterious Gift from Ve'nari
        [354356] = true, -- Amber Shardhide - Korthia - Death's Advance
        [354359] = true, -- Fierce Razorwing - Korthia - Death's Advance Supplies

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
        [275859] = true, -- Dusky Waycrest Gryphon

        -- Proudmoore Admiralty
        [259213] = true, -- Admiralty Stallion
        [275868] = true, -- Proudmoore Sea Scout

        -- Storm's Wake
        [260172] = true, -- Dapple Gray
        [275866] = true, -- Stormsong Coastwatcher

        -- Ankoan
        [292407] = true, -- Ankoan Waveray

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
        [275838] = true, -- Captured Swampstalker
        [275841] = true, -- Expedition Bloodswarmer

        -- Voldunai
        [237287] = true, -- Alabaster Hyena
        [275840] = true, -- Voldunai Dunescraper

        -- Zandalari Empire
        [244712] = true, -- Spectral Pterrorwing
        [275837] = true, -- Cobalt Pterrordax

        -- Unshackled
        [291538] = true, -- Unshackled Waveray
    },

    ["Achievement"] = {
        -- sourceType = 6
        ------------------------------
        -- Alliance & Horde ----------
        ------------------------------

        [60024] = 2144, -- Violet Proto-Drake - What a Long, Strange Trip It's Been
        [60025] = 2143, -- Albino Drake - Leading the Cavalry
        [98204] = 5858, -- Amani Battle Bear - Bear-ly Made It
        [133023] = { 7860, 7862 }, -- Jade Pandaren Kite - We're Going to Need More Saddles
        [142641] = true, -- Brawler's Burly Mushan Beast - I've Got the Biggest Brawls of Them All (Season 1)
        [127169] = { 10355, 10356 }, -- Heavenly Azure Cloud Serpent - Lord of the Reins

        -- Wrath of the Lichking
        [43688] = 430, -- Amani War Bear - no longer available
        [59961] = 2136, -- Red Proto-Drake - Glory of the Hero
        [59976] = 2138, -- Black Proto-Drake - no longer available - Glory of the Raider (25 player)
        [63956] = { 2958, 12401 }, -- Ironbound Proto-Drake - Glory of the Ulduar Raider (25 player)
        [63963] = { 2957, 12401 }, -- Rusted Proto-Drake - Glory of the Ulduar Raider (10 player)
        [72807] = 4603, -- Icebound Frostbrood Vanquisher - Glory of the Icecrown Raider (25 player)
        [72808] = 4602, -- Bloodbathed Frostbrood Vanquisher - Glory of the Icecrown Raider (10 player)

        -- Cataclysm
        [97359] = 5866, -- Flameward Hippogryph - The Molten Front Offensive
        [88331] = 4845, -- Volcanic Stone Drake - Glory of the Cataclysm Hero
        [88335] = 4853, -- Drake of the East Wind - Glory of the Cataclysm Raider
        [88990] = true, -- Dark Phoenix - Guild Glory of the Cataclysm Raider
        [97560] = 5828, -- Corrupted Fire Hawk - Glory of the Firelands Raider
        [107844] = 6169, -- Twilight Harbinger - Glory of the Dragon Soul Raider

        -- Mists of Pandaria
        [124408] = true, -- Thundering Jade Cloud Serpent - Guild Glory of the Pandaria Raider
        [127156] = 6927, -- Crimson Cloud Serpent - Glory of the Pandaria Hero
        [127161] = 6932, -- Heavenly Crimson Cloud Serpent - Glory of the Pandaria Raider
        [136400] = 8124, -- Armored Skyscreamer - Glory of the Thundering Raider
        [148392] = 8454, -- Spawn of Galakras - Glory of the Orgrimmar Raider
        [148396] = { 6398, 6399 }, -- Kor'kron War Wolf - Ahead of the Curve: Garrosh Hellscream (10/25 player)

        -- Challenge Mode
        [129552] = { 6375 }, -- Crimson Pandaren Phoenix - Challenge Conqueror: Silver
        [132117] = { 6375 }, -- Ashen Pandaren Phoenix - Challenge Conqueror: Silver
        [132118] = { 6375 }, -- Emerald Pandaren Phoenix - Challenge Conqueror: Silver
        [132119] = { 6375 }, -- Violet Pandaren Phoenix - Challenge Conqueror: Silver

        -- Warlords of Draenor
        [97501] = { 9598, 9599 }, -- Felfire Hawk - Mountacular
        [170347] = 9550, -- Core Hound - Boldly, You Sought the Power of Ragnaros
        [175700] = 9713, -- Emerald Drake - Awake the Drakes
        [171436] = 8985, -- Gorestrider Gronnling - Glory of the Draenor Raider
        [171627] = true, -- Blacksteel Battleboar - Guild Glory of the Draenor Raider
        [171632] = 9396, -- Frostplains Battleboar - Glory of the Draenor Hero
        [171848] = 8898, -- Challenger's War Yeti - Challenge Warlord: Silver
        [186305] = 10149, -- Infernal Direwolf - Glory of the Hellfire Raider
        [191633] = 10018, -- Soaring Skyterror - Draenor Pathfinder

        -- Legion
        [223814] = 11176, -- Mechanized Lumber Extractor - Remember to Share
        [225765] = 11163, -- Leyfeather Hippogryph - Glory of the Legion Hero
        [215558] = 11066, -- Ratstallion - Underbelly Tycoon
        [193007] = 11180, -- Grove Defiler - Glory of the Legion Raider
        [254260] = 12103, -- Bleakhoof Ruinstrider - ...And Chew Mana Buns
        [253087] = 11987, -- Antoran Gloomhound - Glory of the Argus Raider
        [258022] = 12243, -- Lightforged Felcrusher - Allied Races: Lightforged Draenei
        [258060] = 12245, -- Highmountain Thunderhoof - Allied Races: Highmountain Tauren
        [258845] = 12244, -- Nightborne Manasaber - Allied Races: Nightborne
        [259202] = 12242, -- Starcursed Voidstrider - Allied Races: Void Elf

        -- Battle for Azeroth
        [213350] = { 12931, 12932 }, -- Frostshard Infernal - No Stable Big Enough
        [280729] = { 12933, 12934 }, -- Frenzied Feltalon - A Horde of Hoofbeats
        [263707] = 13206, -- Zandalari Direhorn - Allied Races: Zandalari Troll
        [267274] = 12518, -- Mag'har Direwolf - Allied Races: Mag'har Orc
        [271646] = 12515, -- Dark Iron Core Hound - Allied Races: Dark Iron Dwarf
        [239049] = 12812, -- Obsidian Krolusk - Glory of the Wartorn Hero
        [250735] = 12806, -- Bloodgorged Crawg - Glory of the Uldir Raider
        [279454] = { 12604, 12605 }, -- Conquerer's Scythemaw - Conqueror of Azeroth
        [280730] = 12866, -- Pureheart Courser - 100 Exalted Reputations
        [289101] = 13315, -- DazarDazar'alor Windreaver - Glory of the Dazar'alor Raider
        [282682] = 13163, -- Kul Tiran Charger - Allied Races: Kul Tiran Human
        [290328] = 13250, -- Wonderwing 2.0 - Battle for Azeroth Pathfinder, Part Two
        [292419] = 13687, -- Azshari Bloatray - Glory of the Eternal Raider
        [294039] = 13638, -- Snapback Scuttler - Undersea Usurper
        [296788] = 13541, -- Mechacycle Model W - Mecha-Done
        [294197] = 13931, -- Obsidian Worldbreaker - Memories of Fel, Frost and Fire
        [305182] = 14146, -- Black Serpent of N'Zoth - Through the Depths of Visions
        [305592] = 14013, -- Mechagon Mechanostrider - Allied Races: Mechagnome
        [306423] = 13161, -- Caravan Hyena - Allied Races: Vulpera
        [316343] = 14146, -- Wriggling Parasite - Glory of the Ny'alotha Raider
        [316637] = 14145, -- Awakened Mindborer - Battle for Azeroth Keystone Master: Season Four

        -- Shadowlands
        [318052] = 14520, -- Deathbringer's Flayedwing - Deathbringer
        [332460] = 14751, -- Chosen Tauralus - The Gang's All Here
        [332467] = 14752, -- Armored Chosen Tauralus - Things To Do When You're Dead
        [332903] = 14355, -- Rampart Screecher - Glory of the Nathria Raider
        [340068] = 14532, -- Sintouched Deathwalker - Shadowlands Keystone Master: Season One
        [344578] = 14570, -- Corridor Creeper - Twisting Corridors: Layer 8
        [344659] = 14322, -- Voracious Gorger - Glory of the Shadowlands Hero

        [339956] = 15089, -- Mawsworn Charger - Flawless Master
        [339957] = 15130, -- Hand of Hrestimorak - Glory of the Dominant Raider
        [346554] = 15178, -- Tazavesh Gearglider - Fake It 'Til You Make It
        [354355] = 15064, -- Hand of Salaranga - Breaking the Chains
        [358319] = 15078, -- Soultwisted Deathwalker - Shadowlands Keystone Master: Season Two

        ------------------------------
        -- Alliance ------------------
        ------------------------------

        [68057] = true, -- Swift Alliance Steed - no longer available
        [68187] = true, -- Crusader's White Warhorse - no longer available
        [90621] = true, -- Golden King - Guild Level 25
        [130985] = 6828, -- Pandaren Kite - Pandaren Ambassador, Alliance
        [295386] = 13517, -- Ironclad Frostclaw - Two Sides to Every Tale

        [61996] = 2536, -- Blue Dragonhawk - Mountain o' Mounts, Alliance
        [142478] = 8304, -- Armored Blue Dragonhawk - Mount Parade, Alliance
        [179245] = 9909, -- Chauffeur - Heirloom Hoarder, Alliance
        [308250] = 13928, -- Stormpike Battle Ram - Alterac Valley of Olde

        ------------------------------
        -- Horde ---------------------
        ------------------------------

        [68056] = true, -- Swift Horde Wolf - no longer available
        [68188] = true, -- Crusader's Black Warhorse - no longer available
        [93644] = true, -- Kor'kron Annihilator - Guild Level 25
        [118737] = 6827, -- Pandaren Kite - Pandaren Ambassador, Horde
        [171845] = 9496, -- Warlord's Deathwheel - Warlord's Deathwheel
        [295387] = 13517, -- Bloodflank Charger - Two Sides to Every Tale

        [61997] = 2537, -- Red Dragonhawk - Mountain o' Mounts, Horde
        [142266] = 8302, -- Armored Red Dragonhawk - Mount Parade, Horde
        [179244] = 9909, -- Chauffeur - Heirloom Hoarder, Horde
        [306421] = 13930, -- Frostwolf Snarler - Alterac Valley of Olde
    },

    ["Covenants"] = {
        -- adventures
        [312763] = true, -- Darkwarren Hardshell
        [312776] = true, -- Chittering Animite
        [341766] = true, -- Warstitched Darkhound
        [341776] = true, -- Highwind Darkmane

        [312754] = true, -- Battle Gargon Vrednic - venthyr campaign quest
        [312759] = true, -- Dreamlight Runestag - night fae campaign quest
        [312761] = true, -- Enchanted Dreamlight Runestag - night fae campaign quest
        [312777] = true, -- Silvertip Dredwing - generic covenant feature
        [332243] = true, -- Shadeleaf Runestag - night fae renown vendor
        [332244] = true, -- Wakener's Runestag - night fae covenant feature
        [332245] = true, -- Winterborn Runestag - night fae feature vendor
        [332246] = true, -- Enchanted Shadeleaf Runestag - night fae renown vendor
        [332247] = true, -- Enchanted Wakener's Runestag - night fae feature
        [332248] = true, -- Enchanted Winterborn Runestag - night fae feature vendor
        [332455] = true, -- War-Bred Tauralus - necrolord campaign quest
        [332456] = true, -- Plaguerot Tauralus - necrolord renown vendor
        [332460] = true, -- Chosen Tauralus - necrolord achievement: The Gang's All Here
        [332462] = true, -- Armored War-Bred Tauralus - necrolord covenant quest
        [332464] = true, -- Armored Plaguerot Tauralus - necrolord renown vendor
        [332467] = true, -- Armored Chosen Tauralus - necrolord feature achievement: Things To Do When You're Dead
        [332927] = true, -- Sinfall Gargon - venthyr renown vendor
        [332932] = true, -- Crypt Gargon - venthyr campaign quest
        [332949] = true, -- Desire's Battle Gargon - venthyr feature
        [333021] = true, -- Gravestone Battle Armor - venthyr renown vendor
        [333023] = true, -- Battle Gargon Silessa - venthyr feature
        [334365] = true, -- Pale Acidmaw - generic covenant feature
        [334382] = true, -- Phalynx of Loyalty - kyrian covenant feature
        [334386] = true, -- Phalynx of Humility - kyrian renown vendor
        [334391] = true, -- Phalynx of Courage - kyrian campaign quest
        [334398] = true, -- Phalynx of Purity - kyrian renown vendor
        [334403] = true, -- Eternal Phalynx of Purity - kyrian renown vendor
        [334406] = true, -- Eternal Phalynx of Courage - kyrian campaign quest
        [334408] = true, -- Eternal Phalynx of Loyalty - kyrian feature vendor
        [334409] = true, -- Eternal Phalynx of Humility - kyrian feature vendor
        [336039] = true, -- Gruesome Flayedwing - generic covenant feature
        [336041] = true, -- Bonesewn Fleshroc - necrolord feature
        [336064] = true, -- Dauntless Duskrunner - generic covenant feature
        [340503] = true, -- Umbral Scythehorn - night fae feature vendor
        [343550] = true, -- Battle-Hardened Aquilon - kyrian korthia vendor
        [353856] = true, -- Ardenweald Wilderling - night fae renown 45
        [353857] = true, -- Autumnal Wilderling - night fae renown vendor
        [353858] = true, -- Winter Wilderling - night fae korthia vendor
        [353866] = true, -- Obsidian Gravewing - venthyr renown vendor
        [353872] = true, -- Sinfall Gravewing - venthyr renown 45
        [353873] = true, -- Pale Gravewing - venthyr korthia vendor
        [353875] = true, -- Elysian Aquilon - kirian renown 45
        [353880] = true, -- Ascendant's Aquilon - kyrian renown vendor
        [353883] = true, -- Maldraxxian Corpsefly - necrolord renown 45
        [353884] = true, -- Regal Corpsefly - necrolord renown vendor
        [353885] = true, -- Battlefield Swarmer - necrolord korthia vendor
    },

    ["Island Expedition"] = {
        [254811] = true, -- Squawks
        [278979] = true, -- Surf Jelly
        [279466] = true, -- Twilight Avenger
        [279469] = true, -- Qinsho's Eternal Hound
        [279467] = true, -- Craghorn Chasm-Leaper
        [288711] = true, -- Saltwater Seahorse
        [288712] = true, -- Stonehide Elderhorn
        [288720] = true, -- Bloodgorged Hunter
        [288721] = true, -- Island Thunderscale
        [288722] = true, -- Risen Mare
        [266925] = true, -- Siltwing Albatross
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
        [227994] = true, -- Fierce Gladiator's Storm Dragon - Legion Arena Season 5
        [227995] = true, -- Dominating Gladiator's Storm Dragon - Legion Arena Season 6
        [243201] = true, -- Demonic Gladiator's Storm Dragon - Legion Arena Season 7
        [262022] = true, -- Dread Gladiator's Proto-Drake - Gladiator: Battle for Azeroth Season 1
        [262023] = true, -- Sinister Gladiator's Proto-Drake - Gladiator: Battle for Azeroth Season 2
        [262024] = true, -- Notorious Gladiator's Proto-Drake - Gladiator: Battle for Azeroth Season 3
        [262027] = true, -- Corrupted Gladiator's Proto-Drake - Gladiator: Battle for Azeroth Season 4
        [332400] = true, -- Sinful Gladiator's Soul Eater - Sinful Gladiator: Shadowlands Season 1

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
        [281887] = true, -- Vicious Black Warsaber
        [281888] = true, -- Vicious White Warsaber
        [327407] = true, -- Vicious War Spider
        [348770] = true, -- Vicious War Gorm

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
        [281889] = true, -- Vicious White Bonesteed
        [281890] = true, -- Vicious Black Bonesteed
        [327408] = true, -- Vicious War Spider
        [348769] = true, -- Vicious War Gorm

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
        [290608] = true, -- Crusader's Direhorn

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
        sourceType = { 7 },
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
        [294568] = true, -- Beastlord's Irontusk
        [294569] = true, -- Beastlord's Warwolf

        -- Call of the Scarab (Micro)
        [239766] = true, -- Blue Qiraji War Tank
        [239767] = true, -- Red Qiraji War Tank
    },

    ["Black Market"] = {
        [17481] = true, -- Rivendare's Deathcharger
        [24242] = true, -- Swift Razzashi Raptor - Black Market only
        [24252] = true, -- Swift Zulian Tiger - Black Market only
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
        [61465] = true, -- Grand Black War Mammoth
        [61467] = true, -- Grand Black War Mammoth
        [63796] = true, -- Mimiron's Head
        [63963] = true, -- Rusted Proto-Drake
        [69395] = true, -- Onyxian Drake
        [72286] = true, -- Invincible
        [74918] = true, -- Wooly White Rhino
        [88742] = true, -- Drake of the North Wind
        [88744] = true, -- Drake of the South Wind
        [88746] = true, -- Vitreous Stone Drake
        [96491] = true, -- Armored Razzashi Raptor - Zul'Gurub, Bloodlord Mandokir
        [96499] = true, -- Swift Zulian Panther - Zul'Gurub, High Priestess Kilnara
        [97493] = true, -- Pureblood Fire Hawk
        [101542] = true, -- Flametalon of Alysrazor
        [107842] = true, -- Blazing Drake
        [107845] = true, -- Life-Binder's Handmaiden
        [110039] = true, -- Experiment 12-B
        [127170] = true, -- Astral Cloud Serpent
        [127158] = true, -- Heavenly Onyx Cloud Serpent
        [130965] = true, -- Son of Galleon
        [132036] = true, -- Thundering Ruby Cloud Serpent
        [136471] = true, -- Spawn of Horridon - Throne of Thunder, Horridon
        [138423] = true, -- Cobalt Primordial Direhorn- Isle of Giants, Oondasta
        [138424] = true, -- Amber Primordial Direhorn
        [138425] = true, -- Slate Primordial Direhorn
        [138426] = true, -- Jade Primordial Direhorn
        [139442] = true, -- Thundering Cobalt Cloud Serpent
        [139448] = true, -- Clutch of Ji-Kun
        [148417] = true, -- Kor'kron Juggernaut - Siege of Orgrimmar, Garrosh Hellscream
        [148476] = true, -- Thundering Onyx Cloud Serpent
        [170347] = true, -- Core Hound - Black Market only
        [171621] = true, -- Ironhoof Destroyer - Blackrock Foundry, Blackhand
        [171828] = true, -- Solar Spirehawk - Rukhmar
        [182912] = true, -- Felsteel Annihilator - Hellfire Citadel, Archimonde
        [171827] = true, -- Hellfire Infernal - The Nighthold, Gul'dan (Mythic)
        [213134] = true, -- Felblaze Infernal - The Nighthold, Gul'dan
        [223018] = true, -- Fathom Dweller - World Boss, Kosumoth the Hungering
        [232519] = true, -- Abyss Worm - Tomb of Sargeras, Mistress Sassz'ine
        [233364] = true, -- Leywoven Flying Carpet - Nightfallen Cache (paragon)
        [242882] = true, -- Valarjar Stormwing - Valarjar Strongbox (paragon)
        [243651] = true, -- Shackled Ur'zul - Antorus, Argus Mythic
        [243652] = true, -- Vile Fiend
        [264058] = true, -- Mighty Caravan Brutosaur
    },

    ["Shop"] = {
        sourceType = { 10 },
    },

    ["Promotion"] = {
        sourceType = { 8, 9 },
        --  8 = promotion
        --  9 = TCG

        [294197] = true, -- Obsidian Worldbreaker - 15th Anniversary
    },
}

ADDON.DB.FeatsOfStrength = {
    -- from https://wowhead.com/mount-feats-of-strength (58)
    -- spellId => AchievementId
    [17229] = 3356, -- Winterspring Frostsaber
    [17481] = 729, -- Deathcharger's Reins
    [24242] = 881, -- Swift Razzashi Raptor
    [24252] = 880, -- Swift Zulian Tiger
    [26656] = 416, -- Scarab Lord
    [36702] = 882, -- Fiery Warhorse's Reins
    [37015] = 886, -- Swift Nether Drake
    [40192] = 885, -- Ashes of Al'ar
    [41252] = 883, -- Reins of the Raven Lord
    [44744] = 887, -- Merciless Nether Drake
    [46628] = 884, -- Swift White Hawkstrider
    [48025] = 980, -- The Horseman's Reins
    [49193] = 888, -- Vengeful Nether Drake
    [49322] = 1436, -- Friends In High Places
    [58615] = 2316, -- Brutal Nether Drake
    [61465] = 2081, -- Grand Black War Mammoth
    [61467] = 2081, -- Grand Black War Mammoth
    [63796] = 4626, -- And I'll Form the Head!
    [64659] = 3357, -- Venomhide Ravasaur
    [64927] = 3096, -- Deadly Gladiator's Frost Wyrm
    [65439] = 3756, -- Furious Gladiator's Frost Wyrm
    [67336] = 3757, -- Relentless Gladiator's Frost Wyrm
    [71342] = 4627, -- Big Love Rocket
    [71810] = 4600, -- Wrathful Gladiator's Frost Wyrm
    [72286] = 4625, -- Invincible's Reins
    [75973] = 4832, -- Friends In Even Higher Places
    [88750] = 5767, -- Scourer of the Eternal Sands
    [101282] = 6003, -- Vicious Gladiator's Twilight Drake
    [101821] = 6322, -- Ruthless Gladiator's Twilight Drake
    [121820] = 8213, -- Friends In Places Higher Yet
    [124550] = 6741, -- Cataclysmic Gladiator's Twilight Drake
    [138640] = 8092, -- Bone-White Primal Raptor
    [139407] = 8216, -- Malevolent Gladiator's Cloud Serpent
    [148618] = 8678, -- Tyrannical Gladiator's Cloud Serpent
    [148619] = 8705, -- Grievous Gladiator's Cloud Serpent
    [148620] = 8707, -- Prideful Gladiator's Cloud Serpent
    [149801] = 8794, -- Friends In Places Even Higher Than That
    [171847] = 9925, -- Friends In Places Yet Even Higher Than That
    [186828] = 9229, -- Primal Gladiator's Felblood Gronnling
    [189043] = 10137, -- Wild Gladiator's Felblood Gronnling
    [189044] = 10146, -- Warmongering Gladiator's Felblood Gronnling
    [227986] = 10999, -- Vindictive Gladiator's Storm Dragon
    [227988] = 11000, -- Fearless Gladiator's Storm Dragon
    [227989] = 11001, -- Cruel Gladiator's Storm Dragon
    [227991] = 11002, -- Ferocious Gladiator's Storm Dragon
    [227994] = 13450, -- Fierce Gladiator's Storm Dragon
    [227995] = 12139, -- Dominating Gladiator's Storm Dragon
    [239767] = 424, -- Why? Because It's Red
    [243201] = 12140, -- Demonic Gladiator's Storm Dragon
    [262022] = 13093, -- Dread Gladiator's Proto-Drake
    [262023] = 13202, -- Sinister Gladiator's Proto-Drake
    [262024] = 13632, -- Notorious Gladiator's Proto-Drake
    [262027] = 13958, -- Corrupted Gladiator's Proto-Drake
    [264058] = 14183, -- Mighty Caravan Brutosaur
    [332400] = 14816, -- Sinful Gladiator's Soul Eater
    [353036] = 14999, -- Unchained Gladiator's Soul Eater
}

ADDON.DB.Expansion = {

    [0] = { -- Classic
        ["minID"] = 0,
        ["maxID"] = 30000,
    },

    [1] = { -- The Burning Crusade
        ["minID"] = 30001,
        ["maxID"] = 50000,
        [58983] = true, -- Big Blizzard Bear
    },

    [2] = { -- Wrath of the Lich King
        ["minID"] = 50001,
        ["maxID"] = 76000,
        [48778] = true, -- Acherus Deathcharger
        [46197] = true, -- X-51 Nether-Rocket
        [46199] = true, -- X-51 Nether-Rocket X-TREME
    },

    [3] = { -- Cataclysm
        ["minID"] = 76001,
        ["maxID"] = 113120,
        [71810] = true, -- Wrathful Gladiator's Frost Wyrm
        [75207] = true, -- Abyssal Seahorse
    },

    [4] = { -- Mists of Pandaria
        ["minID"] = 113121,
        ["maxID"] = 160000,
    },

    [5] = { -- Warlords of Draenor
        ["minID"] = 160001,
        ["maxID"] = 193000,
        [142910] = true, -- Ironbound Wraithcharger
        [194464] = true, -- Eclipse Dragonhawk
        [201098] = true, -- Infinite Timereaver
        [155741] = true, -- Dread Raven - Warlords of Draenor Collector's Edition
    },

    [6] = { -- Legion
        ["minID"] = 193001,
        ["maxID"] = 254500,
        [171827] = true, -- Hellfire Infernal
        [171850] = true, -- Llothien Prowler
        [127165] = true, -- Yu'lei, Daughter of Jade
        [189998] = true, -- Illidari Felstalker - Legion Collector's Edition
        [259395] = true, -- Shu-zen, the Divine Sentinel
    },

    [7] = { -- Battle for Azeroth
        ["minID"] = 254501,
        ["maxID"] = 320000,
        [213350] = true, -- Frostshard  Infernal
        [237286] = true, -- Dune Scavenger
        [237287] = true, -- Alabaster Hyena
        [239049] = true, -- Obsidian Krolusk
        [243795] = true, -- Leaping Veinseeker
        [250735] = true, -- Bloodgorged Crawg
        [255695] = true, -- Seabraid Stallion - Battle for Azeroth CE
        [255696] = true, -- Gilded Ravasaurn - Battle for Azeroth CE
        [326390] = true, -- Steamscale Incinerator
    },

    [8] = { -- Shadowlands
        ["minID"] = 320001,
        ["maxID"] = 999999,
        [307932] = true, -- Ensorcelled Everwyrm
        [318051] = true, -- Silky Shimmermoth
        [318052] = true, -- Deathbringer's Flayedwing
        [312776] = true, -- Chittering Animite
        [312765] = true, -- Sundancer
        [312767] = true, -- Swift Gloomhoof
        [312763] = true, -- Darkwarren Hardshell
        [312762] = true, -- Mawsworn Soulhunter
        [312761] = true, -- Enchanted Dreamlight Runestag
        [312759] = true, -- Dreamlight Runestag
        [312754] = true, -- Battle Gargon Vrednic
        [312753] = true, -- Hopecrusher Gargon
        [312777] = true, -- Silvertip Dredwing
    }
}

ADDON.DB.Type = {
    -- https://wow.gamepedia.com/API_C_MountJournal.GetMountInfoExtraByID
    ground = {
        typeIDs = { 230, 231, 241, 269, 284 },
    },
    flying = {
        typeIDs = { 247, 248, 398 },
    },
    underwater = {
        typeIDs = { 231, 232, 254 },
    },
    repair = {
        [61425] = true, -- Traveler's Tundra Mammoth (Alliance)
        [61447] = true, -- Traveler's Tundra Mammoth (Horde)
        [122708] = true, -- Grand Expedition Yak
        [264058] = true, -- Mighty Caravan Brutosaur
    },
    passenger = {
        [61425] = true, -- Traveler's Tundra Mammoth (Alliance)
        [61447] = true, -- Traveler's Tundra Mammoth (Horde)
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
        [261395] = true, -- The Hivemind
        [264058] = true, -- Mighty Caravan Brutosaur
        [307256] = true, -- Explorer's Jungle Hopper
        [307263] = true, -- Explorer's Dunetrekker
    },
}

-- used as filter for debug output
-- mountId as Index
ADDON.DB.Ignored = {
    [7] = true, -- Gray Wolf
    [8] = true, -- White Stallion
    [12] = true, -- Black Wolf
    [13] = true, -- Red Wolf
    [15] = true, -- Winter Wolf
    [22] = true, -- Black Ram
    [28] = true, -- Skeletal Horse
    [32] = true, -- Tiger
    [35] = true, -- Ivory Raptor
    [43] = true, -- Green Mechanostrider
    [70] = true, -- Riding Kodo
    [116] = true, -- Black Qiraji Battle Tank
    [121] = true, -- Black Qiraji Battle Tank
    [123] = true, -- Nether Drake
    [145] = true, -- Blue Mechanostrider
    [206] = true, -- Merciless Nether Drake
    [251] = true, -- Black Polar Bear
    [273] = true, -- Grand Caravan Mammoth
    [274] = true, -- Grand Caravan Mammoth
    [293] = true, -- Black Dragonhawk Mount
    [308] = true, -- Blue Skeletal Warhorse
    [462] = true, -- White Riding Yak
    [484] = true, -- Black Riding Yak
    [485] = true, -- Brown Riding Yak

    -- ghost
    [238] = true, -- Swift Spectral Gryphon
    [776] = true, -- Swift Spectral Rylak
    [934] = true, -- Swift Spectral Hippogryph
    [1269] = true, -- Swift Spectral Fathom Ray
    [1270] = true, -- Swift Spectral Magnetocraft
    [1271] = true, -- Swift Spectral Armored Gryphon
    [1272] = true, -- Swift Spectral Pterrordax
}