<?php

return [
    'battle.net' => [
        'apiKey' => $_ENV['BATTLENET_APIKEY'],
    ],

    'missingIds' => [ // missing in battle net response
        272770, // The Dreadwake
    ],

    'ignored' => [
        459,// Gray Wolf
        468,// White Stallion
        578,// Black Wolf
        579,// Red Wolf
        581,// Winter Wolf
        8980,// Skeletal Horse
        6896,// Black Ram
        10795,// Ivory Raptor
        15780,// Green Mechanostrider
        18363,// Riding Kodo
        25863,// Black Qiraji Battle Tank
        26655,// Black Qiraji Battle Tank
        28828,// Nether Drake
        33630,// Blue Mechanostrider
        44317,// Merciless Nether Drake
        48954,// Swift Zhevra
        59572,// Black Polar Bear
        60136,// Grand Caravan Mammoth
        60140,// Grand Caravan Mammoth
        62048,// Black Dragonhawk Mount
        64656,// Blue Skeletal Warhorse
        66122,// Magic Rooster
        66123,// Magic Rooster
        66124,// Magic Rooster
        123182,// White Riding Yak
        127209,// Black Riding Yak
        127213,// Brown Riding Yak
        55164,// Swift Spectral Gryphon
        194046,// Swift Spectral Rylak
        239363,// Swift Spectral Hippogryph
    ],

    // family based on http://www.warcraftmounts.com/gallery.php + https://wow.gamepedia.com/Beast
    'familyMap' => [
        'Arachnids' => [
            'Blood Ticks' => ['Bloodswarmers'],
            'Scorpions' => ['Scorpions', 'Mechanical Scorpions'],
            'Spiders' => ['Spiders'],
        ],
        'Bats' => ['Bats', 'Felbats'],
        'Birds' => [
            'Tallstriders' => ['Tallstriders'],
            'Cranes' => ['Cranes'],
            'Hawkstriders' => ['Hawkstriders'],
            'Chickens' => ['Chickens'],
            'Talonbirds' => ['Talonbirds'],
            'Dread Ravens' => [
                'wcm' => ['Birds'],
                'icons' => ['ravenlord', 'dreadraven'],
            ],
            'Crows' => [
                'wcm' => ['Birds'],
                'icons' => ['roguemount', 'arcaneraven', 'suncrown'],
            ],
            'Parrots' => [
                'wcm' => ['Birds'],
                'icons' => ['parrot'],
            ],
            'Pandaren Phoenixes' => [
                'wcm' => ['Birds'],
                'icons' => ['pandarenphoenix', 'ji-kun'],
            ],
            'Phoenixes' => ['Phoenixes'],
        ],
        'Bovids' => [
            'Clefthooves' => ['Clefthooves'],
            'Goats' => ['Goats'],
            'Rams' => ['Rams'],
            'Ruinstriders' => [
                'wcm' => ['Talbuks'],
                'icons' => ['argustalbukmount'],
            ],
            'Talbuks' => [
                'wcm' => ['Talbuks'],
                'icons' => ['foot_centaur', 'talbukdraenor',],
            ],
            'Yaks' => ['Yaks'],
        ],
        'Cats' => [
            'Stone Cats' => [
                'wcm' => ['Flying Stone Cats'],
                98727 => 'Winged Guardian',
            ],
            'Lions' => [
                'wcm' => ['Cats'],
                'icons' => ['lion', 'goldenking',],
                98727 => 'Winged Guardian',
            ],
            'Sabers' => [
                'wcm' => ['Cats'],
                'icons' => ['blackpanther', 'whitetiger', 'pinktiger'],
            ],
            'Manasabers' => [
                'wcm' => ['Cats'],
                'icons' => ['suramarmount', 'nightborneracial',],
                180545 => "Mystic Runesaber",
            ],
            'Tigers' => [
                'wcm' => ['Cats', 'Undead Cats'],
                'icons' => ['monkmount', 'spectraltiger', 'siberiantiger', 'warnightsaber'],
                24252 => "Swift Zulian Tiger",
            ],
            'Others' => ['Flamesabers', 'Panthara', 'Felsabers'],
        ],
        'Crawgs' => ['Crawgs'],
        'Dinosaurs' => [
            'Brutosaurs' => ['Brutosaurs'],
            'Pterrordaxes' => ['Pterrordaxes'],
            'Direhorns' => ['Direhorns'],
            'Falcosaurs' => [
                'wcm' => ['Raptors'],
                'icons' => ['falcosauro'],
            ],
            'Raptors' => [
                'wcm' => ['Raptors', 'Undead Raptors'],
                'icons' => ['raptor'],
            ],
        ],
        'Drakes' => [
            'Cloud Serpents' => ['Cloud Serpents'],
            'Drakes' => ['Drakes', 'Onyxian Drakes'],
            'Nether Drakes' => ['Nether Drakes'],
            'Stone Drakes' => ['Stone Drakes'],
            'Wind Drakes' => ['Wind Drakes'],
            'Grand Drakes' => ['Grand Drakes'],
            'Proto-Drakes' => ['Proto-Drakes'],
            'Undead Drakes' => ['Undead Drakes'],
            'Others' => ['Sinuous Drakes', 'Fey Drakes'],
        ],
        'Demons' => [
            'Demonic Steeds' => ['Demonic Steeds'],
            'Demonic Hounds' => ['Felstalkers', 'Vile Fiends', 'Antoran Hounds', 'Flying Felstalkers'],
            'Felsabers' => ['Felsabers'],
            'Infernals' => ['Infernals'],
            "Ur'zul" => ["Ur'zul"],
        ],
        'Dragonhawks' => ['Dragonhawks'],
        'Rylaks' => ['Rylaks'],
        'Elementals' => [
            'Elementals' => ['Elementals'],
            'Core Hounds' => ['Core Hounds'],
            'Sabers' => ['Flamesabers'],
            'Phoenixes' => ['Phoenixes'],
            'Stone Drakes' => ['Stone Drakes'],
            'Wind Drakes' => ['Wind Drakes'],
        ],
        'Feathermanes' => [
            'Gryphons' => ['Gryphons', 'Undead Gryphons'],
            'Hippogryphs' => ['Hippogryphs'],
            'Wolfhawks' => ['Wolfhawks'],
            'Wyverns' => ['Wind Riders', 'Undead Wind Riders'],
        ],
        'Fish' => [
            'Fish' => ['Fish'],
            'Stingrays' => ['Stingrays'],
            'Seahorses' => ['Seahorses'],
        ],
        'Horses' => [
            'Chargers' => [
                'wcm' => ['Horses'],
                'icons' => ['_paladinmount_', '_charger', 'nature_swiftness', 'alliancepvpmount', 'vicioushorse'],
                67466 => "Argent Warhorse",
                68187 => "Crusader's White Warhorse",
                68188 => "Crusader's Black Warhorse",
            ],
            'Demonic Steeds' => ['Demonic Steeds'],
            'Steeds' => [
                'wcm' => ['Horses'],
                'icons' => ['ridinghorse', 'nightmarehorse'],
            ],
            'Mountain Horses' => [
                'wcm' => ['Horses'],
                'icons' => ['dressedhorse', 'horse3'],
                103195 => "Mountain Horse",
                103196 => "Swift Mountain Horse",
            ],
            'Horned Steeds' => ['Horned Steeds', 'Windsteeds'],
            'Flying Steeds' => ['Flying Steeds', 'Windsteeds'],
            'Undead Steeds' => ['Undead Steeds'],
            'Mechanical Steeds' => ['Mechanical Steeds'],
        ],
        'Humanoids' => [
            'Gronnlings' => ['Gronnlings'],
            'Yetis' => ['Yeti'],
        ],
        'Insects' => [
            'Krolusks' => ['Krolusks'],
            'Silithids' => [
                'wcm' => ['Silithids',],
                239767 => 'Red Qiraji War Tank',
                239766 => 'Blue Qiraji War Tank',
            ],
            'Ravagers' => ['Ravagers'],
            'Water Striders' => ['Water Striders'],
        ],
        'Jellyfish' => ['Fathom Dwellers'],
        'Carnivorans' => [
            'Bears' => ['Bears'],
            'Hounds' => ['Dogs', 'Core Hounds', 'Felstalkers'],
            'Quilen' => ['Quilen'],
            'Foxes' => ['Foxes'],
            'Hyenas' => ['Hyenas'],
        ],
        'Reptiles' => [
            'Kodos' => [
                'wcm' => ['Kodos',],
                49378 => 'Brewfest Riding Kodo',
            ],
            'Mushan' => ['Mushan'],
            'Basilisks' => ['Basilisks'],
            'Sea Serpents' => ['Sea Serpents'],
            'Turtles' => ['Dragon Turtles', 'Sea Turtles', 'Turtles'],
        ],
        'Rats' => ['Rats'], //maybe Rodents later
        'Rays' => [
            'Nether Rays' => ['Nether Rays'],
            'Mana Rays' => ['Mana Rays'],
            'Stingrays' => ['Stingrays'],
        ],
        'Ungulates' => [
            'Boars' => ['Boars'],
            'Camels' => ['Camels'],
            'Elekks' => ['Elekks'],
            'Mammoths' => ['Mammoths'],
            'Moose' => ['Elderhorns'],
            'Rhinos' => ['Rhinos'],
            'Riverbeasts' => ['Riverbeasts'],
        ],
        'Vehicles' => [
            'Mechanostriders' => ['Mechanostriders'],
            'Scorpions' => ['Mechanical Scorpions'],
            'Steeds' => ['Mechanical Steeds'],
            'Motorcycles' => ['Motorcycles'],
            'Airships' => ['Skyships', 'Zeppelins', 'Flying Ships'],
            'Gyrocopters' => ['Gyrocopters'],
            'Mecha-suits' => ['Flying Mecha-suits'],
            'Rockets' => ['Rockets'],
            'Carpets' => ['Flying Carpets'],
            'Kites' => ['Kites'],
            'Discs' => ['Discs'],
        ],
        'Wolves' => [
            'Dire Wolves' => [
                'wcm' => ['Wolves'],
                'icons' => ['wolfdraenor', 'orcclanworg'],
                171851 => "Garn Nighthowl",
            ],
            'War Wolves' => [
                'wcm' => ['Wolves'],
                'icons' => ['hordepvpmount'],
            ],
            'Wolves' => [
                'wcm' => ['Wolves'],
                'icons' => ['direwolf'],
                16081 => "Arctic Wolf",
            ],
            'Undead Wolves' => ['Undead Wolves'],
        ],
    ],
];