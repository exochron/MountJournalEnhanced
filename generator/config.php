<?php

return [
    'battle.net' => [
        'clientId'     => $_ENV['BATTLENET_CLIENTID'],
        'clientSecret' => $_ENV['BATTLENET_CLIENTSECRET'],
    ],

    'missingMounts' => [ // missing in battle net response
        266925 => new \MJEGenerator\Mount('Siltwing Albatross', 266925, 0, 0, 'inv_vulturemount_alabatrosswhite'),
        290133 => new \MJEGenerator\Mount('Vulpine Familiar', 290133),
    ],

    'ignored'   => [
        0, // ?
        459, // Gray Wolf
        468, // White Stallion
        471, // Palamino
        578, // Black Wolf
        579, // Red Wolf
        581, // Winter Wolf
        3363, // Nether Drake
        6896, // Black Ram
        6897, // Blue Ram
        8980, // Skeletal Horse
        10788, // Leopard
        10790, // Tiger
        10792, // Spotted Panther
        10795, // Ivory Raptor
        10798, // Obsidian Raptor
        15780, // Green Mechanostrider
        15781, // Steel Mechanostrider
        16058, // Primal Leopard
        16059, // Tawny Sabercat
        16060, // Golden Sabercat
        17455, // Purple Mechanostrider
        17456, // Red and Blue Mechanostrider
        17458, // Fluorescent Green Mechanostrider
        18363, // Riding Kodo
        23220, // Swift Dawnsaber
        24576, // Chromatic Mount
        25675, // Reindeer
        25858, // Reindeer
        25859, // Reindeer
        25863, // Black Qiraji Battle Tank
        26332, // Summon Mouth Tentacle
        26655, // Black Qiraji Battle Tank
        28828, // Nether Drake
        29059, // Naxxramas Deathcharger
        30829, // Kessel's Elekk
        31973, // Kessel's Elekk
        32345, // Peep the Phoenix Mount
        33630, // Blue Mechanostrider
        34407, // Great Elite Elekk
        40212, // Dragonmaw Nether Drake
        42667, // Flying Broom
        42668, // Swift Flying Broom
        43810, // Frost Wyrm
        43880, // Ramstein's Swift Work Ram
        43883, // Rental Racing Ram
        44317, // Merciless Nether Drake
        44824, // Flying Reindeer
        44825, // Flying Reindeer
        44827, // Flying Reindeer
        47037, // Swift War Elekk
        47977, // Magic Broom
        48954, // Swift Zhevra
        49908, // Pink Elekk
        50281, // Black Warp Stalker
        50869, // Brewfest Kodo
        51960, // Frost Wyrm Mount
        55164, // Swift Spectral Gryphon
        59572, // Black Polar Bear
        59573, // Brown Polar Bear
        60136, // Grand Caravan Mammoth
        60140, // Grand Caravan Mammoth
        61289, // Borrowed Broom
        62048, // Black Dragonhawk Mount
        64656, // Blue Skeletal Warhorse
        64681, // Loaned Gryphon
        64761, // Loaned Wind Rider
        66122, // Magic Rooster
        66123, // Magic Rooster
        66124, // Magic Rooster
        68930, // Brood of Onyxia
        68768, // Little White Stallion
        68769, // Little Ivory Raptor
        75387, // Tiny Mooncloth Carpet
        79361, // Twilight Phoenix
        86579, // Wooden Raft
        87840, // Running Wild
        89520, // Goblin Mini Hotrod
        97390, // Hitch Horse
        101641, // Tarecgosa's Visage
        103170, // Helper's Reindeer
        104515, // Darkmoon Pony
        104517, // Khaz Modan Ram
        123160, // Crimson Riding Crane
        123182, // White Riding Yak
        127178, // Jungle Riding Crane
        127180, // Albino Riding Crane
        127272, // Orange Water Strider
        127274, // Jade Water Strider
        127278, // Golden Water Strider
        127209, // Black Riding Yak
        127213, // Brown Riding Yak
        128971, // Shado-Pan Tiger
        130678, // Unruly Behemoth
        130730, // Kafa-Crazed Goat
        130895, // Rampaging Yak
        134854, // Cloud Mount
        134931, // Darkmoon Strider
        145133, // Moonfang
        147595, // Stormcrow
        148626, // Furious Ashhide Mushan
        153675, // Darkmoon Race Rocketeer
        153722, // Darkmoon Race Strider (Basic)
        164222, // Frostwolf War Wolf
        164601, // Perplexed Pony
        165803, // Telaari Talbuk
        171618, // Ancient Leatherhide
        174004, // Spirit of Shinri
        176759, // GorenLog Roller
        176762, // Iron Star Roller
        179251, // Darkmoon Race Powermonger
        179252, // Darkmoon Race Rocketeer (Advanced)
        179256, // Darkmoon Race Wanderluster
        179283, // Darkmoon Race Strider (Standard)
        179750, // Darkmoon Race Strider (Advanced)
        194046, // Swift Spectral Rylak
        203853, // Adventurer's Darter
        212421, // Storm's Reach Cliffwalker
        213147, // Storm's Reach Worg
        218815, // Storm's Reach Greatstag
        218891, // Storm's Reach Warbear
        218964, // Storm's Reach Squallhunter
        220480, // Ebon Blade Deathcharger
        220484, // Nazgrim's Deathcharger
        220491, // Mograine's Deathcharger
        220489, // Whitemane's Deathcharger
        220488, // Trollbane's Deathcharger
        220504, // Silver Hand Charger
        220505, // Silver Hand Kodo
        220506, // Silver Hand Elekk
        220507, // Silver Hand Charger
        230894, // Boastful Pony
        230904, // Boastful Wolf
        237285, // Hyena Mount White (PH)
        239363, // Swift Spectral Hippogryph
        239769, // Purple Qiraji War Tank
        244457, // Default AI Mount Record
        244712, // Armored Ebony Pterrordax (PH)
        254471, // Valorous Charger
        254474, // Golden Charger
        254473, // Vigilant Charger
        254472, // Vengeful Charger
        254545, // Baarut the Brisk
        254812, // PH Giant Parrot (Blue)
        256121, // PH Goblin Hovercraft (Blue)
        256123, // Xiwyllag ATV
        256124, // PH Goblin Hovercraft (Red)
        256125, // PH Goblin Hovercraft (Green)
        259741, // PH Bee
        260176, // Kul Tiras Horse (PH)
        275838, // Armored Orange Pterrordax (PH)
        275840, // Armored Albino Pterrordax (PH)
        275859, // Dusky Waycrest Gryphon (PH)
        275868, // Proudmoore Sea Scout (PH)
        275866, // Stormsong Coastwatcher (PH)
        278656, // Spectral Phoenix
        278966, // Tempestuous Skystallion
        281296, // Silver Hand Charger
    ],

    // family based on http://www.warcraftmounts.com/gallery.php + https://wow.gamepedia.com/Beast
    'familyMap' => [
        'Amphibian'    => [
            'Toads'  => ['Toads'],
            'Crawgs' => ['Crawgs'],
        ],
        'Arachnids'    => [
            'Blood Ticks' => ['Bloodswarmers'],
            'Scorpions'   => ['Scorpions', 'Mechanical Scorpions'],
            'Spiders'     => ['Spiders'],
        ],
        'Bats'         => ['Bats', 'Felbats'],
        'Birds'        => [
            'Albatross'          => [
                'wcm'   => ['Birds'],
                'icons' => ['alabatross', 'albatross'],
            ],
            'Tallstriders'       => ['Tallstriders'],
            'Cranes'             => ['Cranes'],
            'Hawkstriders'       => ['Hawkstriders'],
            'Chickens'           => ['Chickens'],
            'Talonbirds'         => ['Talonbirds'],
            'Dread Ravens'       => [
                'wcm'   => ['Birds'],
                'icons' => ['ravenlord', 'dreadraven'],
            ],
            'Crows'              => [
                'wcm'   => ['Birds'],
                'icons' => ['roguemount', 'arcaneraven', 'suncrown'],
            ],
            'Parrots'            => [
                'wcm'   => ['Birds'],
                'icons' => ['parrot'],
            ],
            'Pandaren Phoenixes' => [
                'wcm'   => ['Birds'],
                'icons' => ['pandarenphoenix', 'ji-kun'],
            ],
            'Phoenixes'          => ['Phoenixes'],
        ],
        'Bovids'       => [
            'Clefthooves'  => ['Clefthooves'],
            'Goats'        => ['Goats'],
            'Rams'         => ['Rams'],
            'Ruinstriders' => [
                'wcm'   => ['Talbuks'],
                'icons' => ['argustalbukmount'],
            ],
            'Talbuks'      => [
                'wcm'   => ['Talbuks'],
                'icons' => ['foot_centaur', 'talbukdraenor',],
            ],
            'Yaks'         => ['Yaks'],
        ],
        'Cats'         => [
            'Stone Cats' => [
                'wcm' => ['Flying Stone Cats'],
                98727 => 'Winged Guardian',
            ],
            'Lions'      => [
                'wcm'   => ['Cats'],
                'icons' => ['lion', 'goldenking',],
                98727   => 'Winged Guardian',
            ],
            'Sabers'     => [
                'wcm'   => ['Cats'],
                'icons' => ['blackpanther', 'whitetiger', 'pinktiger', 'nightsaber2', 'saber3mount'],
            ],
            'Manasabers' => [
                'wcm'   => ['Cats'],
                'icons' => ['suramarmount', 'nightborneracial',],
                180545  => "Mystic Runesaber",
            ],
            'Tigers'     => [
                'wcm'   => ['Cats', 'Undead Cats'],
                'icons' => ['monkmount', 'spectraltiger', 'siberiantiger', 'warnightsaber'],
                24252   => "Swift Zulian Tiger",
            ],
            'Others'     => ['Flamesabers', 'Panthara', 'Felsabers'],
        ],
        'Dinosaurs'    => [
            'Brutosaurs'   => ['Brutosaurs'],
            'Pterrordaxes' => ['Pterrordaxes'],
            'Direhorns'    => ['Direhorns'],
            'Falcosaurs'   => [
                'wcm'   => ['Raptors'],
                'icons' => ['falcosauro'],
            ],
            'Raptors'      => [
                'wcm'   => ['Raptors', 'Undead Raptors'],
                'icons' => ['raptor'],
            ],
        ],
        'Drakes'       => [
            'Cloud Serpents' => ['Cloud Serpents'],
            'Drakes'         => ['Drakes', 'Onyxian Drakes'],
            'Nether Drakes'  => ['Nether Drakes'],
            'Stone Drakes'   => ['Stone Drakes'],
            'Wind Drakes'    => ['Wind Drakes'],
            'Grand Drakes'   => ['Grand Drakes'],
            'Proto-Drakes'   => ['Proto-Drakes'],
            'Undead Drakes'  => ['Undead Drakes'],
            'Others'         => ['Sinuous Drakes', 'Fey Drakes'],
        ],
        'Demons'       => [
            'Demonic Steeds' => ['Demonic Steeds'],
            'Demonic Hounds' => ['Felstalkers', 'Vile Fiends', 'Antoran Hounds', 'Flying Felstalkers'],
            'Felsabers'      => ['Felsabers'],
            'Infernals'      => ['Infernals'],
            "Ur'zul"         => ["Ur'zul"],
        ],
        'Dragonhawks'  => ['Dragonhawks'],
        'Rylaks'       => ['Rylaks'],
        'Elementals'   => [
            'Elementals'   => ['Elementals'],
            'Core Hounds'  => ['Core Hounds'],
            'Sabers'       => ['Flamesabers'],
            'Phoenixes'    => ['Phoenixes'],
            'Stone Drakes' => ['Stone Drakes'],
            'Wind Drakes'  => ['Wind Drakes'],
        ],
        'Feathermanes' => [
            'Gryphons'    => ['Gryphons', 'Undead Gryphons'],
            'Hippogryphs' => ['Hippogryphs'],
            'Wolfhawks'   => ['Wolfhawks'],
            'Wyverns'     => ['Wind Riders', 'Undead Wind Riders'],
        ],
        'Fish'         => [
            'Fish'      => ['Fish'],
            'Stingrays' => ['Stingrays'],
            'Seahorses' => ['Seahorses'],
        ],
        'Horses'       => [
            'Chargers'          => [
                'wcm'   => ['Horses'],
                'icons' => ['_paladinmount_', '_charger', 'nature_swiftness', 'alliancepvpmount', 'vicioushorse', 'paladin_divinesteed'],
                67466   => "Argent Warhorse",
                68187   => "Crusader's White Warhorse",
                68188   => "Crusader's Black Warhorse",
            ],
            'Demonic Steeds'    => ['Demonic Steeds'],
            'Steeds'            => [
                'wcm'   => ['Horses'],
                'icons' => ['ridinghorse', 'nightmarehorse'],
            ],
            'Mountain Horses'   => [
                'wcm'   => ['Horses'],
                'icons' => ['dressedhorse', 'horse3'],
                103195  => "Mountain Horse",
                103196  => "Swift Mountain Horse",
            ],
            'Horned Steeds'     => ['Horned Steeds', 'Windsteeds'],
            'Flying Steeds'     => ['Flying Steeds', 'Windsteeds'],
            'Undead Steeds'     => ['Undead Steeds'],
            'Mechanical Steeds' => ['Mechanical Steeds'],
        ],
        'Humanoids'    => [
            'Gronnlings' => ['Gronnlings'],
            'Yetis'      => ['Yeti'],
        ],
        'Insects'      => [
            'Krolusks'       => ['Krolusks'],
            'Silithids'      => [
                'wcm'  => ['Silithids',],
                239767 => 'Red Qiraji War Tank',
                239766 => 'Blue Qiraji War Tank',
            ],
            'Ravagers'       => ['Ravagers'],
            'Water Striders' => ['Water Striders'],
        ],
        'Jellyfish'    => ['Fathom Dwellers', 'Hiveminds'],
        'Carnivorans'  => [
            'Bears'  => ['Bears'],
            'Hounds' => ['Dogs', 'Core Hounds', 'Felstalkers'],
            'Quilen' => ['Quilen'],
            'Foxes'  => [
                'wcm'  => ['Foxes',],
                290133 => 'Vulpine Familiar',
            ],
            'Hyenas' => ['Hyenas'],
        ],
        'Reptiles'     => [
            'Kodos'        => [
                'wcm' => ['Kodos',],
                49378 => 'Brewfest Riding Kodo',
            ],
            'Mushan'       => ['Mushan'],
            'Basilisks'    => ['Basilisks'],
            'Sea Serpents' => ['Sea Serpents'],
            'Turtles'      => ['Dragon Turtles', 'Sea Turtles', 'Turtles'],
        ],
        'Rats'         => ['Rats'], //maybe Rodents later
        'Rays'         => [
            'Nether Rays' => ['Nether Rays'],
            'Mana Rays'   => ['Mana Rays'],
            'Stingrays'   => ['Stingrays'],
        ],
        'Ungulates'    => [
            'Boars'       => ['Boars'],
            'Camels'      => ['Camels'],
            'Elekks'      => ['Elekks'],
            'Mammoths'    => ['Mammoths'],
            'Moose'       => ['Elderhorns'],
            'Rhinos'      => ['Rhinos'],
            'Riverbeasts' => ['Riverbeasts'],
        ],
        'Vehicles'     => [
            'Mechanostriders' => ['Mechanostriders'],
            'Scorpions'       => ['Mechanical Scorpions'],
            'Steeds'          => ['Mechanical Steeds'],
            'Motorcycles'     => ['Motorcycles'],
            'Airships'        => ['Skyships', 'Zeppelins', 'Flying Ships'],
            'Gyrocopters'     => ['Gyrocopters'],
            'Mecha-suits'     => ['Flying Mecha-suits'],
            'Rockets'         => ['Rockets'],
            'Carpets'         => ['Flying Carpets'],
            'Kites'           => ['Kites'],
            'Discs'           => ['Discs'],
            'Assault Wagons'  => ['Assault Wagons'],
        ],
        'Wolves'       => [
            'Dire Wolves'   => [
                'wcm'   => ['Wolves'],
                'icons' => ['wolfdraenor', 'orcclanworg'],
                171851  => "Garn Nighthowl",
            ],
            'War Wolves'    => [
                'wcm'   => ['Wolves'],
                'icons' => ['hordepvpmount'],
            ],
            'Wolves'        => [
                'wcm'   => ['Wolves'],
                'icons' => ['direwolf'],
                16081   => "Arctic Wolf",
            ],
            'Undead Wolves' => ['Undead Wolves'],
        ],
    ],
];