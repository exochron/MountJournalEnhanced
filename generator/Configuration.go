package main

type familyConfig struct {
	Name      string
	Wcm       []string
	Icons     []string
	Spells    []int
	SubFamily []familyConfig
	Mounts    []mount
}

type config struct {
	Ignored []int

	FamilyMap []familyConfig
}

func LoadConfig() config {
	return config{
		Ignored: []int{
			459,    // Gray Wolf
			581,    // Winter Wolf
			8980,   // Skeletal Horse
			18363,  // Riding Kodo
			28828,  // Nether Drake
			55164,  // Swift Spectral Gryphon
			59572,  // Black Polar Bear
			60136,  // Grand Caravan Mammoth
			60140,  // Grand Caravan Mammoth
			62048,  // Black Dragonhawk Mount
			64656,  // Blue Skeletal Warhorse
			123182, // White Riding Yak
			127209, // Black Riding Yak
			127213, // Brown Riding Yak
			194046, // Swift Spectral Rylak
			205656, // Charger
			239363, // Swift Spectral Hippogryph
			254471, // Valorous Charger
			254472, // Vengeful Charger
			254473, // Vigilant Charger
			254474, // Golden Charger
			302794, // Swift Spectral Fathom Ray (inv_mount_hippogryph_arcane)
			302795, // Swift Spectral Magnetocraft (inv_mount_hippogryph_arcane)
			302796, // Swift Spectral Armored Gryphon (inv_mount_hippogryph_arcane)
			302797, // Swift Spectral Pterrordax (inv_mount_hippogryph_arcane)
		},

		// family based on http://www.warcraftmounts.com/gallery.php + https://wow.gamepedia.com/Beast
		FamilyMap: []familyConfig{
			{
				Name: "Amphibian",
				SubFamily: []familyConfig{
					{Name: "Crawgs", Wcm: []string{"Crawgs"}},
					{Name: "Toads", Wcm: []string{"Toads"}},
				},
			},
			{
				Name: "Arachnids",
				SubFamily: []familyConfig{
					{Name: "Blood Ticks", Wcm: []string{"Bloodswarmers"}},
					{Name: "Scorpions", Wcm: []string{"Scorpions", "Mechanical Scorpions"}},
					{Name: "Spiders", Wcm: []string{"Spiders"}},
				},
			},
			{
				Name: "Bats",
				Wcm:  []string{"Bats", "Felbats"},
			},
			{
				Name: "Birds",
				SubFamily: []familyConfig{
					{Name: "Albatross", Wcm: []string{"Birds"}, Icons: []string{"alabatross", "albatross"}},
					{Name: "Chickens", Wcm: []string{"Chickens"}},
					{Name: "Cranes", Wcm: []string{"Cranes"}},
					{Name: "Crows", Wcm: []string{"Birds"}, Icons: []string{"roguemount", "arcaneraven", "suncrown"}},
					{Name: "Dread Ravens", Wcm: []string{"Birds"}, Icons: []string{"ravenlord", "dreadraven"}},
					{Name: "Hawkstriders", Wcm: []string{"Hawkstriders"}},
					{Name: "Mechanical Birds", Wcm: []string{"Mechanical Birds"}},
					{Name: "Pandaren Phoenixes", Wcm: []string{"Birds"}, Icons: []string{"pandarenphoenix", "ji-kun", "thunderislebirdboss"}},
					{Name: "Parrots", Wcm: []string{"Birds"}, Icons: []string{"parrot"}},
					{Name: "Phoenixes", Wcm: []string{"Phoenixes"}},
					{Name: "Roc", Wcm: []string{"Deathrocs"}},
					{Name: "Tallstriders", Wcm: []string{"Tallstriders"}},
					{Name: "Talonbirds", Wcm: []string{"Talonbirds"}},
					{Name: "Vultures", Wcm: []string{"Birds"}, Icons: []string{"vulture"}},
				},
			},
			{
				Name: "Bovids",
				SubFamily: []familyConfig{
					{Name: "Clefthooves", Wcm: []string{"Clefthooves"}},
					{Name: "Goats", Wcm: []string{"Goats"}},
					{Name: "Rams", Wcm: []string{"Rams"}},
					{Name: "Ruinstriders", Wcm: []string{"Talbuks"}, Icons: []string{"argustalbukmount"}},
					{Name: "Talbuks", Wcm: []string{"Talbuks"}, Icons: []string{"foot_centaur", "talbukdraenor"}},
					{Name: "Tauralus", Wcm: []string{"Tauraluses"}},
					{Name: "Yaks", Wcm: []string{"Yaks"}},
				},
			},
			{
				Name: "Carnivorans",
				SubFamily: []familyConfig{
					{Name: "Bears", Wcm: []string{"Bears"}},
					{Name: "Foxes", Wcm: []string{"Foxes"}},
					{Name: "Gargon", Wcm: []string{"Gargons"}},
					{Name: "Hounds", Wcm: []string{"Dogs", "Core Hounds", "Felstalkers", "Darkhounds", "Soulseekers"}},
					{Name: "Hyenas", Wcm: []string{"Hyenas"}},
					{Name: "Quilen", Wcm: []string{"Quilen"}},
					{Name: "Vulpin", Wcm: []string{"Vulpin"}},
				},
			},
			{
				Name: "Cats",
				SubFamily: []familyConfig{
					{Name: "Lions", Wcm: []string{"Cats"}, Icons: []string{"lion", "goldenking"}, Spells: []int{98727}},                     // Winged Guardian
					{Name: "Manasabers", Wcm: []string{"Cats"}, Icons: []string{"suramarmount", "nightborneracial"}, Spells: []int{180545}}, // Mystic Runesaber
					{Name: "Mechanical Cats", Wcm: []string{"Mechanical Cats"}},
					{Name: "Others", Wcm: []string{"Flamesabers", "Panthara", "Felsabers", "Undead Cats"}},
					{Name: "Sabers", Wcm: []string{"Cats"}, Icons: []string{"blackpanther", "whitetiger", "pinktiger", "nightsaber2", "saber3mount"}},
					{Name: "Stone Cats", Wcm: []string{"Flying Stone Cats"}, Spells: []int{98727}}, // Winged Guardian
					{Name: "Tigers", Wcm: []string{"Cats", "Undead Cats"}, Icons: []string{"monkmount", "spectraltiger", "siberiantiger", "warnightsaber", "jungletiger"}},
				},
			},
			{
				Name: "Crabs",
				Wcm:  []string{"Crabs"},
			},
			{
				Name: "Demons",
				SubFamily: []familyConfig{
					{Name: "Demonic Hounds", Wcm: []string{"Felstalkers", "Vile Fiends", "Antoran Hounds", "Flying Felstalkers"}},
					{Name: "Demonic Steeds", Wcm: []string{"Demonic Steeds"}},
					{Name: "Felsabers", Wcm: []string{"Felsabers"}},
					{Name: "Infernals", Wcm: []string{"Infernals"}},
					{Name: "Ur'zul", Wcm: []string{"Ur'zul"}},
				},
			},
			{
				Name: "Dinosaurs",
				SubFamily: []familyConfig{
					{Name: "Brutosaurs", Wcm: []string{"Brutosaurs"}},
					{Name: "Direhorns", Wcm: []string{"Direhorns"}},
					{Name: "Falcosaurs", Wcm: []string{"Raptors"}, Icons: []string{"falcosauro"}},
					{Name: "Pterrordaxes", Wcm: []string{"Pterrordaxes"}},
					{Name: "Raptors", Wcm: []string{"Raptors", "Undead Raptors"}, Icons: []string{"raptor"}},
				},
			},
			{
				Name: "Dragonhawks",
				Wcm:  []string{"Dragonhawks"},
			},
			{
				Name: "Drakes",
				SubFamily: []familyConfig{
					{Name: "Cloud Serpents", Wcm: []string{"Cloud Serpents"}},
					{Name: "Drakes", Wcm: []string{"Drakes", "Onyxian Drakes", "Void Dragons"}},
					{Name: "Grand Drakes", Wcm: []string{"Grand Drakes"}},
					{Name: "Nether Drakes", Wcm: []string{"Nether Drakes"}},
					{Name: "Others", Wcm: []string{"Sinuous Drakes", "Fey Drakes", "Everwyrms", "Mechanical Dragons"}},
					{Name: "Proto-Drakes", Wcm: []string{"Proto-Drakes"}},
					{Name: "Stone Drakes", Wcm: []string{"Stone Drakes"}},
					{Name: "Undead Drakes", Wcm: []string{"Undead Drakes", "Soul Eaters"}},
					{Name: "Wind Drakes", Wcm: []string{"Wind Drakes"}},
				},
			},
			{
				Name: "Elementals",
				SubFamily: []familyConfig{
					{Name: "Core Hounds", Wcm: []string{"Core Hounds"}},
					{Name: "Phoenixes", Wcm: []string{"Phoenixes"}},
					{Name: "Sabers", Wcm: []string{"Flamesabers"}},
					{Name: "Stone Drakes", Wcm: []string{"Stone Drakes"}},
					{Name: "Wind Drakes", Wcm: []string{"Wind Drakes"}},
					{Name: "Others", Wcm: []string{"Elementals", "Ancients"}},
				},
			},
			{
				Name: "Feathermanes",
				SubFamily: []familyConfig{
					{Name: "Gryphons", Wcm: []string{"Gryphons", "Undead Gryphons"}},
					{Name: "Hippogryphs", Wcm: []string{"Hippogryphs"}},
					{Name: "Larion", Wcm: []string{"Larions"}},
					{Name: "Wolfhawks", Wcm: []string{"Wolfhawks"}},
					{Name: "Wyverns", Wcm: []string{"Wind Riders", "Undead Wind Riders"}},
				},
			},
			{
				Name: "Fish",
				SubFamily: []familyConfig{
					{Name: "Fish", Wcm: []string{"Fish"}},
					{Name: "Seahorses", Wcm: []string{"Seahorses", "Hippocampuses"}},
					{Name: "Stingrays", Wcm: []string{"Stingrays"}},
				},
			},
			{
				Name: "Horses",
				SubFamily: []familyConfig{
					{
						Name:  "Chargers",
						Wcm:   []string{"Horses"},
						Icons: []string{"_paladinmount_", "_charger", "nature_swiftness", "alliancepvpmount", "vicioushorse", "paladin_divinesteed", "horsekultiran", "hordehorse"},
						Spells: []int{
							67466, //Argent Warhorse
							68187, //Crusader's White Warhorse
							68188, //Crusader's Black Warhorse
						},
					},
					{
						Name: "Demonic Steeds",
						Wcm:  []string{"Demonic Steeds"},
						Spells: []int{
							232412, // Netherlord's Chaotic Wrathsteed
							238452, // Netherlord's Brimstone Wrathsteed
							238454, // Netherlord's Accursed Wrathsteed
						},
					},
					{Name: "Flying Steeds", Wcm: []string{"Flying Steeds", "Windsteeds"}},
					{Name: "Horned Steeds", Wcm: []string{"Horned Steeds", "Windsteeds"}},
					{Name: "Mechanical Steeds", Wcm: []string{"Mechanical Steeds"}},
					{
						Name:  "Mountain Horses",
						Wcm:   []string{"Horses"},
						Icons: []string{"dressedhorse", "horse3"},
						Spells: []int{
							103195, //Mountain Horse
							103196, //Swift Mountain Horse
						},
					},
					{Name: "Steeds", Wcm: []string{"Horses"}, Icons: []string{"ridinghorse", "nightmarehorse"}},
					{Name: "Undead Steeds", Wcm: []string{"Undead Steeds"}},
				},
			},
			{
				Name: "Humanoids",
				SubFamily: []familyConfig{
					{Name: "Gronnlings", Wcm: []string{"Gronnlings"}},
					{Name: "Gorger", Wcm: []string{"Anima Gorgers"}},
					{Name: "Yetis", Wcm: []string{"Yeti"}},
				},
			},
			{
				Name: "Insects",
				SubFamily: []familyConfig{
					{Name: "Animite", Wcm: []string{"Animites"}},
					{Name: "Aqir Flyers", Wcm: []string{"Aqir Flyers"}},
					{Name: "Bees", Wcm: []string{"Bees"}},
					{
					    Name: "Gorm",
					    Wcm: []string{"Gorm"},
                        Spells: []int{ // somehow WCM has currently wrong mount ids for gorm
                            334364, // Spinemaw Gladechewer
                            312763, // Darkwarren Hardshell
                            334365, // Pale Acidmaw
                            340503, // Umbral Scythehorn
                            348769, // Vicious War
                            348770, // Vicious War Gorm
                            352441, // Wild Hunt Legsplitter
                        },
					},
					{Name: "Flies", Wcm: []string{"Flies"}},
					{Name: "Krolusks", Wcm: []string{"Krolusks"}},
					{Name: "Moth", Wcm: []string{"Moths"}},
					{Name: "Ravagers", Wcm: []string{"Ravagers"}},
					{
						Name: "Silithids",
						Wcm:  []string{"Silithids"},
						Spells: []int{
							239767, //Red Qiraji War Tank
							239766, //Blue Qiraji War Tank
						},
					},
					{Name: "Water Striders", Wcm: []string{"Water Striders"}},
				},
			},
			{
				Name: "Jellyfish",
				Wcm:  []string{"Fathom Dwellers", "Hiveminds"},
			},
			{
				Name: "Rats", //maybe Rodents later
				Wcm:  []string{"Rats"},
			},
			{
				Name: "Rays",
				SubFamily: []familyConfig{
					{Name: "Fathom Rays", Wcm: []string{"Fathom Rays"}},
					{Name: "Mana Rays", Wcm: []string{"Mana Rays"}},
					{Name: "Nether Rays", Wcm: []string{"Nether Rays"}},
					{Name: "Stingrays", Wcm: []string{"Stingrays"}},
				},
			},
			{
				Name: "Reptiles",
				SubFamily: []familyConfig{
					{Name: "Basilisks", Wcm: []string{"Basilisks"}},
					{Name: "Crocolisks", Wcm: []string{"Crocolisks"}},
					{Name: "Kodos", Wcm: []string{"Kodos"}, Spells: []int{49378}}, //Brewfest Riding Kodo
					{Name: "Mushan", Wcm: []string{"Mushan"}},
					{Name: "N'Zoth Serpents", Wcm: []string{"N'Zoth Serpents"}},
					{Name: "Sea Serpents", Wcm: []string{"Sea Serpents"}},
					{Name: "Snapdragons", Wcm: []string{"Snapdragons"}},
					{Name: "Shardhides", Wcm: []string{"Shardhides"}},
					{Name: "Turtles", Wcm: []string{"Dragon Turtles", "Sea Turtles", "Turtles"}},
					{Name: "Others", Wcm: []string{"Warp Stalkers"}},
				},
			},
			{
				Name: "Rylaks",
				Wcm:  []string{"Rylaks", "Chimaeras"},
			},
			{
				Name: "Ungulates",
				SubFamily: []familyConfig{
					{Name: "Alpacas", Wcm: []string{"Alpacas"}},
					{Name: "Boars", Wcm: []string{"Boars", "Divine Boars", "Skullboars"}},
					{Name: "Camels", Wcm: []string{"Camels"}},
					{Name: "Elekks", Wcm: []string{"Elekks"}},
					{Name: "Mammoths", Wcm: []string{"Mammoths"}},
					{Name: "Moose", Wcm: []string{"Elderhorns"}},
					{Name: "Ox", Wcm: []string{"Oxen"}},
					{Name: "Rhinos", Wcm: []string{"Rhinos"}},
					{Name: "Riverbeasts", Wcm: []string{"Riverbeasts"}},
					{Name: "Runestag", Wcm: []string{"Runestags"}},
				},
			},
			{
				Name: "Vehicles",
				SubFamily: []familyConfig{
					{Name: "Airplanes", Wcm: []string{"Airplanes"}},
					{Name: "Airships", Wcm: []string{"Skyships", "Zeppelins", "Flying Ships"}},
					{Name: "Assault Wagons", Wcm: []string{"Assault Wagons"}},
					{Name: "Carpets", Wcm: []string{"Flying Carpets"}},
					{Name: "Discs", Wcm: []string{"Discs"}},
					{Name: "Gyrocopters", Wcm: []string{"Gyrocopters"}},
					{Name: "Hands", Wcm: []string{"Undead Hands"}},
					{Name: "Hovercraft", Wcm: []string{"Hovercraft"}},
					{Name: "Jet Aerial Units", Wcm: []string{"Jet Aerial Units"}},
					{Name: "Kites", Wcm: []string{"Kites"}},
					{Name: "Mecha-suits", Wcm: []string{"Flying Mecha-suits"}},
					{Name: "Mechanical Animals", Wcm: []string{"Mechanical Scorpions", "Mechanical Steeds", "Mechanical Birds", "Mechanical Cats", "Mechanical Dragons"}},
					{Name: "Mechanostriders", Wcm: []string{"Mechanostriders"}},
					{Name: "Motorcycles", Wcm: []string{"Motorcycles", "Monocycles"}},
					{Name: "Rockets", Wcm: []string{"Rockets"}},
					{Name: "Seat", Wcm: []string{"Flying Seats"}},
					{Name: "Spider Tanks", Wcm: []string{"Spider Tanks"}},
				},
			},
			{
				Name: "Wolves",
				SubFamily: []familyConfig{
					{Name: "Dire Wolves", Wcm: []string{"Wolves"}, Icons: []string{"wolfdraenor", "orcclanworg"}, Spells: []int{171851}}, // Garn Nighthowl
					{Name: "Undead Wolves", Wcm: []string{"Undead Wolves"}},
					{Name: "War Wolves", Wcm: []string{"Wolves"}, Icons: []string{"hordepvpmount", "alliancewolf", "armoredwolf", "frostwolfhowler"}, Spells: []int{306421}}, // Frostwolf Snarler
					{Name: "Wilderlings", Wcm: []string{"Wilderlings"},},
					{Name: "Wolves", Wcm: []string{"Wolves"}, Icons: []string{"direwolf"}, Spells: []int{16081}},                                                             // Arctic Wolf
				},
			},
		},
	}
}
