local ADDON_NAME, ADDON = ...

if (GetLocale() == 'frFR') then
    local L = ADDON.L or {}

    L["Black Market"] = "Marché Noir"
    L["Family"] = "Famille"
    --[[Translation missing --]]
    --[[ L["FAVOR_DISPLAYED"] = "All Displayed"--]]
    --[[Translation missing --]]
    --[[ L["FAVOR_PER_CHARACTER"] = "Per Character"--]]
    L["Flying"] = "Volante"
    L["Ground"] = "Terrestre"
    L["Hidden"] = "Cachées"
    --[[Translation missing --]]
    --[[ L["Only tradable"] = "Only tradable"--]]
    L["Only usable"] = "Utilisables"
    L["Passenger"] = "Passagers"
    L["Reset filters"] = "Réinitialiser les filtres"
    --[[Translation missing --]]
    --[[ L["Show in Collections"] = "Show in Collections"--]]
    --[[Translation missing --]]
    --[[ L["TASK_END"] = "[MJE] Phew! I'm done."--]]
    --[[Translation missing --]]
    --[[ L["TASK_FAVOR_START"] = "[MJE] Reapplying stars all over your mounts. Please wait a few seconds until I'm finished."--]]
    L["Transform"] = "Transformation"
    L["Underwater"] = "Aquatiques"
    L["Water Walking"] = "Marche sur l'eau"

    -- Families
    --[[Translation missing --]]
    --[[ L["Airships"] = "Airships"--]]
    --[[Translation missing --]]
    --[[ L["Amphibian"] = "Amphibian"--]]
    --[[Translation missing --]]
    --[[ L["Arachnids"] = "Arachnids"--]]
    --[[Translation missing --]]
    --[[ L["Assault Wagons"] = "Assault Wagons"--]]
    L["Basilisks"] = "Basilics"
    L["Bats"] = "Chauve-Souris"
    L["Bears"] = "Ours"
    L["Birds"] = "Oiseaux"
    --[[Translation missing --]]
    --[[ L["Blood Ticks"] = "Blood Ticks"--]]
    L["Boars"] = "Sangliers"
    --[[Translation missing --]]
    --[[ L["Bovids"] = "Bovids"--]]
    L["Brutosaurs"] = "Brontosaurus"
    L["Camels"] = "Dromadaires"
    --[[Translation missing --]]
    --[[ L["Carnivorans"] = "Carnivorans"--]]
    --[[Translation missing --]]
    --[[ L["Carpets"] = "Carpets"--]]
    L["Cats"] = "Félins"
    --[[Translation missing --]]
    --[[ L["Chargers"] = "Chargers"--]]
    --[[Translation missing --]]
    --[[ L["Chickens"] = "Chickens"--]]
    L["Clefthooves"] = "Sabot-Fourchus"
    --[[Translation missing --]]
    --[[ L["Cloud Serpents"] = "Cloud Serpents"--]]
    --[[Translation missing --]]
    --[[ L["Core Hounds"] = "Core Hounds"--]]
    --[[Translation missing --]]
    --[[ L["Crabs"] = "Crabs"--]]
    L["Cranes"] = "Grues"
    --[[Translation missing --]]
    --[[ L["Crawgs"] = "Crawgs"--]]
    L["Crocolisks"] = "Crocilisque"
    --[[Translation missing --]]
    --[[ L["Crows"] = "Crows"--]]
    L["Demonic Hounds"] = "Molosses Démoniaques"
    --[[Translation missing --]]
    --[[ L["Demonic Steeds"] = "Demonic Steeds"--]]
    --[[Translation missing --]]
    --[[ L["Demons"] = "Demons"--]]
    --[[Translation missing --]]
    --[[ L["Dinosaurs"] = "Dinosaurs"--]]
    --[[Translation missing --]]
    --[[ L["Dire Wolves"] = "Dire Wolves"--]]
    L["Direhorns"] = "Navrecornes"
    --[[Translation missing --]]
    --[[ L["Discs"] = "Discs"--]]
    L["Dragonhawks"] = "Faucon-Dragons"
    L["Drakes"] = "Drakes"
    --[[Translation missing --]]
    --[[ L["Dread Ravens"] = "Dread Ravens"--]]
    L["Elekks"] = "Elekks"
    L["Elementals"] = "Élémentaires"
    --[[Translation missing --]]
    --[[ L["Falcosaurs"] = "Falcosaurs"--]]
    --[[Translation missing --]]
    --[[ L["Fathom Rays"] = "Fathom Rays"--]]
    --[[Translation missing --]]
    --[[ L["Feathermanes"] = "Feathermanes"--]]
    --[[Translation missing --]]
    --[[ L["Felsabers"] = "Felsabers"--]]
    L["Fish"] = "Poissons"
    --[[Translation missing --]]
    --[[ L["Flying Steeds"] = "Flying Steeds"--]]
    L["Foxes"] = "Renards"
    L["Goats"] = "Chèvres"
    --[[Translation missing --]]
    --[[ L["Grand Drakes"] = "Grand Drakes"--]]
    L["Gronnlings"] = "Gronnlins"
    L["Gryphons"] = "Griffons"
    --[[Translation missing --]]
    --[[ L["Gyrocopters"] = "Gyrocopters"--]]
    L["Hawkstriders"] = "Faucon-Pérégrins"
    L["Hippogryphs"] = "Hippogriffes"
    --[[Translation missing --]]
    --[[ L["Horned Steeds"] = "Horned Steeds"--]]
    L["Horses"] = "Chevaux"
    L["Hounds"] = "Molosses"
    --[[Translation missing --]]
    --[[ L["Hovercraft"] = "Hovercraft"--]]
    --[[Translation missing --]]
    --[[ L["Humanoids"] = "Humanoids"--]]
    L["Hyenas"] = "Hyènes"
    L["Infernals"] = "Infernaux"
    --[[Translation missing --]]
    --[[ L["Insects"] = "Insects"--]]
    L["Jellyfish"] = "Méduses"
    --[[Translation missing --]]
    --[[ L["Jet Aerial Units"] = "Jet Aerial Units"--]]
    --[[Translation missing --]]
    --[[ L["Kites"] = "Kites"--]]
    L["Kodos"] = "Kodos"
    --[[Translation missing --]]
    --[[ L["Krolusks"] = "Krolusks"--]]
    --[[Translation missing --]]
    --[[ L["Lions"] = "Lions"--]]
    L["Mammoths"] = "Mammouths"
    --[[Translation missing --]]
    --[[ L["Mana Rays"] = "Mana Rays"--]]
    --[[Translation missing --]]
    --[[ L["Manasabers"] = "Manasabers"--]]
    --[[Translation missing --]]
    --[[ L["Mechanical Animals"] = "Mechanical Animals"--]]
    --[[Translation missing --]]
    --[[ L["Mechanical Birds"] = "Mechanical Birds"--]]
    --[[Translation missing --]]
    --[[ L["Mechanical Cats"] = "Mechanical Cats"--]]
    --[[Translation missing --]]
    --[[ L["Mechanical Steeds"] = "Mechanical Steeds"--]]
    L["Mechanostriders"] = "Mécanotrotteurs"
    --[[Translation missing --]]
    --[[ L["Mecha-suits"] = "Mecha-suits"--]]
    L["Moose"] = "Élans"
    --[[Translation missing --]]
    --[[ L["Motorcycles"] = "Motorcycles"--]]
    --[[Translation missing --]]
    --[[ L["Mountain Horses"] = "Mountain Horses"--]]
    L["Mushan"] = "Mushans"
    --[[Translation missing --]]
    --[[ L["Nether Drakes"] = "Nether Drakes"--]]
    --[[Translation missing --]]
    --[[ L["Nether Rays"] = "Nether Rays"--]]
    --[[Translation missing --]]
    --[[ L["Others"] = "Others"--]]
    --[[Translation missing --]]
    --[[ L["Pandaren Phoenixes"] = "Pandaren Phoenixes"--]]
    L["Parrots"] = "Psittaciformes"
    L["Phoenixes"] = "Phénix"
    --[[Translation missing --]]
    --[[ L["Proto-Drakes"] = "Proto-Drakes"--]]
    L["Pterrordaxes"] = "Pterreurdactyles"
    --[[Translation missing --]]
    --[[ L["Quilen"] = "Quilen"--]]
    L["Rams"] = "Béliers"
    L["Raptors"] = "Raptors"
    L["Rats"] = "Rats"
    L["Ravagers"] = "Saccageurs"
    L["Rays"] = "Raies"
    --[[Translation missing --]]
    --[[ L["Reptiles"] = "Reptiles"--]]
    L["Rhinos"] = "Rhinocéros"
    L["Riverbeasts"] = "Potamodontes"
    --[[Translation missing --]]
    --[[ L["Rockets"] = "Rockets"--]]
    --[[Translation missing --]]
    --[[ L["Ruinstriders"] = "Ruinstriders"--]]
    --[[Translation missing --]]
    --[[ L["Rylaks"] = "Rylaks"--]]
    --[[Translation missing --]]
    --[[ L["Sabers"] = "Sabers"--]]
    L["Scorpions"] = "Scorpides"
    --[[Translation missing --]]
    --[[ L["Sea Serpents"] = "Sea Serpents"--]]
    L["Seahorses"] = "Hippocampes"
    L["Silithids"] = "Silithides"
    --[[Translation missing --]]
    --[[ L["Snapdragons"] = "Snapdragons"--]]
    --[[Translation missing --]]
    --[[ L["Spider Tanks"] = "Spider Tanks"--]]
    L["Spiders"] = "Araignées"
    --[[Translation missing --]]
    --[[ L["Steeds"] = "Steeds"--]]
    --[[Translation missing --]]
    --[[ L["Stingrays"] = "Stingrays"--]]
    --[[Translation missing --]]
    --[[ L["Stone Cats"] = "Stone Cats"--]]
    --[[Translation missing --]]
    --[[ L["Stone Drakes"] = "Stone Drakes"--]]
    L["Talbuks"] = "Talbuks"
    L["Tallstriders"] = "Trotteurs"
    L["Talonbirds"] = "Rapaces"
    --[[Translation missing --]]
    --[[ L["Tigers"] = "Tigers"--]]
    --[[Translation missing --]]
    --[[ L["Toads"] = "Toads"--]]
    L["Turtles"] = "Tortues"
    --[[Translation missing --]]
    --[[ L["Undead Drakes"] = "Undead Drakes"--]]
    --[[Translation missing --]]
    --[[ L["Undead Steeds"] = "Undead Steeds"--]]
    --[[Translation missing --]]
    --[[ L["Undead Wolves"] = "Undead Wolves"--]]
    --[[Translation missing --]]
    --[[ L["Ungulates"] = "Ungulates"--]]
    --[[Translation missing --]]
    --[[ L["Ur'zul"] = "Ur'zul"--]]
    --[[Translation missing --]]
    --[[ L["Vehicles"] = "Vehicles"--]]
    --[[Translation missing --]]
    --[[ L["War Wolves"] = "War Wolves"--]]
    L["Water Striders"] = "Trotteurs aquatiques"
    --[[Translation missing --]]
    --[[ L["Wind Drakes"] = "Wind Drakes"--]]
    --[[Translation missing --]]
    --[[ L["Wolfhawks"] = "Wolfhawks"--]]
    L["Wolves"] = "Loups"
    L["Wyverns"] = "Wyvernes"
    L["Yaks"] = "Yacks"
    L["Yetis"] = "Yétis"

    -- Settings
    --[[Translation missing --]]
    --[[ L["SETTING_COMPACT_LIST"] = "Compact mount list"--]]
    --[[Translation missing --]]
    --[[ L["SETTING_CURSOR_KEYS"] = "Enable Up&Down keys to browse mounts"--]]
    --[[Translation missing --]]
    --[[ L["SETTING_FAVORITE_PER_CHAR"] = "Favorite mounts per character"--]]
    --[[Translation missing --]]
    --[[ L["SETTING_MOVE_EQUIPMENT"] = "Move equipment slot into display"--]]
    --[[Translation missing --]]
    --[[ L["SETTING_SHOP_BUTTON"] = "Show shop button at untrained shop mounts"--]]
    --[[Translation missing --]]
    --[[ L["SETTING_YCAMERA"] = "Unlock Y rotation with mouse in display"--]]

    ADDON.L = L
end